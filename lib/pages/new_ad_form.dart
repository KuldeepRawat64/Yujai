import 'package:Yujai/pages/keys.dart';
import 'package:Yujai/pages/places_location.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/models/post.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as Im;
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/models/group.dart';
import '../style.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewAdForm extends StatefulWidget {
  final Group group;
  final UserModel currentUser;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  const NewAdForm({Key key, this.group, this.currentUser}) : super(key: key);
  @override
  _NewAdFormState createState() => _NewAdFormState();
}

class _NewAdFormState extends State<NewAdForm> {
  // String _path;
  // Map<String, String> _paths;
  // String _extension;
  // FileType _pickType;
  // bool _multiPick = true;
  // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // List<UploadTask> _tasks = <UploadTask>[];
  final _formKey = GlobalKey<FormState>();
  Post post = new Post();
  File imageFile;
  var _locationController;
  var _captionController;
  var _descriptionController;
  // var _hostController;
  // var _eventWebsiteController;
  // var _ticketWebsiteController;
  final _repository = Repository();
  String location = '';
  final format = DateFormat('yyyy-MM-dd');
  int startDate = 0;
  int endDate = 0;
  int startTime = 0;
  int endTime = 0;
  List<String> imgUrls = [];
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  // FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UploadTask> uploadedTasks = [];
  PickResult selectedPlace;
  final CarouselController _controller = CarouselController();
  String reason = '';
  int _current = 0;
  double lat, lng;
  String latitude;
  String longitude;
  var locationMessage = "";
  // Position _currentPosition;

  var _priceController;

  List<String> conditionList = ["New", "Used", "Like New", "Good", "Ok"];
  String selectedConditionList;

  List<String> categoryList = [
    'Smartphone',
    'Real estate',
    'Computers',
    'Households',
    'Charity',
    'Automobiles',
    'Spare parts',
    'Books & Stationary'
  ];

