import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SvgImage extends StatefulWidget {
  const SvgImage({super.key});

  @override
  State<SvgImage> createState() => _SvgImageState();
}

class _SvgImageState extends State<SvgImage> {
  // late final WebViewController _controller;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: "https://www.youtube.com/",
        gestureNavigationEnabled: true,
        debuggingEnabled: true,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(
            name: 'paymentResponse',
            onMessageReceived: (JavascriptMessage message) async {
              Future.delayed(const Duration(seconds: 2)).then((value) {

              });
            },
          )
        },
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {

        },
        onPageStarted: (String url) {

        },
        onPageFinished: (String url) {

        },
      ),
    );
  }
}
