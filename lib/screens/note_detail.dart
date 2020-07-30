import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/model/Note.dart';
import 'package:note_keeper/screens/note_list.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:path_provider/path_provider.dart';

class NoteDetail extends StatefulWidget {
  String appBarTitle;
  Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(note, appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Note note;

  NoteDetailState(this.note, this.appBarTitle);

  var _priorities = ["Low", "High"];

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  File _image;
  String _selectedPriorities = "";

  @override
  initState() {
    super.initState();
    _selectedPriorities = _priorities[0];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    descriptionController.text = note.descriptions;
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen(false);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => moveToLastScreen(false)),
            title: Text(appBarTitle),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _optionsDialogBox,
            child: Icon(Icons.add_a_photo),
            tooltip: "Open Camera",
          ),
          body: Container(
            margin: EdgeInsets.all(15),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String dropDownItem) {
                      return DropdownMenuItem(
                          value: dropDownItem, child: Text(dropDownItem));
                    }).toList(),
                    onChanged: (String valueSelected) {
                      setState(() {
                        debugPrint("User selected $valueSelected");
                        updatePriorityAsInt(valueSelected);
                      });
                    },
                    value: getPriorityAsString(note.priority),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: TextField(
                    controller: titleController,
                    onChanged: (value) {
                      debugPrint("Something changed $value");
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: TextField(
                    controller: descriptionController,
                    onChanged: (value) {
                      debugPrint("Something changed $value");
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                Container(
                  width: 200,
                  height: 200,
                  child: Center(
                    child: note.imagePath != null
                        ? Image(image: FileImage(File(note.imagePath)))
                        : _image != null
                            ? Image.file(_image)
                            : Text("No Image Selected"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              elevation: 5,
                              child: Text(
                                "Save",
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: () {
                                if (titleController.text.isEmpty ||
                                    descriptionController.text.isEmpty) {
                                  debugPrint("Empty fields");
                                  return;
                                }
                                if (note.id == null) {
                                  if (_image == null) return;
                                }
                                setState(() {
                                  _save();
                                });
                              },
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white)),
                      Container(width: 15),
                      Expanded(
                          child: RaisedButton(
                        elevation: 5,
                        child: Text(
                          "Delete",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Delete button clicked");
                            _delete();
                          });
                        },
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen(bool refresh) {
    Navigator.pop(context, refresh);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case "Low":
        note.priority = 1;
        break;
      case "High":
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.descriptions = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen(true);
    note.date = DateFormat.yMMMEd().format(DateTime.now());
    int result = note.id != null
        ? await databaseHelper.updateNote(note)
        : await databaseHelper.insertNote(note);
    // _showAlertDialog("Status", result >= 0 ? "Saved Successfully" : "Error");
  }

  void _delete() async {
    if (note.id == null) return;
    moveToLastScreen(true);
    int result = await databaseHelper.deleteNote(note.id);
    _showAlertDialog("Status", result >= 0 ? "Deleted Successfully" : "Error");
  }

  void _showAlertDialog(String title, String message) {
    var dialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => dialog);
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
    var dir = await getApplicationDocumentsDirectory();
    String path = dir.path;
    File newImg = await image
        .copy("$path${image.path.substring(image.path.lastIndexOf("/"))}");
    note.imagePath = newImg.path;
    debugPrint("Image Path Camera ${newImg.path} \n ${image.path}");
    setState(() {
      _image = image;
    });
  }

  Future openGallery() async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var dir = await getApplicationDocumentsDirectory();
    String path = dir.path;
    File newImg = await image
        .copy("$path${image.path.substring(image.path.lastIndexOf("/"))}");
    note.imagePath = newImg.path;
    debugPrint("Image Path Gallery ${newImg.path} \n ${image.path}");
    setState(() {
      _image = image;
    });
  }
}
