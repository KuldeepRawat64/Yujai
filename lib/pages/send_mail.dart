import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

class SendMail extends StatefulWidget {
  final String email;
  SendMail({this.email});
  @override
  _SendMailState createState() => _SendMailState();
}

class _SendMailState extends State<SendMail> {
  List<String> attachments = [];
  bool isHTML = false;
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final _recipientController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _repository = Repository();
  FirebaseUser currentUser;

  @override
  void initState() {
    _recipientController.text = widget.email;
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
    super.initState();
  }

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text + '\n Sent from Yujai',
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

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: const Color(0xffffffff),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black54,
              size: screenSize.height * 0.045,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Connect via Mail',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            _recipientController.text.isNotEmpty &&
                    _subjectController.text.isNotEmpty &&
                    _bodyController.text.isNotEmpty
                ? IconButton(
                    onPressed: send,
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).accentColor,
                    ),
                  )
                : Container()
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            screenSize.width / 11,
            screenSize.height * 0.012,
            screenSize.width / 11,
            screenSize.height * 0.05,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: screenSize.height * 0.09,
                // padding: EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                  ),
                  controller: _recipientController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    border: OutlineInputBorder(),
                    labelText: 'Recipient',
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.012,
              ),
              Container(
                height: screenSize.height * 0.09,
                child: TextField(
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                  ),
                  controller: _subjectController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    border: OutlineInputBorder(),
                    labelText: 'Subject',
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.012,
              ),
              Container(
                child: TextField(
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                  ),
                  controller: _bodyController,
                  maxLines: 10,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      labelText: 'Body',
                      border: OutlineInputBorder()),
                ),
              ),
              CheckboxListTile(
                title: Text(
                  'HTML',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
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
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(
            Icons.camera,
            size: screenSize.height * 0.04,
          ),
          label: Text(
            'Add Image',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textButton(context),
              color: Colors.white,
              fontWeight: FontWeight.bold,
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
