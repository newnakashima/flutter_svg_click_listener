import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class SvgImage extends StatelessWidget {
  SvgImage({super.key, required this.svgString,required this.onElementClick});

  String svgString;
  Function(String) onElementClick;

  @override
  Widget build(BuildContext context) {
    String svgSrc = '''
  <!DOCTYPE html>
<html>
<head>
    <title>Interactive SVG</title>
    <style>
        svg {
            width: 100%;
            height: auto;
        }
    </style>
</head>
<body>
$svgString

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

    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'onClick',
        onMessageReceived: (JavaScriptMessage message) {
          onElementClick(message.message);
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
      )
      ..loadHtmlString(svgSrc);
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}