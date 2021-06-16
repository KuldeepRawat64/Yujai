import 'dart:io';
import 'dart:math';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/keys.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class EditProfileForm extends StatefulWidget {
  final UserModel currentUser;

  EditProfileForm({this.currentUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileForm> {
  var _repository = Repository();
  final _formKey = GlobalKey<FormState>();
  User currentUser;
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentUser.displayName;
    _bioController.text = widget.currentUser.bio;
    _emailController.text = widget.currentUser.email;
    _phoneController.text = widget.currentUser.phone;
    _websiteController.text = widget.currentUser.website;
    _locationController.text = widget.currentUser.location;
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  File imageFile;

  submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _repository.updateDetails(
          currentUser.uid,
          _nameController.text,
          _bioController.text,
          _emailController.text,
          _phoneController.text,
          _websiteController.text,
          _locationController.text);

      _formKey.currentState.save();
      Navigator.pop(context);
    }
  }

  // void onError(PlacesAutocompleteResponse response) {
  //   homeScaffoldKey.currentState.showSnackBar(
  //     SnackBar(content: Text(response.errorMessage)),
  //   );
  // }
  // Future<void> _onButtonPressed() async {
  //   Prediction p = await PlacesAutocomplete.show(
  //     context: context,
  //     apiKey: APIKeys.apiKey,
  //     components: [Component(Component.country, "fr")],
  //   );
  //   displayPrediction(p);
  // }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(
            screenSize.width * 0.04,
            screenSize.height * 0.05,
            screenSize.width * 0.04,
            screenSize.height * 0.1,
          ),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  key: Key('nameField'),
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Name',
                    labelText: 'Name',
                    hintStyle: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textAppTitle(context),
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) return "Please enter a name";
                    return null;
                  },
                ),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                TextFormField(
                  autocorrect: true,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _bioController,
                  decoration: InputDecoration(
                    icon: IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.black54,
                      ),
                      onPressed: null,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Bio',
                    labelText: 'Bio',
                    labelStyle: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.grey,
                      fontSize: textSubTitle(context),
                      //fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.05,
                ),
                //Divider(),
                Text(
                  'Private Information',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black54,
                      fontSize: textSubTitle(context),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                TextFormField(
                  key: Key('emailField'),
                  readOnly: true,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: IconButton(
                      icon: Icon(
                        Icons.alternate_email_sharp,
                        color: Colors.black54,
                      ),
                      onPressed: null,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Email address',
                    labelText: 'Email address',
                    labelStyle: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.grey,
                      fontSize: textSubTitle(context),
                      //fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _phoneController,
                  decoration: InputDecoration(
                    icon: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.phone_outlined,
                          color: Colors.black54,
                        )),
                    filled: true,
                    fillColor: Colors.grey[100],
                    //   hintText: '00000 00000',
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.grey,
                      fontSize: textSubTitle(context),
                      //fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                TextFormField(
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _websiteController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    icon: IconButton(
                      icon: Icon(
                        MdiIcons.web,
                        color: Colors.black54,
                      ),
                      onPressed: null,
                    ),
                    hintText: 'https://www',
                    labelText: 'Portfolio',
                    labelStyle: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.grey,
                      fontSize: textSubTitle(context),
                      //fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                TextFormField(
                  onChanged: (val) {
                    //    _onButtonPressed();
                  },
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _locationController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    icon: IconButton(
                      icon: Icon(
                        Icons.location_on_outlined,
                        color: Colors.black54,
                      ),
                      onPressed: null,
                    ),
                    // hintText: 'https://www',
                    labelText: 'Location',
                    labelStyle: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.grey,
                      fontSize: textSubTitle(context),
                      //fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.05,
                    bottom: screenSize.height * 0.01,
                  ),
                  child: InkWell(
                    onTap: () {
                      submit(context);
                    },
                    child: Container(
                        height: screenSize.height * 0.07,
                        //  width: screenSize.width * 0.8,
                        decoration: ShapeDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        child: Padding(
                          padding: EdgeInsets.all(screenSize.height * 0.015),
                          child: Center(
                            child: Text(
                              'Update',
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: APIKeys.apiKey,
        //apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      // scaffold.showSnackBar(
      //   SnackBar(content: Text("${p.description} - $lat/$lng")),
      // );
    }
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    //Im.copyResize(image, 500);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
    print('done');
  }
}
