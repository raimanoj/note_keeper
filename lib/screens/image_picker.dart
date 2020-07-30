import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickers extends StatefulWidget {
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePickers> {
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
      ),
      body: Center(
        child: _image == null ? Text("No Image Selected") : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _optionsDialogBox,
        child: Icon(Icons.add_a_photo),
        tooltip: "Open Camera",
      ),
    );
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "Open Camera",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onTap: openCamera,
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                  ),
                  GestureDetector(
                    child: Text(
                      "Select Image from Gallery",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onTap: openGallery,
                  )
                ],
              ),
            ),
          );
        });
  }

  Future openCamera() async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future openGallery() async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
}



/* Container(
                height: 110,
                child: Row(
                  children: <Widget>[
                    Image(
                      image: FileImage(File(noteList[position].imagePath)),
                      width: 100,
                      height: 100,
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            noteList[position].title,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(child: Text(noteList[position].descriptions)),
                        Expanded(child: Text(noteList[position].date))
                      ],
                    ),
                    Align(
                      alignment: FractionalOffset.centerRight,
                      child: CircleAvatar(
                        backgroundColor:
                            getPriorityColor(this.noteList[position].priority),
                        child:
                            getPriorityIcon(this.noteList[position].priority),
                      ),
                    )
                  ],
                ),
              ) */
