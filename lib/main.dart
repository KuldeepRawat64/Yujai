// import 'package:Yujai/pages/home.dart';
// import 'package:Yujai/pages/login_page.dart';
// import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/blocs/location_bloc.dart';
import 'package:Yujai/widgets/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'widgets/app_localizations.dart';
// import 'style.dart';

void main() async {
  // add these lines
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // transparent status bar
    systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarIconBrightness: Brightness.dark, // status bar icons' color
    systemNavigationBarIconBrightness: Brightness.dark, //
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ChangeNotifierProvider(
        create: (context) => LocationBloc(),
        child: MaterialApp(
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('de', 'DE'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          title: 'Yujai',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0))),
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.deepPurpleAccent,
            visualDensity: VisualDensity.standard,
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
