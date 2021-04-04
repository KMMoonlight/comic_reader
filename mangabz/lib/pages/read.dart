import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class WebViewFragment extends StatefulWidget {
  final targetUrl;
  final chapterName;

  WebViewFragment({this.targetUrl, this.chapterName});

  @override
  _WebViewFragmentState createState() => _WebViewFragmentState();
}

class _WebViewFragmentState extends State<WebViewFragment> {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterName.trim()),
      ),
      body: WebView(
        initialUrl: 'https://www.mangabz.com${widget.targetUrl}',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
