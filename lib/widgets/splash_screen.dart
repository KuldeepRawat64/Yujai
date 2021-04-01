import 'dart:async';
import 'package:Yujai/widgets/future_widget.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage())));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff251F34),
        body: Container(
          height: screenSize.height,
          width: screenSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: screenSize.height * 0.06,
                backgroundImage: AssetImage('assets/images/yujai.png'),
              ),
              SizedBox(
                height: screenSize.height * 0.03,
              ),
              Text(
                'Yujai',
                style: TextStyle(
                    fontSize: screenSize.height * 0.05,
                    fontFamily: 'Signatra',
                    color: Colors.white),
              )
            ],
          ),
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(colors: [
          //   Colors.deepPurple,
          //   Colors.deepPurpleAccent,
          // ])),
        ),
      ),
    );
  }
}
