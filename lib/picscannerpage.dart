import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import './painters.dart';
class PicScannerPage extends StatefulWidget {
  @override
  _PicScannerPageState createState() => _PicScannerPageState();
}

class _PicScannerPageState extends State<PicScannerPage> {
  File _imageFile;
  Size _imageSize;
  dynamic _scanResults;
  
  final FaceDetector _faceDetector = FirebaseVision.instance.faceDetector();

  Future<void> _getImage() async{
    final _wid = MediaQuery.of(context).size.width;
    setState(() {
      _imageFile = null;
      _imageSize = null;
    });
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // ImageProperties properties = await FlutterNativeImage.getImageProperties(image.path);
    // File newFile = await FlutterNativeImage.compressImage(
    //       image.path, quality: 100, 
    //       targetWidth: (_wid -40).round(), 
    //       targetHeight: (properties.height * (_wid -40).round() / properties.width).round());
    if(image != null){
      _scanImage(image);
      _getImageSize(image);
    }
    setState(() {
      _imageFile = image;
    });
  }

  Future<void> _scanImage(File imageFile) async {
    setState(() {
      _scanResults = null;
    });

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    dynamic results;
    results = await _faceDetector.processImage(visionImage);
    if(results !=null){
      print('scanned results $results');
    }

    setState(() {
      _scanResults = results;
    });
  }


  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  CustomPaint _buildResults(Size imageSize, dynamic results) {
    CustomPainter painter;
    painter = FaceDetectorPainter(_imageSize, results);

    return CustomPaint(
      painter: painter,
    );
  }
  Widget _buildImage(){
    return Container(  
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(  
        image: DecorationImage(  
          image: Image.file(_imageFile).image,
          fit: BoxFit.fill
        ),
      ),
      child: _imageSize == null || _scanResults == null?
        Center( 
          child: Text("Still scanning...", style: TextStyle(color: Colors.cyan, fontSize: 25, fontWeight: FontWeight.bold),),
        ):
        _buildResults(_imageSize, _scanResults)
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  
        title: Text("Scan Image"),
        elevation: 6,
      ),
      body: _imageFile == null ?
      const Center(child: Text("No image selected"))
        : _buildImage(),
      floatingActionButton: FloatingActionButton( 
        onPressed: _getImage,
        tooltip: "Select Image",
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}


