import 'package:Yujai/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import 'home.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class ArmyAddInfo extends StatefulWidget {
  final String currentUserId;
  ArmyAddInfo({this.currentUserId});
  @override
  _ArmyAddInfoState createState() => _ArmyAddInfoState();
}

class ServiceStatus {
  int id;
  String name;
  ServiceStatus(this.id, this.name);
  static List<ServiceStatus> getServiceStatus() {
    return <ServiceStatus>[
      ServiceStatus(1, 'Select a Service Status'),
      ServiceStatus(2, 'Currently Serving'),
      ServiceStatus(3, 'Retired'),
    ];
  }
}

class Medal {
  int id;
  String name;
  Medal(this.id, this.name);
  static List<Medal> getMedal() {
    return <Medal>[
      Medal(1, 'Select a Medal'),
      Medal(2, 'Sena Medal'),
      Medal(3, 'Nausena Medal'),
      Medal(4, 'Vayusena Medal'),
      Medal(5, 'Sarvottam Yudh Seva Medal'),
      Medal(6, 'Uttam Yudh Seva Medal'),
      Medal(7, 'Ati Vishisht Seva Medal'),
      Medal(8, 'Vishisht Seva Medal'),
      Medal(9, 'Param Vir Chakra'),
      Medal(10, 'Maha Vir Chakra'),
      Medal(11, 'Vir Chakra'),
      Medal(12, 'Ashok Chakra'),
      Medal(13, 'Kirti Chakra'),
      Medal(14, 'Shaurya Chakra'),
      Medal(15, 'Wound Medal'),
      Medal(16, 'General Service Medal 1947'),
      Medal(17, 'Samanya Seva Medal'),
      Medal(18, 'Special Service Medal'),
      Medal(19, 'Samar Seva Star'),
      Medal(20, 'Poorvi Star'),
      Medal(21, 'Paschimi Star'),
      Medal(22, 'Operation Vijay Star'),
      Medal(23, 'Sainya Seva Medal'),
      Medal(24, 'High Altitude Service Medal'),
      Medal(25, 'Antrik Suraksha Padak'),
      Medal(26, 'Videsh Seva Medal'),
      Medal(27, 'Meritorius Service Medal'),
      Medal(28, 'Long Service and Good Conduct Medal'),
      Medal(29, '30 Years Long Service Medal'),
      Medal(30, '20 Years Long Service Medal'),
      Medal(31, '9 Years Long Service Medal'),
      Medal(32, 'Territorial Army Decoration'),
      Medal(33, 'Territorial Army Medal'),
      Medal(34, 'Indian Independence Medal'),
      Medal(35, '50th Independence Anniversary Medal'),
      Medal(36, '25th Independence Anniversary Medal'),
      Medal(37, 'Commonwealth Awards'),
    ];
  }
}

