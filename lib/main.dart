import 'package:flutter/material.dart';
import 'package:flutter_bottom/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(primaryColor: Colors.white, primarySwatch: Colors.orange),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
