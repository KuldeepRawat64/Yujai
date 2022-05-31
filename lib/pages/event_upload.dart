import 'dart:io';
import 'dart:math';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:core';
import 'package:image/image.dart' as Im;
import 'places_location.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'keys.dart';

// ignore: must_be_immutable
class EventUpload extends StatefulWidget {
  File imageFile;
  EventUpload({this.imageFile});
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _EventUploadState createState() => _EventUploadState();
}

class Category {
  int id;
  String name;
  Category(this.id, this.name);
  static List<Category> getCategory() {
    return <Category>[
      Category(1, 'Air'),
      Category(2, 'Auto'),
      Category(3, 'Beauty'),
      Category(4, 'Boat'),
      Category(5, 'Business'),
      Category(6, 'Cause'),
      Category(7, 'Charity'),
      Category(8, 'College'),
      Category(9, 'Community'),
      Category(10, 'Culture'),
      Category(11, 'Drink'),
      Category(12, 'Education'),
      Category(13, 'Entertainment'),
      Category(14, 'Family'),
      Category(15, 'Fashion'),
      Category(16, 'Film'),
      Category(17, 'Fitness'),
      Category(18, 'Food'),
      Category(19, 'Gaming'),
      Category(20, 'Glamour'),
      Category(21, 'Goverment'),
      Category(22, 'Health'),
      Category(23, 'Hobbies'),
      Category(24, 'Holiday'),
      Category(25, 'Home'),
      Category(26, 'lifestyle'),
      Category(27, 'Media'),
      Category(28, 'Music'),
      Category(29, 'Outdoor'),
      Category(30, 'Performing'),
      Category(31, 'Politics'),
      Category(32, 'Professional'),
      Category(33, 'Religion'),
      Category(34, 'School'),
      Category(35, 'Science'),
      Category(36, 'Seasonal'),
      Category(37, 'Special Interest'),
      Category(38, 'Spiritual'),
      Category(39, 'Sports'),
      Category(40, 'Study'),
      Category(41, 'Technology'),
      Category(42, 'Travel'),
      Category(43, 'Trend'),
      Category(44, 'Visual Art'),
      Category(45, 'Wellness'),
      Category(46, 'Others'),
    ];
  }
}

