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
        title: 'Text Reader',
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
          primaryColor: Colors.red,
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.red),
            bodyText2: TextStyle(color: Colors.red),
            // bodyText2: TextStyle(color: Colors.white),
            headline3: TextStyle(color: Colors.red),
            //Alert Box Title
            headline6: TextStyle(color: Colors.red.shade900),
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

  _retrieveText(awaitImage) async {
    pickedImage = File(awaitImage.path);
    _textProvider.setImage(pickedImage);
    _textProvider.uploadImage(true);

    FirebaseVisionImage _visionImage =
        FirebaseVisionImage.fromFile(pickedImage);
    VisionText visionText = await _textRecognizer.processImage(_visionImage);
    _textProvider.decodeText(visionText.blocks);
  }

  _getImagefromCamera() async {
    var awaitImage = await _picker.getImage(
      source: ImageSource.camera,
    );

    if (awaitImage == null) return;
    _retrieveText(awaitImage);
  }

  _getImagefromGallery() async {
    var awaitImage = await _picker.getImage(
      source: ImageSource.gallery,
    );

    if (awaitImage == null) return;
    _retrieveText(awaitImage);
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(blurRadius: 20),
                ],
              ),
              margin: const EdgeInsets.symmetric(vertical: 16),
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
          Expanded(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectImageDialog(context: context),
        child: Icon(Icons.search),
      ),
    );
  }

  _buttonContainer({
    BuildContext context,
    IconData icon,
    Function function,
    String title,
  }) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Container(
      height: _height * 0.12,
      width: _width * 0.24,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).primaryColorDark,
            width: 2,
          )),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        splashColor: Colors.red.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                icon,
                size: _width * 0.12,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        onTap: function,
      ),
    );
  }

  _selectImageDialog({@required BuildContext context}) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Alert Dialog"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buttonContainer(
                  context: context,
                  icon: Icons.image,
                  title: 'Gallery',
                  function: () {
                    print('Gallery Cliced');

                    _getImagefromGallery();
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                _buttonContainer(
                  context: context,
                  icon: Icons.camera_alt,
                  title: 'Camera',
                  function: () {
                    print('Camera Clicked');
                    _getImagefromCamera();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
