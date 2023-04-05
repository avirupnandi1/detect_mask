// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output;
  final Imagepicker = ImagePicker();

  List _predictions = [];
  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  detect_Image(File image) async {
    var pred = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true);

    setState(() {
      _loading = false;
      _output = pred;
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite',
        labels: 'assets/labels.txt',
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false);
  }

  _loadimage_gallery() async {
    var image = await Imagepicker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detect_Image(_image);
  }

  _loadimage_camera() async {
    var image = await Imagepicker.getImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detect_Image(_image);
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Face Mask Detection",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 212, 4, 25),
        ),
        body: Container(
            height: h,
            width: w,
            color: Colors.black38,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 15,
                ),
                Container(
                    height: 170,
                    width: 250,
                    padding: EdgeInsets.all(10),
                    child: Image.network(
                        'https://www.onlygfx.com/wp-content/uploads/2021/01/face-mask-clipart-1-300x154.png')),
                Container(
                    child: Text(
                  "Detect Mask",
                  style: GoogleFonts.robotoFlex(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                )),
                SizedBox(
                  height: 7,
                ),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        _loadimage_camera();
                      },
                      child: Text('Camera'),
                    )),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      _loadimage_gallery();
                    },
                    child: Text('Gallery'),
                  ),
                ),
                _loading != true
                    ? Container(
                        child: Column(
                          children: [
                            Container(
                              height: 400,
                              // width: double.infinity,
                              padding: EdgeInsets.all(15),
                              child: Image.file(_image),
                            ),
                            _output != null
                                ? Text(
                                    (_output[0]['label'])
                                        .toString()
                                        .substring(2),
                                    style: GoogleFonts.roboto(fontSize: 18))
                                : Text(''),
                            _output != null
                                ? Text(
                                    'Confidence: ' +
                                        (_output[0]['confidence']).toString(),
                                    style: GoogleFonts.roboto(fontSize: 18))
                                : Text('')
                          ],
                        ),
                      )
                    : Container()
              ],
            )));
  }
}
