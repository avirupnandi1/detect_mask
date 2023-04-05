import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.amberAccent,
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
