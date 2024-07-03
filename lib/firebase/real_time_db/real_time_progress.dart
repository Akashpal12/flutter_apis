import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apis/firebase/real_time_db/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class RealTimeDB extends StatefulWidget {
  const RealTimeDB({Key? key}) : super(key: key);

  @override
  State<RealTimeDB> createState() => _RealTimeDBState();
}

class _RealTimeDBState extends State<RealTimeDB> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realtime Database'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: SingleChildScrollView(
                                child: MyCard(
                                  imageFile: imageFile,
                                  onCameraPressed: () async {
                                    await getImage(
                                      source: ImageSource.camera,
                                      setState: setState,
                                    );
                                  },
                                  onGalleryPressed: () async {
                                    await getImage(
                                      source: ImageSource.gallery,
                                      setState: setState,
                                    );
                                  },
                                  showToast: showToast,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: Text(
                  'Add Record',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6200EE),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getImage({
    required ImageSource source,
    required void Function(void Function()) setState,
  }) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class MyCard extends StatefulWidget {
  final File? imageFile;
  final VoidCallback? onCameraPressed;
  final VoidCallback? onGalleryPressed;
  final Function(String) showToast;

  const MyCard({
    Key? key,
    this.imageFile,
    this.onCameraPressed,
    this.onGalleryPressed,
    required this.showToast,
  }) : super(key: key);

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _saving = false; // Track whether data is being saved
  double _uploadProgress = 0; // Track upload progress

  void _validateAndSave() async {
    if (_nameController.text.isEmpty) {
      widget.showToast('Please enter your name');
      return;
    }
    if (_ageController.text.isEmpty) {
      widget.showToast('Please enter your age');
      return;
    }
    if (widget.imageFile == null) {
      widget.showToast('Please capture an image');
      return;
    }

    setState(() {
      _saving = true; // Start saving state
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(
        widget.imageFile!,
        // Create a metadata property to store information about the file
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      // Listen to the upload state changes
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      final user = UserData(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        imageUrl: imageUrl,
      );

      final databaseRef = FirebaseDatabase.instance.ref().child('users').push();
      await databaseRef.set(user.toJson());

      Navigator.of(context).pop(); // Close the dialog
      widget.showToast('Record saved successfully');

    } catch (e) {
      Navigator.of(context).pop(); // Close the dialog
      widget.showToast('Error saving data: $e');
    } finally {
      setState(() {
        _saving = false; // End saving state
        _uploadProgress = 0; // Reset progress
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFF6F4F4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Please Enter Name',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF10202),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Please Enter Age',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Color(0xFFF10202), width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (widget.imageFile != null)
                Container(
                  width: 648,
                  height: 488,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                      image: FileImage(widget.imageFile!),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(width: 8, color: Colors.black12),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                )
              else
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8uBcxORBL1dd26haxsL1qRDpLs0_sIaciIQ&s',
                  height: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: widget.onCameraPressed,
                    child:
                    Text('Camera', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF006064),
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: widget.onGalleryPressed,
                    child:
                    Text('Gallery', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF006064),
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              // Display progress indicator if saving
              SizedBox(height: 10),
              if (_saving)
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: _uploadProgress,
                      minHeight: 10,
                      backgroundColor: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    SizedBox(height: 10),
                    Text('${(_uploadProgress * 100).toStringAsFixed(2)}%'),
                  ],
                )
              else
                ElevatedButton(
                  onPressed: _validateAndSave,
                  child: Text('Save Record',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF006064),
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
