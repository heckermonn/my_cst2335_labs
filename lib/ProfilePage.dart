import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final repo = UserRepository();

  @override
  void initState() {
    super.initState();
    repo.loadData();
    // Add listeners to save data on change
    repo.fName.addListener(repo.saveProfileData);
    repo.lName.addListener(repo.saveProfileData);
    repo.phoneNum.addListener(repo.saveProfileData);
    repo.eAddress.addListener(repo.saveProfileData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome Back, ${repo.loginUsername}!')),
      );
    });
  }

  @override
  void dispose() {
    repo.fName.removeListener(repo.saveProfileData);
    repo.lName.removeListener(repo.saveProfileData);
    repo.phoneNum.removeListener(repo.saveProfileData);
    repo.eAddress.removeListener(repo.saveProfileData);
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showUnsupportedDialog(url);
    }
  }

  void _showUnsupportedDialog(String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('URL Not Supported'),
        content: Text('This device cannot open: $url'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Widget _buildPhoneNumberRow() {
    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: repo.phoneNum,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone Number'),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            _launchUrl('tel:${repo.phoneNum.text}');
          },
          child: const Icon(Icons.call),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            _launchUrl('sms:${repo.phoneNum.text}');
          },
          child: const Icon(Icons.sms),
        ),
      ],
    );
  }

  Widget _buildEmailRow() {
    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: repo.eAddress,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email Address'),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            _launchUrl('mailto:${repo.eAddress.text}');
          },
          child: const Icon(Icons.mail),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = repo.loginUsername;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Welcome Back, $userName!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: repo.fName,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: repo.lName,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),

            const SizedBox(height: 20),

            _buildPhoneNumberRow(),

            const SizedBox(height: 20),

            _buildEmailRow(),
          ],
        ),
      ),
    );
  }
}