class EventType {
  int id;
  String name;
  EventType(this.id, this.name);
  static List<EventType> getEventType() {
    return <EventType>[
      EventType(1, 'Appearance'),
      EventType(2, 'Attraction'),
      EventType(3, 'Auction'),
      EventType(4, 'Camp'),
      EventType(5, 'Class'),
      EventType(6, 'Competition'),
      EventType(7, 'Concert'),
      EventType(8, 'Conference'),
      EventType(9, 'Consumer'),
      EventType(10, 'Dinner'),
      EventType(11, 'Drink'),
      EventType(12, 'Endurance'),
      EventType(13, 'Fair'),
      EventType(14, 'Gala'),
      EventType(15, 'Game'),
      EventType(16, 'Gathering'),
      EventType(17, 'Meeting'),
      EventType(18, 'Networking'),
      EventType(19, 'Party'),
      EventType(20, 'Performance'),
      EventType(21, 'Race'),
      EventType(22, 'Rally'),
      EventType(23, 'Retreat'),
      EventType(24, 'Screening'),
      EventType(25, 'Singing'),
      EventType(26, 'Social'),
      EventType(27, 'Talk'),
      EventType(28, 'Tour'),
      EventType(29, 'Tournament'),
      EventType(30, 'Training'),
      EventType(31, 'Trip'),
      EventType(32, 'Workshop'),
      EventType(33, 'other'),
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

class _EventUploadState extends State<EventUpload> {
  TextEditingController eventTitleController = TextEditingController();
  TextEditingController ticketWebsiteController = TextEditingController();
  TextEditingController hostNameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController agendaController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController venueController = TextEditingController();
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
  List<Category> _category = Category.getCategory();
  List<DropdownMenuItem<Category>> _dropDownMenuCategory;
  Category _selectedCategory;
  List<EventType> _eventType = EventType.getEventType();
  List<DropdownMenuItem<EventType>> _dropDownMenuEventType;
  EventType _selectedEventType;
  String selectedStatus;
  bool isSelectedStatusLocation;
  final format = DateFormat.yMd().add_jm();
  String selectedPrice;
  bool isSelectedPriceFree;
  PickResult selectedPlace;

  @override
  void initState() {
    super.initState();
    _dropDownMenuCategory = buildDropDownMenuCategory(_category);
    _selectedCategory = _dropDownMenuCategory[0].value;
    _dropDownMenuEventType = buildDropDownMenuEventType(_eventType);
    _selectedEventType = _dropDownMenuEventType[0].value;
    selectedStatus = "Online";
    isSelectedStatusLocation = false;
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

  List<DropdownMenuItem<Category>> buildDropDownMenuCategory(List categories) {
    List<DropdownMenuItem<Category>> items = [];
    for (Category category in categories) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Text(category.name),
        ),
      );
    }
    return items;
  }

  onChangeDropDownCategory(Category selectedCategory) {
    setState(() {
      _selectedCategory = selectedCategory;
    });
  }

  List<DropdownMenuItem<EventType>> buildDropDownMenuEventType(
      List eventTypes) {
    List<DropdownMenuItem<EventType>> items = [];
    for (EventType eventType in eventTypes) {
      items.add(
        DropdownMenuItem(
          value: eventType,
          child: Text(eventType.name),
        ),
      );
    }
    return items;
  }

  onChangeDropDownEventType(EventType selectedEventType) {
    setState(() {
      _selectedEventType = selectedEventType;
    });
  }

  List<DropdownMenuItem<Capacity>> buildDropDownMenuCapacity(List capacities) {
    List<DropdownMenuItem<Capacity>> items = [];
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

  onChangeDropDownCapacity(Capacity selectedCapacity) {
    setState(() {
      // _selectedCapacity = selectedCapacity;
    });
  }

  bool _visibility = true;

  // void _changeVisibility(bool visibility) {
  //   setState(() {
  //     _visibility = visibility;
  //   });
  // }

  @override
  void dispose() {
    eventTitleController?.dispose();
    hostNameController?.dispose();
    websiteController?.dispose();
    aboutController?.dispose();
    agendaController?.dispose();
    venueController?.dispose();
    startDateController?.dispose();
    endDateController?.dispose();
    ticketWebsiteController?.dispose();
    super.dispose();
  }

  // submit() {
  //   if (eventTitleController.text.isNotEmpty &&
  //       hostNameController.text.isNotEmpty &&
  //       aboutController.text.isNotEmpty &&
  //       startDateController.text.isNotEmpty &&
  //       endDateController.text.isNotEmpty) {
  //     //To show CircularProgressIndicator
  //     _changeVisibility(false);
  //     _repository.getCurrentUser().then((currentUser) {
  //       if (currentUser != null) {
  //         compressImage();
  //         _repository.retreiveUserDetails(currentUser).then((user) {
  //           _repository.uploadImageToStorage(widget.imageFile).then((url) {
  //             _repository
  //                 .addEventToDb(
  //               user,
  //               url,
  //               eventTitleController.text,
  //               locationController.text,
  //               hostNameController.text,
  //               websiteController.text,
  //               aboutController.text,
  //               agendaController.text,
  //               _selectedCategory.name,
  //               _selectedEventType.name,
  //               venueController.text,
  //               startDateController.text,
  //               endDateController.text,
  //               ticketWebsiteController.text,
  //             )
  //                 .then((value) {
  //               print('Event added to db');
  //               Navigator.pushReplacement(
  //                   context, MaterialPageRoute(builder: (context) => Home()));
  //             }).catchError(
  //                     (e) => print('Error adding current event to db : $e'));
  //           }).catchError((e) {
  //             print('Error uploading image to storage : $e');
  //           });
  //         });
  //       } else {
  //         print('Current User is null');
  //       }
  //     });
  //   } else {
  //     return;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xfff6f6f6),
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
            'Create Event',
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xffffffff),
          // centerTitle: true,
          actions: [
            _visibility &&
                    isSelectedStatusLocation == false &&
                    websiteController.text.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(right: screenSize.width / 30),
                    child: GestureDetector(
                      child: Icon(MdiIcons.send,
                          size: screenSize.height * 0.04,
                          color: Theme.of(context).primaryColorLight),
                      //    onTap: submit,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(right: screenSize.width / 30),
                    child: GestureDetector(
                      child: Icon(MdiIcons.send,
                          size: screenSize.height * 0.04,
                          color: Theme.of(context).primaryColorLight),
                      onTap: () {},
                    ),
                  ),
          ],
        ),
        body: ListView(
          children: [
            !_visibility ? linearProgress() : Container(),
            widget.imageFile != null
                ? Container(
                    height: screenSize.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 28 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Title',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    //    color: const Color(0xffffffff),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xffffffff),
                      ),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        color: Colors.black54,
                      ),
                      controller: eventTitleController,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width / 11,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    //     color: const Color(0xffffffff),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xffffffff),
                      ),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        color: Colors.black54,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      controller: aboutController,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width / 11,
                vertical: screenSize.height * 0.012,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Organiser',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    //  color: const Color(0xffffffff),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xffffffff),
                      ),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        color: Colors.black54,
                      ),
                      controller: hostNameController,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width / 11,
                //  vertical: screenSize.height * 0.012,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agenda',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    //  color: const Color(0xffffffff),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xffffffff),
                      ),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        color: Colors.black54,
                      ),
                      controller: agendaController,
                    ),
                  ),
                ],
              ),
            ),
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 'Onsite',
                            groupValue: selectedStatus,
                            activeColor: Theme.of(context).primaryColorLight,
                            onChanged: (val) {
                              //print("Choosen $val");
                              setSelectedStatus(val);
                              setState(() {
                                isSelectedStatusLocation = true;
                              });
                            },
                          ),
                          Text(
                            'Onsite',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: screenSize.width / 30,
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 'Online',
                            groupValue: selectedStatus,
                            activeColor: Theme.of(context).primaryColorLight,
                            onChanged: (val) {
                              //print("Choosen $val");
                              setSelectedStatus(val);
                              setState(() {
                                isSelectedStatusLocation = false;
                              });
                            },
                          ),
                          Text(
                            'Online',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ]),
            isSelectedStatusLocation
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width / 11,
                      // vertical: screenSize.height * 0.012,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Venue',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          //    color: const Color(0xffffffff),
                          child: TextFormField(
                            autocorrect: true,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.black54,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              contentPadding: const EdgeInsets.all(8.0),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.location_on),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return PlacePicker(
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
                                              venueController.text =
                                                  selectedPlace
                                                      .formattedAddress;
                                            });
                                          },
                                          //forceSearchOnZoomChanged: true,
                                          //automaticallyImplyAppBarLeading: false,
                                          //autocompleteLanguage: "ko",
                                          //region: 'au',
                                          //selectInitialPosition: true,
                                          selectedPlaceWidgetBuilder: (_,
                                              selectedPlace,
                                              state,
                                              isSearchBarFocused) {
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
                                                        BorderRadius.circular(
                                                            12.0),
                                                    child: state ==
                                                            SearchingState
                                                                .Searching
                                                        ? Center(
                                                            child:
                                                                CircularProgressIndicator())
                                                        : ElevatedButton(
                                                            child: Text(
                                                              "Pick Here",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            onPressed: () {
                                                              // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                                              //            this will override default 'Select here' Button.
                                                              print(
                                                                  "do something with [selectedPlace] data");
                                                              venueController
                                                                      .text =
                                                                  selectedPlace
                                                                      .formattedAddress;

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
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
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            controller: venueController,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: screenSize.height * 0.012),
                          child: Text(
                            'City',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          //   color: const Color(0xffffffff),
                          child: TextFormField(
                            autocorrect: true,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.black54,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              contentPadding: const EdgeInsets.all(8.0),
                              suffixIcon: Icon(Icons.location_city),
                            ),
                            controller: locationController,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width / 11,
                      // vertical: screenSize.height * 0.012,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event Website',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          //   color: const Color(0xffffffff),
                          child: TextFormField(
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.black54,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              suffixIcon: Icon(MdiIcons.web),
                            ),
                            controller: websiteController,
                          ),
                        ),
                      ],
                    ),
                  ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width / 11,
                vertical: screenSize.height * 0.012,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Category',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: DropdownButton(
                        underline: Container(color: Colors.white),
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          color: Colors.black54,
                        ),
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Theme.of(context).primaryColor),
                        iconSize: 30,
                        isExpanded: true,
                        value: _selectedCategory,
                        items: _dropDownMenuCategory,
                        onChanged: onChangeDropDownCategory,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width / 11,
                // vertical: screenSize.height * 0.012,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Type',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: DropdownButton(
                        underline: Container(color: Colors.white),
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          color: Colors.black54,
                        ),
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Theme.of(context).primaryColor),
                        iconSize: 30,
                        isExpanded: true,
                        value: _selectedEventType,
                        items: _dropDownMenuEventType,
                        onChanged: onChangeDropDownEventType,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width / 11,
                vertical: screenSize.height * 0.012,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Date & Time',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Set the date of your event.',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'From :',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.015,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenSize.width / 5),
                    child: Container(
                      //     color: const Color(0xffffffff),
                      height: screenSize.height * 0.06,
                      // width: MediaQuery.of(context).size.width,
                      child: DateTimeField(
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          color: Colors.black54,
                        ),
                        controller: startDateController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          suffixIcon: Icon(Icons.date_range),
                          labelText: 'Start Event',
                        ),
                        format: format,
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue;
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.015,
                  ),
                  Text(
                    'To :',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.015,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenSize.width / 5),
                    child: Container(
                      //    color: const Color(0xffffffff),
                      height: screenSize.height * 0.06,
                      //width: MediaQuery.of(context).size.width,
                      child: DateTimeField(
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          color: Colors.black54,
                        ),
                        controller: endDateController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          suffixIcon: Icon(Icons.date_range),
                          labelText: 'End Event',
                        ),
                        format: format,
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue;
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width / 11,
                //vertical: screenSize.height * 0.012,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registration Website',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    // color: const Color(0xffffffff),
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        color: Colors.black54,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xffffffff),
                        suffixIcon: Icon(MdiIcons.ticketAccount),
                      ),
                      controller: ticketWebsiteController,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.015,
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

  Future<List<Address>> locateUser() async {
    LocationData currentLocation;
    Future<List<Address>> addresses;

    var location = new Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();

      print(
          'LATITUDE : ${currentLocation.latitude} && LONGITUDE : ${currentLocation.longitude}');

      // From coordinates
      final coordinates =
          new Coordinates(currentLocation.latitude, currentLocation.longitude);

      addresses = Geocoder.local.findAddressesFromCoordinates(coordinates);
    } on PlatformException catch (e) {
      print('ERROR : $e');
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }
    return addresses;
  }
}
