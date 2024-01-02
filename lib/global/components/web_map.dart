import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebMap extends StatefulWidget {
  final double lat;
  final double long;
  const WebMap({super.key, required this.lat, required this.long});

  @override
  State<WebMap> createState() => _WebMapState();
}

class _WebMapState extends State<WebMap> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebViewWidget(
      controller: controller
        ..loadRequest(Uri.parse(
            'https://www.google.com/maps/@${widget.lat},${widget.long},17z?entry=ttu')),
    ));
  }
}
