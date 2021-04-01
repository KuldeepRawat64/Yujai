import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

class FeedBack extends StatefulWidget {
  final String currentUserId;
  FeedBack({this.currentUserId});
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  List<String> attachments = [];
  bool isHTML = false;
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final _recipientController = TextEditingController(
    text: 'animusitmanagement@gmail.com',
  );
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
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
        backgroundColor: new Color(0xfff6f6f6),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.5,
          //    centerTitle: true,
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
            'Submit a Feedback',
            style: TextStyle(
              fontSize: screenSize.height * 0.022,
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
                //  color: const Color(0xffffffff),
                // padding: EdgeInsets.all(8.0),
                child: TextField(
                  readOnly: true,
                  style: TextStyle(fontSize: screenSize.height * 0.018),
                  controller: _recipientController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    labelText: 'Recipient',
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.012,
              ),
              Container(
                //  color: const Color(0xffffffff),
                child: TextField(
                  style: TextStyle(fontSize: screenSize.height * 0.018),
                  controller: _subjectController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    labelText: 'Subject',
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.012,
              ),
              Container(
                //   color: const Color(0xffffffff),
                child: TextField(
                  style: TextStyle(fontSize: screenSize.height * 0.018),
                  controller: _bodyController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    labelText: 'Body',
                  ),
                ),
              ),
              CheckboxListTile(
                title: Text(
                  'HTML',
                  style: TextStyle(fontSize: screenSize.height * 0.018),
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
            style: TextStyle(fontSize: screenSize.height * 0.018),
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
