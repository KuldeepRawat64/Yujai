import 'dart:io';
import 'dart:math';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:core';
import 'package:image/image.dart' as Im;
import '../style.dart';
import 'places_location.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'keys.dart';
import 'package:Yujai/pages/group_page.dart';
import 'package:Yujai/models/group.dart';

// ignore: must_be_immutable
class GroupUploadEvent extends StatefulWidget {
  final String gid;
  final String name;
  File imageFile;
  final Group group;
  GroupUploadEvent({this.imageFile, this.gid, this.name, this.group});
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _GroupUploadEventState createState() => _GroupUploadEventState();
}

class Category {
  int id;
  String name;
  Category(this.id, this.name);
  static List<Category> getCategory() {
    return <Category>[
      Category(1, 'Conference'),
      Category(2, 'Seminar'),
      Category(3, 'Covention'),
      Category(4, 'Festival'),
      Category(5, 'Fair'),
      Category(6, 'Concert'),
      Category(7, 'Performance'),
      Category(8, 'Screening'),
      Category(9, 'Dinner'),
      Category(10, 'Gala'),
      Category(11, 'Class'),
      Category(12, 'Training'),
      Category(13, 'Workshop'),
      Category(14, 'Party'),
      Category(15, 'Social Gathering'),
      Category(16, 'Rally'),
      Category(17, 'Tournament'),
      Category(18, 'Game'),
      Category(19, 'Endurance'),
      Category(20, 'Tour'),
      Category(21, 'Other'),
    ];
  }
}

class EventType {
  int id;
  String name;
  EventType(this.id, this.name);
  static List<EventType> getEventType() {
    return <EventType>[
      EventType(1, 'Music'),
      EventType(2, 'Business'),
      EventType(3, 'Professional'),
      EventType(4, 'Food'),
      EventType(5, 'Drink'),
      EventType(6, 'Community'),
      EventType(7, 'Culture'),
      EventType(8, 'Performing'),
      EventType(9, 'Visula Art'),
      EventType(10, 'Film'),
      EventType(11, 'Media'),
      EventType(12, 'Entertainment'),
      EventType(13, 'Sports'),
      EventType(14, 'Fitness'),
      EventType(15, 'Health'),
      EventType(16, 'Wellness'),
      EventType(17, 'Science'),
      EventType(18, 'Technology'),
      EventType(19, 'Travel'),
      EventType(20, 'Outdoor'),
      EventType(21, 'Gaming'),
      EventType(22, 'Charity'),
      EventType(23, 'Cause'),
      EventType(24, 'Religion'),
      EventType(25, 'Spirituality'),
      EventType(26, 'Family'),
      EventType(27, 'Education'),
      EventType(28, 'Seasonal'),
      EventType(29, 'Holiday'),
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

class _GroupUploadEventState extends State<GroupUploadEvent> {
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
  //List<Capacity> _capacity = Capacity.getCapacity();
  //List<DropdownMenuItem<Capacity>> _dropDownMenuCapacity;
  //Capacity _selectedCapacity;
  String selectedStatus;
  bool isSelectedStatusLocation;
  final format = DateFormat.yMd().add_jm();
  String selectedPrice;
  bool isSelectedPriceFree;
  final _repository = Repository();
  PickResult selectedPlace;

  @override
  void initState() {
    super.initState();
    _dropDownMenuCategory = buildDropDownMenuCategory(_category);
    _selectedCategory = _dropDownMenuCategory[0].value;
    _dropDownMenuEventType = buildDropDownMenuEventType(_eventType);
    _selectedEventType = _dropDownMenuEventType[0].value;
    // _dropDownMenuCapacity = buildDropDownMenuCapacity(_capacity);
    // _selectedCapacity = _dropDownMenuCapacity[0].value;
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
    List<DropdownMenuItem<Category>> items = List();
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
    List<DropdownMenuItem<EventType>> items = List();
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

  onChangeDropDownCapacity(Capacity selectedCapacity) {
    setState(() {
      // _selectedCapacity = selectedCapacity;
    });
  }

  bool _visibility = true;

  void _changeVisibility(bool visibility) {
    setState(() {
      _visibility = visibility;
    });
  }

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

  submit() {
    if (eventTitleController.text.isNotEmpty &&
            hostNameController.text.isNotEmpty &&
            websiteController.text.isNotEmpty ||
        aboutController.text.isNotEmpty && agendaController.text.isNotEmpty ||
        locationController.text.isNotEmpty ||
        venueController.text.isNotEmpty &&
            startDateController.text.isNotEmpty &&
            endDateController.text.isNotEmpty ||
        ticketWebsiteController.text.isNotEmpty) {
      //To show CircularProgressIndicator
      _changeVisibility(false);
      _repository.getCurrentUser().then((currentUser) {
        if (currentUser != null &&
            currentUser.uid == widget.group.currentUserUid) {
          compressImage();
          _repository.retreiveUserDetails(currentUser).then((user) {
            _repository.uploadImageToStorage(widget.imageFile).then((url) {
              _repository
                  .addEventToForum(
                widget.gid,
                user,
                url,
                eventTitleController.text,
                locationController.text,
                hostNameController.text,
                websiteController.text,
                aboutController.text,
                agendaController.text,
                _selectedCategory.name,
                _selectedEventType.name,
                venueController.text,
                startDateController.text,
                endDateController.text,
                ticketWebsiteController.text,
              )
                  .then((value) {
                print('Event added to db');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupPage(
                              currentUser: user,
                              isMember: false,
                              gid: widget.gid,
                              name: widget.name,
                            )));
              }).catchError(
                      (e) => print('Error adding current event to db : $e'));
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
    return Scaffold(
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
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xffffffff),
        //  centerTitle: true,
        actions: [
          _visibility
              ? Padding(
                  padding: EdgeInsets.only(right: screenSize.width / 30),
                  child: GestureDetector(
                    child: Icon(MdiIcons.send,
                        size: screenSize.height * 0.04,
                        color: Theme.of(context).accentColor),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  //   color: const Color(0xffffffff),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  // color: const Color(0xffffffff),
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
                    fontWeight: FontWeight.bold,
                  ),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  //color: const Color(0xffffffff),
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
                          activeColor: Theme.of(context).accentColor,
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
                            fontWeight: FontWeight.bold,
                          ),
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
                          activeColor: Theme.of(context).accentColor,
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
                            fontWeight: FontWeight.bold,
                          ),
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        //  color: const Color(0xffffffff),
                        child: TextFormField(
                          autocorrect: true,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
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
                                                selectedPlace.formattedAddress;
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
                                                      : RaisedButton(
                                                          color: Colors
                                                              .deepPurpleAccent,
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        //    color: const Color(0xffffffff),
                        child: TextFormField(
                          autocorrect: true,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        //   color: const Color(0xffffffff),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
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
                    fontWeight: FontWeight.bold,
                  ),
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
                        color: Colors.black87,
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
                    fontWeight: FontWeight.bold,
                  ),
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
                        color: Colors.black87,
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Set the date of your event.',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'From :',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.015,
                ),
                Padding(
                  padding: EdgeInsets.only(right: screenSize.width / 5),
                  child: Container(
                    //    color: const Color(0xffffffff),

                    height: screenSize.height * 0.06,
                    // width: MediaQuery.of(context).size.width,
                    child: DateTimeField(
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
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
                    fontWeight: FontWeight.bold,
                  ),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  //    color: const Color(0xffffffff),
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
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
