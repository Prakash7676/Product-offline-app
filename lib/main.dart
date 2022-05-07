import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Product Offline App",
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: HomePage(),
    );
  }
}


//SQLite is a C-language library that implements a small, fast, self-contained,
// high-reliability, full-featured, SQL database engine. 
//SQLite is the most used database engine in the world. 
//SQLite is built into all mobile phones and most computers and
// comes bundled inside countless other applications that people use every day.
// using db browser for sqlite