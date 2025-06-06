import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _username;
  late TextEditingController _password;
  var imageSource = "images/question-mark.png";

  @override
  void initState() {
    super.initState();

    getSharedPreferences();

    _username = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                controller: _username,
                decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(),
                    labelText: "Login"
                )),

            TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(),
                    labelText: "Password"
                )),

            ElevatedButton(onPressed: loginClicked, child: Text("Login")),

            Semantics(child: Image.asset(imageSource)),
          ],
        ),
      ),
    );
  }


  void loginClicked() {
    showDialog(context: context, builder: (BuildContext context) =>
        AlertDialog(
          title: const Text('Save Information'),
          content: const Text(
              'Would you like to save your login info for next time?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
                prefs.setString("usrName", _username.value.text);
                prefs.setString("usrPwd", _password.value.text);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),),
            FilledButton(
              onPressed: () {
                EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
                prefs.clear();
                Navigator.of(context).pop();
              },
              child: const Text('No'),),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Later'),)
          ],
        ),
    );
    setState(() {
      if (_password.value.text != "QWERTY123") {
        imageSource = "images/stop.png";
      } else {
        imageSource = "images/idea.png";
      }
    });
  }

  void getSharedPreferences() async {
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    var strUsr = await prefs.getString("usrName");
    var strPwd = await prefs.getString("usrPwd");

    if (strPwd.isNotEmpty) {
      _username.text = strUsr;
      _password.text = strPwd;
      Future.delayed(Duration.zero, () {
        const snackBar = SnackBar(content: Text('Login Auto-Filled'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }
}
