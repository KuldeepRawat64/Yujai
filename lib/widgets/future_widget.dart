import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Yujai/pages/home.dart';
import 'package:Yujai/pages/login_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _repository = Repository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: futureWidget()));
            // decoration: BoxDecoration(
            //   color: Color(0xffffffff),
            // )));
  }

  Widget futureWidget() {
    return FutureBuilder(
        future: _repository.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MyHomePage();
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Home();
            } else {
              return MyHomePage();
            }
          } else {
            return LoginPage();
          }
        });
  }
}
