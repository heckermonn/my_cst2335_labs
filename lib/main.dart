import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  var _counter = 0.0;
  var myFontSize = 30.0;
  late TextEditingController _username;
  late TextEditingController _password;
  var imageSource = "images/question-mark.png";

  @override
  void initState() {
    super.initState();
    _username = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if(_counter < 99.0) {
        _counter++;
      }
    });
  }
  buttonClicked() {
    setState(() {
      if(_password.value.text != "QWERTY123"){
          imageSource = "images/stop.png";
      }else{
          imageSource = "images/idea.png";
      }
      });
  }
  setNewValue(double value)
  {
    setState(() {
      _counter = value;
      myFontSize = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            TextField(controller: _username,
              decoration: InputDecoration(
              hintText:"Username",
              border: OutlineInputBorder(),
              labelText:"Login"
              )),

            TextField(controller: _password,
                obscureText:true,
                decoration: InputDecoration(
                    hintText:"Password",
                    border: OutlineInputBorder(),
                    labelText:"Password"
                )),

            ElevatedButton(onPressed:buttonClicked, child: Text("Login")),


            Semantics(child: Image.asset(imageSource)),

            Text('You have pushed the button this many times:', style: TextStyle(fontSize: myFontSize)),

            Text('$_counter', style: TextStyle(fontSize: myFontSize)),

            Slider(value:myFontSize, max:100.0, onChanged: setNewValue, min:0.0)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
