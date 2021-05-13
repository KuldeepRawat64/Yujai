import 'package:flutter/material.dart';
import 'package:Yujai/models/post.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewTaskForm extends StatefulWidget {
  @override
  _NewTaskFormState createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  final _formKey = GlobalKey<FormState>();
  Post post = new Post();
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: TextFormField(
                    key: Key("nameField"),
                    onSaved: (val) => post.caption = val,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty)
                        return "Please enter a name for your task";
                      return null;
                    },
                  ),
                ),
                imageFile != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          overflow: Overflow.visible,
                          children: [
                            Image.file(
                              imageFile,
                              fit: BoxFit.fill,
                            ),
                            Positioned(
                              right: 5.0,
                              top: 5.0,
                              child: InkResponse(
                                onTap: () {
                                  if (imageFile != null) {
                                    setState(() {
                                      imageFile = null;
                                    });
                                  }
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.close),
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(''),
                FlatButton(
                  child: Icon(Icons.photo),
                  onPressed: () {
                    _pickImage('Gallery').then((selectedImage) {
                      setState(() {
                        imageFile = selectedImage;
                      });
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;
    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().getImage(source: ImageSource.gallery)
        : await ImagePicker().getImage(source: ImageSource.camera);
    return File(selectedImage.path);
  }

  _submitForm(BuildContext context) {
    //
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.of(context).pop();
    }
  }
}
