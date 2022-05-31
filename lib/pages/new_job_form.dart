import 'dart:convert';
import 'package:Yujai/models/designation.dart';
import 'package:Yujai/models/place_search.dart';
import 'package:Yujai/pages/keys.dart';
import 'package:Yujai/pages/places_location.dart';
import 'package:Yujai/services/places_services.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/models/post.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as Im;
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/models/user.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../style.dart';
import 'package:intl/intl.dart';

class NewJobForm extends StatefulWidget {
  final UserModel currentUser;

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  const NewJobForm({
    Key key,
    this.currentUser,
  }) : super(key: key);
  @override
  _NewJobFormState createState() => _NewJobFormState();
}

class _NewJobFormState extends State<NewJobForm> {
  final _formKey = GlobalKey<FormState>();
  Post post = new Post();
  File imageFile;
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _minSalaryController = TextEditingController();
  TextEditingController _maxSalaryController = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<Designation>> deskey = new GlobalKey();
  static List<Designation> designations = [];
  AutoCompleteTextField designationTextField;
  TextEditingController workingDaysController;
  TextEditingController workTimingsController;
  final _repository = Repository();
  String location = '';
  final format = DateFormat('yyyy-MM-dd');
  int startDate = 0;
  int endDate = 0;
  int startTime = 0;
  int endTime = 0;
  double lat, lng;
  PickResult selectedPlace;
  bool isVisible = false;
  double number = 5;
  bool skillFirst = false;
  bool skillSecond = false;
  bool skillThird = false;
  // UserModel _user;
  List<dynamic> selectedSkills = [];
  String valueEmpType;
  String valueIndustry;
  String valueJobType;
  static const _locale = 'en';
  bool loading = true;
  String latitude;
  String longitude;
  var locationMessage = "";
  // Position _currentPosition;
  List<PlaceSearch> searchResults = [];
  final placesService = PlacesService();
  AutoCompleteTextField placesTextField;
  GlobalKey<AutoCompleteTextFieldState<PlaceSearch>> placeSearchkey =
      new GlobalKey();
  // static List<PlaceSearch> places = [];
  bool isEnabled = false;
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.simpleCurrency(name: '\u{20B9}').currencySymbol;
  List<String> categoryList = [
    'Conference',
    'Seminar',
    'Covention',
    'Festival',
    'Fair',
    'Concert',
    'Performance',
    'Screening',
    'Dinner',
    'Gala',
    'Class',
    'Training',
    'Workshop',
    'Party',
    'Social Gathering',
    'Rally',
    'Tournament',
    'Game',
    'Endurance',
    'Tour',
    'Other',
  ];
  List industries = [
    'Architecture and planning',
    'Art, culture and sport',
    'Auditing, tax and law',
    'Automotive and vehicle manufacturing',
    'Banking and financial services',
    'Civil service, associations and institutions',
    'Consulting',
    'Consumer goods and trade',
    'Education and science',
    'Energy, water and environment',
    'HR services',
    'Health and social',
    'Insurance',
    'Internet and IT',
    'Marketing, PR and design',
    'Media and publishing',
    'Medical services',
    'Other services',
    'Real Estate',
    'Telecommunication',
    'Tourism and food service',
    'Transport and logistics',
  ];
  List jobTypes = [
    'Full-time',
    'Part-time',
    'Contract',
  ];

  @override
  void initState() {
    super.initState();
    // retrieveUserDetails();
    getDesignation();
    workingDaysController = TextEditingController(text: 'Monday to Saturday');
    workTimingsController = TextEditingController(text: '9 AM to 5 PM');
  }

  void getDesignation() async {
    try {
      final response = await http.get(
          Uri.parse("https://kuldeeprawat64.github.io/data/profession.json"));
      if (response.statusCode == 200) {
        designations = loadDesignation(response.body);
        // print('Profession: ${designations.length}');
        setState(() {
          loading = false;
        });
      } else {
        //  print("Error getting Profession.");
      }
    } catch (e) {
      // print("Error getting profession.");
    }
  }

  static List<Designation> loadDesignation(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed
        .map<Designation>((json) => Designation.fromJson(json))
        .toList();
  }

