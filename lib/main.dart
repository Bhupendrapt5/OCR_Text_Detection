import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: Colors.black87,
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.red),
            // bodyText2: TextStyle(color: Colors.white),
            headline6: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.red),
          // bodyText2: TextStyle(color: Colors.white),
          headline3: TextStyle(color: Colors.red),
        ),
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition'),
      ),
      body: Center(
        child: Text('HEllo'),
      ),
    );
  }
}
