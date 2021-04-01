import 'dart:io';
import 'dart:math';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:core';
import 'package:image/image.dart' as Im;
import 'home.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Article extends StatefulWidget {
  File imageFile;

  Article({
    this.imageFile,
  });

  @override
  _ArticleState createState() => _ArticleState();
}

class ArticleType {
  int id;
  String name;
  ArticleType(this.id, this.name);
  static List<ArticleType> getArticleType() {
    return <ArticleType>[
      ArticleType(1, 'Music'),
      ArticleType(2, 'Business'),
      ArticleType(3, 'Professional'),
      ArticleType(4, 'Food'),
      ArticleType(5, 'Drink'),
      ArticleType(6, 'Community'),
      ArticleType(7, 'Culture'),
      ArticleType(8, 'Performing'),
      ArticleType(9, 'Visula Art'),
      ArticleType(10, 'Film'),
      ArticleType(11, 'Media'),
      ArticleType(12, 'Entertainment'),
      ArticleType(13, 'Sports'),
      ArticleType(14, 'Fitness'),
      ArticleType(15, 'Health'),
      ArticleType(16, 'Wellness'),
      ArticleType(17, 'Science'),
      ArticleType(18, 'Technology'),
      ArticleType(19, 'Travel'),
      ArticleType(20, 'Outdoor'),
      ArticleType(21, 'Gaming'),
      ArticleType(22, 'Charity'),
      ArticleType(23, 'Cause'),
      ArticleType(24, 'Religion'),
      ArticleType(25, 'Spirituality'),
      ArticleType(26, 'Family'),
      ArticleType(27, 'Education'),
      ArticleType(28, 'Seasonal'),
      ArticleType(29, 'Holiday'),
    ];
  }
}

class Capacity {
  int id;
  String name;
  Capacity(this.id, this.name);
  static List<Capacity> getCapacity() {
    return <Capacity>[
      Capacity(1, '1 - 10'),
      Capacity(1, '1 - 50'),
      Capacity(1, '1 - 100'),
      Capacity(1, '1 - 1000'),
    ];
  }
}

class _ArticleState extends State<Article> {
  TextEditingController captionController = TextEditingController();
  TextEditingController hostNameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController ticketNameController = TextEditingController();
  TextEditingController numTicketsController = TextEditingController();
  TextEditingController saleStartController = TextEditingController();
  TextEditingController saleEndController = TextEditingController();
  TextEditingController ticketVisibilityController = TextEditingController();
  TextEditingController salesChannelController = TextEditingController();
  TextEditingController ticketPerHeadMinController = TextEditingController();
  TextEditingController ticketPerHeadMaxController = TextEditingController();
  String selectedStatus;
  bool isSelectedStatusLocation;
  final format = DateFormat('yyyy-MM-dd HH:mm');
  String selectedPrice;
  bool isSelectedPriceFree;
  final _repository = Repository();

  @override
  void initState() {
    super.initState();
    selectedStatus = "Location";
    isSelectedStatusLocation = true;
    selectedPrice = "Free";
    isSelectedPriceFree = true;
  }

  setSelectedStatus(String val) {
    setState(() {
      selectedStatus = val;
    });
  }

  setSelectedPrice(String val) {
    setState(() {
      selectedPrice = val;
    });
  }

  List<DropdownMenuItem<ArticleType>> buildDropDownMenuArticleType(
      List articleTypes) {
    List<DropdownMenuItem<ArticleType>> items = List();
    for (ArticleType articleType in articleTypes) {
      items.add(
        DropdownMenuItem(
          value: articleType,
          child: Text(articleType.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Capacity>> buildDropDownMenuCapacity(List capacities) {
    List<DropdownMenuItem<Capacity>> items = List();
    for (Capacity capacity in capacities) {
      items.add(
        DropdownMenuItem(
          value: capacity,
          child: Text(capacity.name),
        ),
      );
    }
    return items;
  }

  bool _visibility = true;

  void _changeVisibility(bool visibility) {
    setState(() {
      _visibility = visibility;
    });
  }

  @override
  void dispose() {
    captionController.dispose();
    hostNameController?.dispose();
    super.dispose();
  }

  submit() {
    if (captionController.text.isNotEmpty &&
        websiteController.text.isNotEmpty) {
      //To show CircularProgressIndicator
      _changeVisibility(false);

      _repository.getCurrentUser().then((currentUser) {
        if (currentUser != null) {
          compressImage();
          _repository.retreiveUserDetails(currentUser).then((user) {
            _repository.uploadImageToStorage(widget.imageFile).then((url) {
              _repository
                  .addNewsToDb(
                user,
                url,
                captionController.text,
                websiteController.text,
              )
                  .then((value) {
                print('News added to db');
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              }).catchError(
                      (e) => print('Error adding current news to db : $e'));
            }).catchError((e) {
              print('Error uploading image to storage : $e');
            });
          });
        } else {
          print('Current User is null');
        }
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black54,
              size: screenSize.height * 0.045,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Create Article',
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xffffffff),
          //  centerTitle: true,
          actions: [
            _visibility
                ? Padding(
                    padding: EdgeInsets.only(right: screenSize.width / 30),
                    child: GestureDetector(
                      child: Icon(
                        Icons.send,
                        color: Colors.black54,
                        size: screenSize.height * 0.035,
                      ),
                      onTap: submit,
                    ),
                  )
                : Container(),
          ],
        ),
        body: ListView(
          children: [
            !_visibility ? linearProgress() : Container(),
            widget.imageFile != null
                ? Container(
                    height: screenSize.height * 0.26,
                    //  width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 21 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(widget.imageFile),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width / 11,
                vertical: screenSize.height * 0.012,
              ),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Heading',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        // width: screenwidth,
                        child: TextFormField(
                          autocorrect: true,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                          controller: captionController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffffffff),
                            hintText: "Write a title",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: screenSize.height * 0.012),
                        child: Text(
                          'Article Source',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        //  width: width,
                        child: TextField(
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                          controller: websiteController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffffffff),
                            hintText: "https://link",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);
    Im.Image image = Im.decodeImage(widget.imageFile.readAsBytesSync());
    //Im.copyResize(image, height: 500);
    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
    setState(() {
      widget.imageFile = newim2;
    });
    print('done');
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }
}
