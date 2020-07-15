import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageDetectionProvider with ChangeNotifier {
  List<Rect> _rect = new List<Rect>();
  bool _imgUploaded = false;

  var _imageFile;
  void setImageFile(img) {
    _imageFile = img;
  }

  get imageFile => _imageFile;
  bool get imgStatus => _imgUploaded;

  List<Rect> get rect => [..._rect];

  bool get imageProcessing => _imgUploaded;
  
  void isImageProcessed(bool isUploded) {
    _imgUploaded = isUploded;
    notifyListeners();
  }

  void decodeFace(List<Face> faces) {
    if (_rect.length > 0) {
      _rect = new List<Rect>();
    }
    for (Face face in faces) {
      _rect.add(face.boundingBox);

      final double rotY =
          face.headEulerAngleY; // Head is rotated to the right rotY degrees
      final double rotZ =
          face.headEulerAngleZ; // Head is tilted sideways rotZ degrees
      print('the rotation y is ' + rotY.toStringAsFixed(2));
      print('the rotation z is ' + rotZ.toStringAsFixed(2));
    }
    notifyListeners();
  }
}
