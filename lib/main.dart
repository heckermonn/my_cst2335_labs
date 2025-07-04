import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'ProfilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserRepository().loadLoginData(); // Load login + profile
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 5 Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/profilePage': (context) => const ProfilePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final repo = UserRepository();
  var imageSource = "images/question-mark.png";

  @override
  void initState() {
    super.initState();
    _username.text = repo.loginUsername;
    _password.text = repo.loginPassword;

    if (_password.text.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        const snackBar = SnackBar(content: Text('Login Auto-Filled'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void loginClicked() {
    if (_password.text != "QWERTY123") {
      setState(() {
        imageSource = "images/stop.png";
      });
      return;
    }

    setState(() {
      imageSource = "images/idea.png";
    });

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Save Information'),
        content: const Text('Would you like to save your login info for next time?'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              repo.loginUsername = _username.text;
              repo.loginPassword = _password.text;
              await repo.saveData();
              Navigator.of(context).pop();
              goToProfile();
            },
            child: const Text('Yes'),
          ),
          FilledButton(
            onPressed: () async {
              await EncryptedSharedPreferences().clear();
              Navigator.of(context).pop();
              goToProfile();
            },
            child: const Text('No'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              goToProfile();
            },
            child: const Text('Later'),
          ),
        ],
      ),
    );
  }

  void goToProfile() {
    repo.loginUsername = _username.text;
    Navigator.pushNamed(context, '/profilePage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _username,
              decoration: const InputDecoration(
                hintText: "Username",
                border: OutlineInputBorder(),
                labelText: "Login",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loginClicked,
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            Semantics(child: Image.asset(imageSource)),
          ],
        ),
      ),
    );
  }
}

// REPOSITORY PATTERN
class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;

  UserRepository._internal();

  // Text fields
  final fName = TextEditingController();
  final lName = TextEditingController();
  final phoneNum = TextEditingController();
  final eAddress = TextEditingController();

  // Login values (stored as plain strings)
  String loginUsername = "";
  String loginPassword = "";

  // Save only profile-related data
  Future<void> saveProfileData() async {
    final prefs = EncryptedSharedPreferences();
    await prefs.setString("fName", fName.text);
    await prefs.setString("lName", lName.text);
    await prefs.setString("phoneNum", phoneNum.text);
    await prefs.setString("eAddress", eAddress.text);
  }

  // Load only profile-related data
  Future<void> loadData() async {
    final prefs = EncryptedSharedPreferences();
    fName.text = await prefs.getString("fName") ?? "";
    lName.text = await prefs.getString("lName") ?? "";
    phoneNum.text = await prefs.getString("phoneNum") ?? "";
    eAddress.text = await prefs.getString("eAddress") ?? "";
  }

  // Save login credentials
  Future<void> saveData() async {
    final prefs = EncryptedSharedPreferences();
    await prefs.setString("usrName", loginUsername);
    await prefs.setString("usrPwd", loginPassword);
  }

  // Load login + profile data
  Future<void> loadLoginData() async {
    final prefs = EncryptedSharedPreferences();
    loginUsername = await prefs.getString("usrName") ?? "";
    loginPassword = await prefs.getString("usrPwd") ?? "";

    // Also preload profile
    await loadData();
  }
}
