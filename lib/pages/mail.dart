import 'dart:async';
import 'package:Yujai/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

class Mail extends StatefulWidget {
  final String postId;
  final String eventId;
  final String postOwnerId;
  final String postMediaUrl;
  final String postOwnerMail;

  Mail({
    this.postId,
    this.eventId,
    this.postOwnerId,
    this.postMediaUrl,
    this.postOwnerMail,
  });

  @override
  MailState createState() => MailState(
        postId: this.postId,
        eventId: this.eventId,
        postOwnerId: this.postOwnerId,
        postMediaUrl: this.postMediaUrl,
        postOwnerMail: this.postOwnerMail,
      );
}

class MailState extends State<Mail> {
  List<String> attachments = [];
  bool isHTML = false;
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final _recipientController = TextEditingController();
  static String recipient;
  final _subjectController = TextEditingController(text: 'The subject');
  final _bodyController = TextEditingController(text: 'Mail body');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String postId;
  final String eventId;
  final String postOwnerId;
  final String postMediaUrl;
  final String postOwnerMail;

  MailState({
    this.postId,
    this.eventId,
    this.postOwnerId,
    this.postMediaUrl,
    this.postOwnerMail,
  });

  @override
  void initState() {
    super.initState();
    _recipientController.text = '$postOwnerMail';
  }

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    var snackBar = SnackBar(
      content: Text(platformResponse),
    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        key: _scaffoldKey,
        appBar: AppBar(
          // centerTitle: true,
          elevation: 0.5,
          backgroundColor: const Color(0xffffffff),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Theme.of(context).primaryColorLight,
              size: 30.0,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Send Mail',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: send,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).primaryColorLight,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                    ),
                    controller: _recipientController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Recipient',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                    ),
                    controller: _subjectController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Subject',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                    ),
                    controller: _bodyController,
                    maxLines: 10,
                    decoration: InputDecoration(
                        labelText: 'Body', border: OutlineInputBorder()),
                  ),
                ),
                CheckboxListTile(
                  title: Text(
                    'HTML',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onChanged: (bool value) {
                    setState(() {
                      isHTML = value;
                    });
                  },
                  value: isHTML,
                ),
                ...attachments.map(
                  (item) => Text(
                    item,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera),
          label: Text(
            'Add Image',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textBody1(context),
            ),
          ),
          onPressed: _openImagePicker,
        ),
      ),
    );
  }

  void _openImagePicker() async {
    PickedFile pick = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      attachments.add(pick.path);
    });
  }
}
