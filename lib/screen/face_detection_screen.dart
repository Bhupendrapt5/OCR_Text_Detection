import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition_flutter/helper/camera_helper.dart';
import 'package:text_recognition_flutter/povider/image_dectectation_provider.dart';
import 'package:text_recognition_flutter/widget/face_painter.dart';

class FaceDetectationScreen extends StatelessWidget {
  final _camHelper = CameraHelper();

  _retrieveText(
      {PickedFile awaitImage, ImageDetectionProvider imageProvider}) async {
    if (awaitImage == null) return;

    File pickedImage;
    var imageFile;

    imageFile = await awaitImage.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);

    imageProvider.setImageFile(imageFile);

    pickedImage = File(awaitImage.path);

    FirebaseVisionImage _visionImage =
        FirebaseVisionImage.fromFile(pickedImage);
    // VisionText visionText = await _textRecognizer.processImage(_visionImage);
    final _faceRecognizer = FirebaseVision.instance.faceDetector();

    final List<Face> faces = await _faceRecognizer.processImage(_visionImage);
    imageProvider.decodeFace(faces);
    _faceRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    ImageDetectionProvider _imageProvider =
        Provider.of<ImageDetectionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detection'),
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
              child: _imageProvider.rect.length != 0
                  ? FittedBox(
                      child: SizedBox(
                        width: _imageProvider.imageFile.width.toDouble(),
                        height: _imageProvider.imageFile.height.toDouble(),
                        child: CustomPaint(
                          painter: FacePainter(
                              rect: _imageProvider.rect,
                              imageFile: _imageProvider.imageFile),
                        ),
                      ),
                    )
                  : Image.asset(
                      'assets/images/unnamed.jpg',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _selectImageDialog(context: context, imageProvider: _imageProvider),
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

  _selectImageDialog(
      {@required BuildContext context,
      @required ImageDetectionProvider imageProvider}) {
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
                  function: () async {
                    print('Gallery Clicked');
                    var awaitImage = await _camHelper.getImagefromGallery();
                    _retrieveText(
                        awaitImage: awaitImage, imageProvider: imageProvider);
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
                  function: () async {
                    print('Camera Clicked');
                    var awaitImage = await _camHelper.getImagefromCamera();
                    _retrieveText(
                        awaitImage: awaitImage, imageProvider: imageProvider);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
