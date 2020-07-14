import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition_flutter/povider/text_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TextProvider>(
      create: (context) => TextProvider(),
      child: MaterialApp(
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
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File pickedImage;
  final _picker = ImagePicker();
  final _textRecognizer = FirebaseVision.instance.textRecognizer();
  TextProvider _textProvider;

  _pickImage() async {
    var awaitImage = await _picker.getImage(
      source: ImageSource.gallery,
    );

    if (awaitImage == null) return;
    pickedImage = File(awaitImage.path);
    _textProvider.setImage(pickedImage);
    _textProvider.uploadImage(true);

    FirebaseVisionImage _visionImage =
        FirebaseVisionImage.fromFile(pickedImage);
    VisionText visionText = await _textRecognizer.processImage(_visionImage);
    _textProvider.decodeText(visionText.blocks);
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _textProvider = Provider.of<TextProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(blurRadius: 20),
                      ],
                    ),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    height: 250,
                    child: _textProvider.imgStatus
                        ? Image.file(
                            _textProvider.image,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/unnamed.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _textProvider.text.trim().isEmpty
                        ? 'No Images selected'
                        : _textProvider.text.trim(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: Icon(Icons.search),
      ),
    );
  }
}