class _ArmyAddInfoState extends State<ArmyAddInfo> {
  List<ServiceStatus> _serviceStatus = ServiceStatus.getServiceStatus();
  List<DropdownMenuItem<ServiceStatus>> _dropDownMenuServiceStatus;
  ServiceStatus _selectedServiceStatus;
  List<Medal> _medal = Medal.getMedal();
  List<DropdownMenuItem<Medal>> _dropDownMenuMedal;
  Medal _selectedMedal;
  DateTime startService = DateTime.now();
  DateTime endService = DateTime.now();
  TextEditingController _startServiceController = new TextEditingController();
  TextEditingController _endServiceController = new TextEditingController();
  TextEditingController _bioController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  final format = DateFormat('yyyy');
  bool isLoading = false;
  UserModel user;
  bool startYear;
  bool endYear;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    startYear = false;
    endYear = false;
    _dropDownMenuServiceStatus = buildDropDownMenuServiceStatus(_serviceStatus);
    _selectedServiceStatus = _dropDownMenuServiceStatus[0].value;
    _dropDownMenuMedal = buildDropDownMenuMedal(_medal);
    _selectedMedal = _dropDownMenuMedal[0].value;
  }

  List<DropdownMenuItem<ServiceStatus>> buildDropDownMenuServiceStatus(
      List serviceStats) {
    List<DropdownMenuItem<ServiceStatus>> items = List();
    for (ServiceStatus serviceStatus in serviceStats) {
      items.add(
        DropdownMenuItem(
          value: serviceStatus,
          child: Text(serviceStatus.name),
        ),
      );
    }
    return items;
  }

  onChangeDropDownServiceStatus(ServiceStatus selectedServiceStatus) {
    setState(() {
      _selectedServiceStatus = selectedServiceStatus;
    });
  }

  List<DropdownMenuItem<Medal>> buildDropDownMenuMedal(List medals) {
    List<DropdownMenuItem<Medal>> items = List();
    for (Medal medal in medals) {
      items.add(
        DropdownMenuItem(
          value: medal,
          child: Text(medal.name),
        ),
      );
    }
    return items;
  }

  onChangeDropDownMedal(Medal selectedMedal) {
    setState(() {
      _selectedMedal = selectedMedal;
    });
  }

  submit() async {
    User currentUser = await _auth.currentUser;
    usersRef.doc(currentUser.uid).update({
      "startService": _startServiceController.text,
      "endService": _endServiceController.text,
      "bio": _bioController.text,
      "serviceStatus": _selectedServiceStatus.name,
      "medal": _selectedMedal.name,
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.015,
                horizontal: screenSize.width / 50,
              ),
              child: GestureDetector(
                onTap: submit,
                child: Container(
                  height: screenSize.height * 0.055,
                  width: screenSize.width / 5,
                  child: Center(
                      child: Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.white,
                      fontSize: textButton(context),
                    ),
                  )),
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () => Navigator.pop(context)),
          //    centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Edit Military Info',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
            padding: EdgeInsets.fromLTRB(
              screenSize.width / 11,
              screenSize.height * 0.02,
              screenSize.width / 11,
              0,
            ),
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height * 0.015,
                          ),
                          child: Text(
                            'Service',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: screenSize.height * 0.075,
                              width: screenSize.width / 2.55,
                              child: DateTimeField(
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                ),
                                controller: _startServiceController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xffffffff),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  hintText: 'Start Year',
                                ),
                                format: format,
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      initialDatePickerMode:
                                          DatePickerMode.year,
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                              ),
                            ),
                            Container(
                              height: screenSize.height * 0.075,
                              width: screenSize.width / 2.55,
                              child: DateTimeField(
                                style: TextStyle(
                                  fontSize: screenSize.height * 0.018,
                                ),
                                controller: _endServiceController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xffffffff),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  hintText: 'End Year',
                                  hintStyle: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                  ),
                                ),
                                format: format,
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      initialDatePickerMode:
                                          DatePickerMode.year,
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenSize.height * 0.015,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service Status',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: DropdownButton(
                                underline: Container(color: Colors.white),
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black87,
                                ),
                                elevation: 1,
                                icon: Icon(Icons.keyboard_arrow_down,
                                    color: Theme.of(context).primaryColor),
                                iconSize: 30,
                                isExpanded: true,
                                value: _selectedServiceStatus,
                                items: _dropDownMenuServiceStatus,
                                onChanged: onChangeDropDownServiceStatus,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenSize.height * 0.015,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medal',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: DropdownButton(
                                underline: Container(color: Colors.white),
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black87,
                                ),
                                elevation: 1,
                                icon: Icon(Icons.keyboard_arrow_down,
                                    color: Theme.of(context).primaryColor),
                                iconSize: 30,
                                isExpanded: true,
                                value: _selectedMedal,
                                items: _dropDownMenuMedal,
                                onChanged: onChangeDropDownMedal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenSize.height * 0.035,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bio',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            child: TextField(
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context)),
                              autofocus: false,
                              controller: _bioController,
                              keyboardType: TextInputType.multiline,
                              minLines: 5,
                              maxLines: 5,
                              maxLengthEnforced: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                hintText: 'Tell us about yourself.',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
