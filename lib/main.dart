import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition_flutter/povider/image_dectectation_provider.dart';
import 'package:text_recognition_flutter/povider/text_provider.dart';
import 'package:text_recognition_flutter/screen/face_detection_screen.dart';
import 'package:text_recognition_flutter/screen/text_recognition_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TextProvider>(
          create: (context) => TextProvider(),
        ),
        ChangeNotifierProvider<ImageDetectionProvider>(
          create: (context) => ImageDetectionProvider(),
        ),
      ],
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
            headline4: TextStyle(color: Colors.red),
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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _customContainer(
              context: context,
              label: 'Text Recognition',
              nextPage: TextRecognitionScreen(),
            ),
            SizedBox(
              height: 20,
            ),
            _customContainer(
              context: context,
              label: 'Face Detection',
              nextPage: FaceDetectationScreen(),
            )
          ],
        ),
      ),
    );
  }

  _customContainer({BuildContext context, Widget nextPage, String label}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColorDark,
          width: 2,
        ),
      ),
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => nextPage,
            ),
          );
        },
        child: Text(
          label,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        shape: StadiumBorder(),
      ),
    );
  }
}
