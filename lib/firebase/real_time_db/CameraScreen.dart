import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  @override  State<StatefulWidget> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? imageFile;

  @override  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Image Capturing'),
      centerTitle: true,
    ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageFile != null)
              Container(
                width: 648,
                height: 488,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(image: FileImage(imageFile!)),
                    border: Border.all(width: 8, color: Colors.black12),
                    borderRadius: BorderRadius.circular(12.0)),
              )
            else
              Container(
                width: 648,
                height: 488,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(width: 8, color: Colors.black12),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Text('Image Should Appear Here',
                    style: TextStyle(fontSize: 26)),
              ),
            SizedBox(
              height: 28,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () => getImage(source: ImageSource.camera),
                  child: Text(
                    'Image Capture',
                    style: TextStyle(fontSize: 18),
                  ),
                )),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () => getImage(source: ImageSource.gallery),
                  child: Text(
                    'Select Image',
                    style: TextStyle(fontSize: 18),
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
      });
    }
  }
}
