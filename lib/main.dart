import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
                color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        brightness: Brightness.dark,
        accentColor: Colors.redAccent,
        primaryColorLight: Colors.red.shade400,
        primaryColorDark: Colors.red.shade900,
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _text = 'No text yet...';
  File pickedImage;
  bool imageLoaded = false;
  final _picker = ImagePicker();
  final _textRecognizer = FirebaseVision.instance.textRecognizer();

  _pickImage() async {
    var awaitImage = await _picker.getImage(
      source: ImageSource.gallery,
    );

    if (awaitImage == null) return;

    setState(() {
      pickedImage = File(awaitImage.path);
      imageLoaded = true;
    });

    FirebaseVisionImage _visionImage =
        FirebaseVisionImage.fromFile(pickedImage);
    VisionText visionText = await _textRecognizer.processImage(_visionImage);
    var tmp = " ";
    visionText.blocks.forEach((textBlock) {
      print('-->> ${textBlock.text}');
      tmp = tmp + textBlock.text;
    });

    
    setState(() {
      _text = tmp;
      imageLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition'),
      ),
      body: Center(
        child: imageLoaded ? CircularProgressIndicator() : Text(_text),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: Icon(Icons.search),
      ),
    );
  }
}