  List<File> selectedFiles = [];
  String imgUrl;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController();
    _locationController = TextEditingController();
    _descriptionController = TextEditingController();
    // _hostController = TextEditingController();
    // _eventWebsiteController = TextEditingController();
    // _ticketWebsiteController = TextEditingController();
    _priceController = TextEditingController();
  }

  uploadFileToStorage(File file) {
    UploadTask task = _firebaseStorage
        .ref()
        .child("images/${DateTime.now().toString()}")
        .putFile(file);
    return task;
  }

  saveImageUrlToFirebase(UploadTask task) {
    task.snapshotEvents.listen((snapShot) {
      if (task.snapshot.state == TaskState.success) {
        snapShot.ref.getDownloadURL().then((imageUrl) {
          setState(() {
            imgUrls.add(imageUrl);
          });
        });
      }
    });
  }

  Future selectFileToUpload() async {
    try {
      FilePickerResult result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);
      if (result != null) {
        selectedFiles.clear();

        result.files.forEach((selectedFile) {
          File file = File(selectedFile.path);
          selectedFiles.add(file);
        });

        selectedFiles.forEach((file) {
          final UploadTask task = uploadFileToStorage(file);
          saveImageUrlToFirebase(task);
          setState(() {
            uploadedTasks.add(task);
          });
        });
      } else {}
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.01),
              child: Container(
                height: screenSize.height * 0.35,
                width: screenSize.width,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: imgUrls.isNotEmpty
                    ? Column(
                        children: [
                          Container(
                            child: CarouselSlider.builder(
                                carouselController: _controller,
                                itemCount: imgUrls.length,
                                itemBuilder: (context, index, realIdx) {
                                  return Container(
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.network(
                                            imgUrls[index],
                                            height: screenSize.height * 0.34,
                                            width: screenSize.width,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;

                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          top: 10,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                imgUrls.removeAt(index);
                                              });
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              child: Icon(Icons.close),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                    enableInfiniteScroll: false,
                                    aspectRatio: 2.0,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1,
                                    onPageChanged: (index, reason) {
                                      if (imgUrls.length > 1) {
                                        setState(() {
                                          _current = index;
                                        });
                                      }
                                    })),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imgUrls.map<Widget>((url) {
                              int index = imgUrls.indexOf(url);
                              return Container(
                                width: 26.0,
                                height: 4.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: _current == index
                                      ? Color.fromRGBO(0, 0, 0, 0.9)
                                      : Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    // ListView.separated(
                    //     itemBuilder: (context, index) {
                    //       return StreamBuilder<StorageTaskEvent>(
                    //           stream: uploadedTasks[index].events,
                    //           builder: (context, snapShot) {
                    //             return snapShot.hasError
                    //                 ? Text(
                    //                     "There is some error in uploading file")
                    //                 : snapShot.hasData
                    //                     ? ListTile(
                    //                         title: Text(
                    //                             '${snapShot.data.snapshot.bytesTransferred}/${snapShot.data.snapshot.totalByteCount}'),
                    //                       )
                    //                     : Container();
                    //           });
                    //     },
                    //     separatorBuilder: (context, index) => Divider(),
                    //     itemCount: uploadedTasks.length)
                    //  Stack(

                    //     children: [
                    //       Image.file(
                    //         imageFile,
                    //         fit: BoxFit.cover,
                    //         height: screenSize.height * 0.25,
                    //         width: screenSize.width,
                    //       ),
                    //       Positioned(
                    //         right: 5.0,
                    //         top: 5.0,
                    //         child: InkResponse(
                    //           onTap: () {
                    //             if (imageFile != null) {
                    //               setState(() {
                    //                 imageFile = null;
                    //               });
                    //             }
                    //           },
                    //           child: CircleAvatar(
                    //             child: Icon(Icons.close),
                    //             backgroundColor: Colors.grey,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              selectFileToUpload();
                              // _pickImage('Gallery').then((selectedImage) {
                              //   setState(() {
                              //     imageFile = selectedImage;
                              //   });
                              // });
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/picture.png',
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  'Add Photos',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.01,
                left: screenSize.width * 0.1,
                right: screenSize.width * 0.1,
                bottom: screenSize.height * 0.01,
              ),
              child: TextFormField(
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.bold,
                ),
                controller: _captionController,
                key: Key("nameField"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: "Product Name",
                  labelStyle: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.grey,
                    fontSize: textSubTitle(context),
                    //fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                validator: (value) {
                  if (value.isEmpty)
                    return "Please enter a name of your product";
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                //   left: 0,
                left: screenSize.width * 0.06,
                right: screenSize.width * 0.1,
                bottom: screenSize.height * 0.01,
              ),
              child: TextFormField(
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.bold,
                ),
                controller: _locationController,
                key: Key("locationField"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  icon: IconButton(
                    icon: Icon(
                      Icons.location_on_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: null,
                  ),
                  suffixIcon: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return SafeArea(
                              child: PlacePicker(
                                apiKey: APIKeys.apiKey,
                                initialPosition:
                                    PlacesLocation.kInitialPosition,
                                useCurrentLocation: true,
                                selectInitialPosition: true,

                                //usePlaceDetailSearch: true,
                                onPlacePicked: (result) {
                                  selectedPlace = result;
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _locationController.text =
                                        selectedPlace.formattedAddress;
                                  });
                                },
                                //forceSearchOnZoomChanged: true,
                                //automaticallyImplyAppBarLeading: false,
                                //autocompleteLanguage: "ko",
                                //region: 'au',
                                //selectInitialPosition: true,
                                selectedPlaceWidgetBuilder: (_, selectedPlace,
                                    state, isSearchBarFocused) {
                                  print(
                                      "state: $state, isSearchBarFocused: $isSearchBarFocused");
                                  return isSearchBarFocused
                                      ? Container()
                                      : FloatingCard(
                                          bottomPosition:
                                              0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                          leftPosition: 65.0,
                                          rightPosition: 65.0,
                                          //width: 50,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: state ==
                                                  SearchingState.Searching
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : ElevatedButton(
                                                  child: Text(
                                                    "Pick Here",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                                    //            this will override default 'Select here' Button.
                                                    lat = selectedPlace
                                                        .geometry.location.lat;
                                                    lng = selectedPlace
                                                        .geometry.location.lng;
                                                    print(
                                                        "do something with [selectedPlace] data");
                                                    _locationController.text =
                                                        selectedPlace
                                                            .formattedAddress;
                                                    location = selectedPlace
                                                        .addressComponents[2]
                                                        .longName;
                                                    print(location);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                        );
                                },
                                // pinBuilder: (context, state) {
                                //   if (state == PinState.Idle) {
                                //     return Icon(Icons.favorite_border);
                                //   } else {
                                //     return Icon(Icons.favorite);
                                //   }
                                // },
                              ),
                            );
                          },
                        ));
                      },
                      child: Icon(Icons.location_pin, size: 15.0)),
                  labelText: "Location",
                  labelStyle: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.grey,
                    fontSize: textSubTitle(context),
                    //fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please enter location for your ad";
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width * 0.06,
                right: screenSize.width * 0.1,
                bottom: screenSize.height * 0.01,
              ),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 3,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.bold,
                ),
                controller: _descriptionController,
                key: Key("descriptionField"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  icon: IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: null,
                  ),
                  labelText: "Details",
                  labelStyle: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.grey,
                    fontSize: textSubTitle(context),
                    //fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please enter a text for your post";
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                //   left: 0,
                left: screenSize.width * 0.06,
                right: screenSize.width * 0.1,
                bottom: screenSize.height * 0.01,
              ),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.bold,
                ),
                controller: _priceController,
                key: Key("priceField"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  icon: IconButton(
                    icon: Icon(
                      Icons.money_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: null,
                  ),
                  suffixIcon: _priceController.text == ''
                      ? Icon(Icons.close, size: 15.0)
                      : IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 15.0,
                          ),
                          onPressed: () {
                            if (_priceController.text == '') {
                              return;
                            } else {
                              setState(() {
                                _priceController.text = '';
                              });
                            }
                          },
                        ),
                  labelText: "Price",
                  labelStyle: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.grey,
                    fontSize: textSubTitle(context),
                    //fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                validator: (value) {
                  if (value.isEmpty)
                    return "Please enter price for your product";
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.01,
                left: screenSize.width * 0.1,
                //  bottom: screenSize.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Add Category',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textAppTitle(context),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.01,
                  ),
                  selectedProductList.isEmpty
                      ? InkWell(
                          onTap: _showDialog,
                          child: Icon(
                            Icons.add_circle_outline,
                            color: Colors.deepPurple,
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              selectedProductList,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black,
                                //  fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedProductList = "";
                                });
                              },
                              child: Icon(
                                Icons.close,
                                size: 15.0,
                              ),
                            )
                          ],
                        )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.01,
                left: screenSize.width * 0.1,
                //  bottom: screenSize.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Select Product Condition',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textAppTitle(context),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.01,
                  ),
                  MultiSelectChip(
                    conditionList,
                    onSelectionChanged: (selectedList) {
                      setState(() {
                        selectedConditionList = selectedList;
                      });
                    },
                  ),
                ],
              ),
            ),
            imgUrls.isEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.01),
                        child: Text(
                          'Add product image to continue',
                          style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.red),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: screenSize.height * 0.01,
                            left: screenSize.width * 0.1,
                            right: screenSize.width * 0.1),
                        child: InkWell(
                          onTap: () {
                            //   _submitForm(context);
                          },
                          child: Container(
                              height: screenSize.height * 0.07,
                              width: screenSize.width * 0.8,
                              decoration: ShapeDecoration(
                                  color: Colors.grey[100],
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.2, color: Colors.grey),
                                      borderRadius:
                                          BorderRadius.circular(8.0))),
                              child: Padding(
                                padding:
                                    EdgeInsets.all(screenSize.height * 0.015),
                                child: Center(
                                  child: Text(
                                    'Create',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textAppTitle(context),
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.only(
                        top: screenSize.height * 0.01,
                        left: screenSize.width * 0.1,
                        right: screenSize.width * 0.1),
                    child: InkWell(
                      onTap: () {
                        _submitForm(context);
                      },
                      child: Container(
                          height: screenSize.height * 0.07,
                          width: screenSize.width * 0.8,
                          decoration: ShapeDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0))),
                          child: Padding(
                            padding: EdgeInsets.all(screenSize.height * 0.015),
                            child: Center(
                              child: Text(
                                'Create',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textAppTitle(context),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
                    ),
                  ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }

  // Future<File> _pickImage(String action) async {
  //   PickedFile selectedImage;
  //   action == 'Gallery'
  //       ? selectedImage =
  //           await ImagePicker().getImage(source: ImageSource.gallery)
  //       : await ImagePicker().getImage(source: ImageSource.camera);
  //   return File(selectedImage.path);
  // }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);
    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    //Im.copyResize(image, height: 500);
    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
    setState(() {
      imageFile = newim2;
    });
    print('done');
  }

  // Future<void> _getCurrentPosition() async {
  //   // verify permissions
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     await Geolocator.openAppSettings();
  //     await Geolocator.openLocationSettings();
  //   }
  //   // get current position
  //   _currentPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   // get address
  //   String _currentAddress = await _getGeolocationAddress(_currentPosition);
  //   _locationController.text = _currentAddress;
  // }

  // Method to get Address from position:

  // Future<String> _getGeolocationAddress(Position position) async {
  //   // geocoding
  //   var places = await placemarkFromCoordinates(
  //     position.latitude,
  //     position.longitude,
  //   );
  //   if (places != null && places.isNotEmpty) {
  //     final Placemark place = places.first;
  //     return "${place.thoroughfare}, ${place.locality}";
  //   }

  //   return "No address available";
  // }

  _submitForm(BuildContext context) {
    //
    if (_formKey.currentState.validate()) {
      _repository.getCurrentUser().then((currentUser) {
        if (currentUser != null &&
                currentUser.uid == widget.group.currentUserUid ||
            widget.group.isPrivate == false) {
          // compressImage();
          _repository.retreiveUserDetails(currentUser).then((user) {
            //   _repository.uploadImageToStorage(imageFile).then((url) {
            _repository
                .addAdToForum(
                    widget.group.uid,
                    user,
                    imgUrls,
                    _captionController.text,
                    _descriptionController.text,
                    _priceController.text,
                    selectedConditionList,
                    location,
                    _locationController.text,
                    selectedProductList,
                    GeoPoint(lat, lng))
                .catchError(
                    (e) => print("Error adding current post to db : $e"));
            // }).catchError((e) {
            //   print("Error uploading image to storage : $e");
            // });
          });
        } else {
          compressImage();
          _repository.retreiveUserDetails(currentUser).then((user) {
            _repository.uploadImageToStorage(imageFile).then((url) {
              _repository
                  .addAdToReview(
                      widget.group.uid,
                      user,
                      url,
                      _captionController.text,
                      _descriptionController.text,
                      _priceController.text,
                      selectedConditionList,
                      _locationController.text,
                      'marketplace',
                      selectedProductList)
                  .catchError(
                      (e) => print("Error adding current post to db : $e"));
            }).catchError((e) {
              print("Error uploading image to storage : $e");
            });
          });
        }
      });

      _formKey.currentState.save();
      Navigator.of(context).pop();
    }
  }

  String selectedProductList = "";
  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Select Product Category",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontNameDefault,
                fontSize: textHeader(context),
              ),
            ),
            content: MultiSelectChipSingle(
              categoryList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedProductList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: textSubTitle(context),
                      fontFamily: FontNameDefault,
                      color: Colors.black),
                ),
                onPressed: () {
                  //  print('$selectedEventList');
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "Submit",
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.white),
                ),
                onPressed: () {
                  print('$selectedProductList');
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

class MultiSelectChipSingle extends StatefulWidget {
  final List<String> categoryList;
  final Function(String) onSelectionChanged;
  MultiSelectChipSingle(this.categoryList, {this.onSelectionChanged});
  @override
  _MultiSelectChipSingleState createState() => _MultiSelectChipSingleState();
}

class _MultiSelectChipSingleState extends State<MultiSelectChipSingle> {
  String selectedChoice = "";
  _buildChoiceList() {
    List<Widget> choices = [];
    widget.categoryList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
              fontSize: textBody1(context),
              fontFamily: FontNameDefault,
              color: Colors.white),
          backgroundColor: Colors.grey[400],
          selectedColor: Theme.of(context).primaryColor,
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
              widget.onSelectionChanged(selectedChoice);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(String) onSelectionChanged;
  MultiSelectChip(this.reportList, {this.onSelectionChanged});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  String selectedChoice = "";
  _buildChoiceList() {
    List<Widget> choices = [];
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          selectedColor: Theme.of(context).primaryColor,
          label: Text(
            item,
            style: TextStyle(
                fontSize: textBody1(context),
                fontFamily: FontNameDefault,
                color: selectedChoice == item ? Colors.white : Colors.black),
          ),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
              widget.onSelectionChanged(selectedChoice);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
