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
      home: const MyHomePage(title: 'CST2335 Lab 3 - Louis Tran'),
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
  var myFontSize = 30.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row( // Header
              children: <Widget>[
                Expanded(
                  child: Text("Browse Categories".toUpperCase(), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),)),
              ],
            ),
            Row( // h2
              children: <Widget>[
                Expanded(
                  child: Text("Not sure about exactly which recipe you're looking for? Do a search, or dive into our most popular categories.", textAlign: TextAlign.left,),
                )
              ],
            ),
            Row( // Header
              children: <Widget>[
                Expanded(
                  child: Text("By Meat".toUpperCase(), textAlign: TextAlign.center,),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: CircleAvatar(
                    backgroundImage: AssetImage('images/beef.jpeg'),
                    radius:100
                  ),
                ),
                Expanded(
                    child: CircleAvatar(
                        backgroundImage: AssetImage('images/chicken.jpeg'),
                        radius:100
                    ),
                ),
                Expanded(
                  child: CircleAvatar(
                      backgroundImage: AssetImage('images/pork.jpeg'),
                      radius:100
                  ),
                ),
                Expanded(child: CircleAvatar(
                    backgroundImage: AssetImage('images/shrimp.jpg'),
                    radius:100
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("By Course".toUpperCase(), textAlign: TextAlign.center,),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: CircleAvatar(
                      backgroundImage: AssetImage('images/mains.jpg'),
                      radius:100
                  ),
                ),
                Expanded(
                  child: CircleAvatar(
                      backgroundImage: AssetImage('images/salad.jpg'),
                      radius:100
                  ),
                ),
                Expanded(
                  child: CircleAvatar(
                      backgroundImage: AssetImage('images/sides.jpg'),
                      radius:100
                  ),
                ),
                Expanded(child: CircleAvatar(
                    backgroundImage: AssetImage('images/crockpot.jpg'),
                    radius:100
                ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("By Dessert".toUpperCase(), textAlign: TextAlign.center,),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: CircleAvatar(
                      backgroundImage: AssetImage('images/algonquin.png'),
                      radius:100
                  ),
                ),
                Expanded(
                  child: CircleAvatar(
                      backgroundImage: AssetImage('images/algonquin.png'),
                      radius:100
                  ),
                ),
                Expanded(
                  child: CircleAvatar(
                      backgroundImage: AssetImage('images/algonquin.png'),
                      radius:100
                  ),
                ),
                Expanded(child: CircleAvatar(
                    backgroundImage: AssetImage('images/algonquin.png'),
                    radius:100
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
