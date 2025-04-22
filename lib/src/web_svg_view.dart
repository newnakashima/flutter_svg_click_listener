import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class SvgImage extends StatefulWidget {
  SvgImage({
    super.key,
    required this.svgString,
    required this.onElementClick,
    this.backgroundColor = Colors.white,
  });
  String svgString;
  Color backgroundColor;
  Function(String) onElementClick;

  @override
  State<SvgImage> createState() => _SvgImageState();
}

class _SvgImageState extends State<SvgImage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'onClick',
        onMessageReceived: (JavaScriptMessage message) {
          widget.onElementClick(message.message);
        },
      )
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    String svgSrc = '''
  <!DOCTYPE html>
<html>
<head>
    <title>Interactive SVG</title>
    <style>
        body {
            margin: 0;
            overflow: hidden;
        }
        svg {
            width: 100%;
            height: auto;
        }
    </style>
</head>
<body>
${widget.svgString}

<script type="text/javascript">
    // Get all elements within the SVG
    const svg = document.querySelector('svg');
    const svgElements = svg.querySelectorAll('*');

    // Loop through each element, check for id attribute, and add onclick event
    svgElements.forEach(element => {
        const elementId = element.getAttribute('id');
        if (elementId) {
            element.addEventListener('click', function() {
                console.log(elementId);
                window.onClick.postMessage(elementId);
            });
        }
    });
</script>
</body>
</html>

  ''';
    controller.loadHtmlString(svgSrc);
    return Scaffold(
      body: Container(
        color: widget.backgroundColor,
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}

Future<String> loadSvgStringFromAssets(String path) async {
  return await rootBundle.loadString(path);
}
