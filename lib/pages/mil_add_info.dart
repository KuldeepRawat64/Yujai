import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../style.dart';
import 'Home.dart';

class MilAddInfo extends StatefulWidget {
  @override
  _MilAddInfoState createState() => _MilAddInfoState();
}

class _MilAddInfoState extends State<MilAddInfo> {
  DateTime date = DateTime.now();
  TextEditingController _datecontroller = new TextEditingController();
  var myFormat = DateFormat('d-MM-yyyy');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    setState(() {
      date = picked ?? date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //  resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 26.0),
                  child: Center(
                    child: Text(
                      'Additional Info',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textAppTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    'Service',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 4.0),
                      child: Text(
                        'Start Year',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 30.0,
                      width: 90.0,
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: IgnorePointer(
                          child: TextField(
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            controller: _datecontroller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0)),
                              hintText: ('${myFormat.format(date)}'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 12.0),
                      child: Text(
                        'End Year',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 30.0,
                      width: 90.0,
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: IgnorePointer(
                          child: TextField(
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            controller: _datecontroller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0)),
                              hintText: ('${myFormat.format(date)}'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    'Bio',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  height: 120.0,
                  width: 350.0,
                  // padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    maxLength: 5,
                    maxLengthEnforced: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: 'Bio',
                    ),
                  ),
                ),
                SizedBox(height: 220.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 50.0,
                    width: 350.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.white,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
