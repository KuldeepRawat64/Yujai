import 'dart:async';
import 'package:Yujai/style.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatelessWidget {
  final String title;
  final String selectedUrl;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  MyWebView({Key key, this.title, this.selectedUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
          child: Scaffold(
            backgroundColor:const  Color(0xfff6f6f6),
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor:const Color(0xffffffff),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: screenSize.height * 0.045,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
            color: Colors.black54
            ),
          ),
        ),
        body: WebView(
          initialUrl: selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