  Widget drow(Designation designation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            designation.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: FontNameDefault,
              //  fontSize: textBody1(context)
            ),
          ),
        ),

        // Text(
        //   user.email,
        // ),
      ],
    );
  }

  getPercent(double level) {
    if (level == 0) {
      return 0.0;
    } else {
      return level / 10 * 1.0;
    }
  }

  // retrieveUserDetails() async {
  //   User currentUser = await _repository.getCurrentUser();
  //   UserModel user = await _repository.retreiveUserDetails(currentUser);
  //   if (!mounted) return;
  //   setState(() {
  //     _user = user;
  //   });
  // }

  Widget placeRow(PlaceSearch place) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Divider(),
        Text(
          place.description,
          style: TextStyle(fontSize: screenSize.height * 0.025),
        ),
        SizedBox(
          height: screenSize.height * 0.012,
        ),
        // Text(
        //   user.email,
        // ),
      ],
    );
  }

  Widget getSkillsListView(List<dynamic> skills) {
    var screenSize = MediaQuery.of(context).size;
    selectedSkills = skills;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Skills",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: FontNameDefault,
            color: Colors.black87,
            fontSize: textHeader(context),
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: skills.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skills[index]['skill'],
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      //     color: Colors.white,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      LinearPercentIndicator(
                        width: screenSize.width * 0.65,
                        backgroundColor: Colors.grey[100],
                        //  lineHeight: 10.0,
                        animation: true,
                        animationDuration: 500,
                        progressColor: Theme.of(context).primaryColor,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        //   fillColor: Theme.of(context).primaryColor,
                        percent: getPercent(skills[index]['level']),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            skills.removeAt(index);
                          });
                        },
                        child: Icon(
                          Icons.cancel_rounded,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  )
                ],
              );
            }),
      ],
    );
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
            // SizedBox(
            //   height: screenSize.height * 0.02,
            // ),
            // TextFormField(
            //   autocorrect: true,
            //   textCapitalization: TextCapitalization.sentences,
            //   style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontFamily: FontNameDefault,
            //       fontSize: textBody1(context)),
            //   decoration: InputDecoration(
            //     // icon: Icon(
            //     //   Icons.work_outline,
            //     //   size: screenSize.height * 0.035,
            //     //   color: Colors.black54,
            //     // ),
            //     filled: true,
            //     fillColor: Colors.grey[100],
            //     //   hintText: 'Designation',
            //     labelText: 'Job title',
            //     labelStyle: TextStyle(
            //       fontFamily: FontNameDefault,
            //       color: Colors.grey,
            //       fontSize: textSubTitle(context),
            //       fontWeight: FontWeight.normal,
            //     ),
            //     border: InputBorder.none,
            //     isDense: true,
            //   ),
            //   controller: jobTitleController,
            //   validator: (value) {
            //     if (value.isEmpty) return "Please enter a job title for post";
            //     return null;
            //   },
            // ),
            loading
                ? Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.02),
                    child: Container(
                      //  height: screenSize.height * 0.09,
                      child: designationTextField =
                          AutoCompleteTextField<Designation>(
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context)),
                        controller: jobTitleController,
                        key: deskey,
                        clearOnSubmit: false,
                        suggestions: designations,
                        decoration: InputDecoration(
                          // icon: Icon(
                          //   Icons.work_outline,
                          //   size: screenSize.height * 0.035,
                          //   color: Colors.black54,
                          // ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          //   hintText: 'Designation',
                          labelText: 'Job role',
                          labelStyle: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.grey,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.normal,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        textSubmitted: (val) {
                          if (val.isEmpty) {
                            return;
                          }
                        },
                        itemFilter: (item, query) {
                          return item.name
                              .toLowerCase()
                              .startsWith(query.toLowerCase());
                        },
                        itemSorter: (a, b) {
                          return a.name.compareTo(b.name);
                        },
                        itemSubmitted: (item) {
                          if (item != null) {
                            setState(() {
                              designationTextField.textField.controller.text =
                                  item.name;
                            });
                          }
                        },
                        itemBuilder: (context, item) {
                          // ui for the autocompelete row
                          return drow(item);
                        },
                      ),
                    ),
                  ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    fillColor: Colors.grey[100],
                    filled: true,
                    border: InputBorder.none),
                hint: Text(
                  'Industry',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: textSubTitle(context),
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                //  underline: Container(),
                icon: Icon(Icons.keyboard_arrow_down_outlined),
                iconSize: 30,
                isExpanded: true,
                value: valueIndustry,
                items: industries.map((valueItem) {
                  return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem,
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontWeight: FontWeight.bold,
                            fontSize: textSubTitle(context),
                          )));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    valueIndustry = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) return 'Please select an industry';
                  return null;
                },
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    fillColor: Colors.grey[100],
                    filled: true,
                    border: InputBorder.none),
                hint: Text(
                  'Job type',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: textSubTitle(context),
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                //  underline: Container(),
                icon: Icon(Icons.keyboard_arrow_down_outlined),
                iconSize: 30,
                isExpanded: true,
                value: valueJobType,
                items: jobTypes.map((valueItem) {
                  return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem,
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontWeight: FontWeight.bold,
                            fontSize: textSubTitle(context),
                          )));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    valueJobType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) return 'Please select an job type';
                  return null;
                },
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenSize.width * 0.43,
                  // padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      if (string.length > 0) {
                        string = '${_formatNumber(string.replaceAll(',', ''))}';
                        _minSalaryController.value = TextEditingValue(
                            text: string,
                            selection:
                                TextSelection.collapsed(offset: string.length));
                      }
                    },
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context)),
                    decoration: InputDecoration(
                      // icon: Icon(
                      //   Icons.work_outline,
                      //   size: screenSize.height * 0.035,
                      //   color: Colors.black54,
                      // ),
                      prefixText: _currency,
                      filled: true,
                      fillColor: Colors.grey[100],
                      //   hintText: 'Designation',
                      labelText: 'Min. salary/month',
                      labelStyle: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.grey,
                        fontSize: textSubTitle(context),
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    controller: _minSalaryController,
                  ),
                ),
                Container(
                  width: screenSize.width * 0.43,
                  //  padding: const EdgeInsets.all(8.0),

                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      if (string.length > 0) {
                        string = '${_formatNumber(string.replaceAll(',', ''))}';
                        _maxSalaryController.value = TextEditingValue(
                            text: string,
                            selection:
                                TextSelection.collapsed(offset: string.length));
                      }
                    },
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context)),
                    decoration: InputDecoration(
                      prefixText: _currency,
                      // icon: Icon(
                      //   Icons.work_outline,
                      //   size: screenSize.height * 0.035,
                      //   color: Colors.black54,
                      // ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      //   hintText: 'Designation',
                      labelText: 'Max. salary/month',
                      labelStyle: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.grey,
                        fontSize: textSubTitle(context),
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    controller: _maxSalaryController,
                    // validator: (val) {
                    //   if (int.parse(_minSalaryController.text) < int.parse(val))
                    //     return 'Not valid';
                    //   return null;
                    // },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            TextFormField(
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context)),
              decoration: InputDecoration(
                // icon: Icon(
                //   Icons.work_outline,
                //   size: screenSize.height * 0.035,
                //   color: Colors.black54,
                // ),
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Eg. Monday to Saturday',
                labelText: 'Working days',
                labelStyle: TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.grey,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              controller: workingDaysController,
              // validator: (value) {
              //   if (value.isEmpty) return "Please enter a city for this job";
              //   return null;
              // },
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            TextFormField(
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context)),
              decoration: InputDecoration(
                // icon: Icon(
                //   Icons.work_outline,
                //   size: screenSize.height * 0.035,
                //   color: Colors.black54,
                // ),
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Eg. 9 AM to 5 PM',
                labelText: 'Work timings',
                labelStyle: TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.grey,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              controller: workTimingsController,
              // validator: (value) {
              //   if (value.isEmpty) return "Please enter a city for this job";
              //   return null;
              // },
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: screenSize.height * 0.02),
            //   child: Container(
            //     //  height: screenSize.height * 0.09,
            //     child: placesTextField = AutoCompleteTextField<PlaceSearch>(
            //       textCapitalization: TextCapitalization.sentences,
            //       style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontFamily: FontNameDefault,
            //           fontSize: textBody1(context)),
            //       controller: _locationController,
            //       key: placeSearchkey,
            //       clearOnSubmit: false,
            //       suggestions: places,
            //       decoration: InputDecoration(
            //         // icon: Icon(
            //         //   Icons.work_outline,
            //         //   size: screenSize.height * 0.035,
            //         //   color: Colors.black54,
            //         // ),
            //         filled: true,
            //         fillColor: Colors.grey[100],
            //         //   hintText: 'Designation',
            //         labelText: 'Location',
            //         labelStyle: TextStyle(
            //           fontFamily: FontNameDefault,
            //           color: Colors.grey,
            //           fontSize: textSubTitle(context),
            //           fontWeight: FontWeight.normal,
            //         ),
            //         border: InputBorder.none,
            //         isDense: true,
            //       ),
            //       textSubmitted: (val) {
            //         if (val.isEmpty) {
            //           return;
            //         }
            //       },
            //       itemFilter: (item, query) {
            //         locationBloc.searchPlaces(query);
            //         setState(() {
            //           places = locationBloc.searchResults;
            //         });
            //         return item.description
            //             .toLowerCase()
            //             .startsWith(query.toLowerCase());
            //       },
            //       itemSorter: (a, b) {
            //         return a.description.compareTo(b.description);
            //       },
            //       itemSubmitted: (item) {
            //         if (item != null) {
            //           setState(() {
            //             placesTextField.textField.controller.text =
            //                 item.description;
            //           });
            //         }
            //       },
            //       itemBuilder: (context, item) {
            //         // ui for the autocompelete row
            //         return placeRow(item);
            //       },
            //     ),
            //   ),
            // ),
            // TextFormField(
            //   autocorrect: true,
            //   textCapitalization: TextCapitalization.sentences,
            //   style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontFamily: FontNameDefault,
            //       fontSize: textBody1(context)),
            //   decoration: InputDecoration(
            //     // icon: Icon(
            //     //   Icons.work_outline,
            //     //   size: screenSize.height * 0.035,
            //     //   color: Colors.black54,
            //     // ),
            //     filled: true,
            //     fillColor: Colors.grey[100],
            //     //   hintText: 'Designation',
            //     labelText: 'Location',
            //     labelStyle: TextStyle(
            //       fontFamily: FontNameDefault,
            //       color: Colors.grey,
            //       fontSize: textSubTitle(context),
            //       fontWeight: FontWeight.normal,
            //     ),
            //     border: InputBorder.none,
            //     isDense: true,
            //   ),
            //   controller: _locationController,
            //   validator: (value) {
            //     if (value.isEmpty) return "Please enter a city for this job";
            //     return null;
            //   },
            // ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            TextFormField(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SafeArea(
                        child: PlacePicker(
                          apiKey: APIKeys.apiKey,
                          initialPosition: PlacesLocation.kInitialPosition,
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
                          selectedPlaceWidgetBuilder:
                              (_, selectedPlace, state, isSearchBarFocused) {
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
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: state == SearchingState.Searching
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : ElevatedButton(
                                            child: Text(
                                              "Pick Here",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                              //            this will override default 'Select here' Button.
                                              print(
                                                  "do something with [selectedPlace] data");
                                              _locationController.text =
                                                  selectedPlace
                                                      .formattedAddress;

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
                  ),
                );
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
                // icon: IconButton(
                //   icon: Icon(
                //     Icons.location_on_outlined,
                //     color: Colors.black54,
                //   ),
                //   onPressed: null,
                // ),
                // hintText: 'https://www',
                labelText: 'Location',
                labelStyle: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.normal,
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
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context)),
              decoration: InputDecoration(
                // icon: Icon(
                //   Icons.work_outline,
                //   size: screenSize.height * 0.035,
                //   color: Colors.black54,
                // ),
                filled: true,
                fillColor: Colors.grey[100],
                //   hintText: 'Designation',
                labelText: 'Description',
                labelStyle: TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.grey,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 5,
              controller: aboutController,
              validator: (value) {
                if (value.isEmpty)
                  return "Please enter a description that describes this job";
                return null;
              },
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            TextFormField(
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context)),
              decoration: InputDecoration(
                // icon: Icon(
                //   Icons.work_outline,
                //   size: screenSize.height * 0.035,
                //   color: Colors.black54,
                // ),
                filled: true,
                fillColor: Colors.grey[100],
                //   hintText: 'Designation',
                labelText: 'Company website',
                labelStyle: TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.grey,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              controller: websiteController,
              // validator: (value) {
              //   if (value.isEmpty) return "Please enter a your company website";
              //   return null;
              // },
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.02,
                //           left: screenSize.width * 0.01,
                //            right: screenSize.width * 0.01
              ),
              child: InkWell(
                onTap: () {
                  _submitForm(context);
                },
                child: Container(
                    height: screenSize.height * 0.07,
                    //        width: screenSize.width * 0.8,
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
            )
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
    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    //Im.copyResize(image, height: 500);
    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
    setState(() {
      imageFile = newim2;
    });
    print('done');
  }

  // getUserLocation() async {
  //   Position position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   List<Placemark> placemarks = await Geolocator()
  //       .placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark placemark = placemarks[0];
  //   String completeAddress =
  //       '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
  //   print(completeAddress);
  //   String formattedAddress = "${placemark.locality}, ${placemark.country}";
  //   setState(() {
  //     _locationController.text = formattedAddress;
  //   });
  // }

  _submitForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _repository.getCurrentUser().then((currentUser) {
        if (currentUser != null) {
          //    compressImage();
          _repository.retreiveUserDetails(currentUser).then((user) {
            //   _repository.uploadImageToStorage(imageFile).then((url) {
            _repository
                .addJobToDb(
                    user,
                    jobTitleController.text,
                    _locationController.text,
                    valueJobType,
                    _minSalaryController.text,
                    _maxSalaryController.text,
                    workingDaysController.text,
                    workTimingsController.text,
                    valueIndustry,
                    aboutController.text,
                    websiteController.text)
                .catchError(
                    (e) => print('Error adding current job to db : $e'));
            //    }).catchError((e) {
            //        print('Error uploading image to storage : $e');
            //       });
          });
        } else {
          print('Current User is null');
        }
      });

      _formKey.currentState.save();
      Navigator.of(context).pop();
    }
  }

  String selectedEventList = "";
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
