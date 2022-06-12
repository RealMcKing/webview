import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView"),
        actions: [
          IconButton(
              onPressed: () async {}, icon: const Icon(Icons.arrow_back_ios)),
          IconButton(
              onPressed: () async {},
              icon: const Icon(Icons.arrow_forward_ios)),
          IconButton(onPressed: () async {}, icon: const Icon(Icons.replay)),
        ],
      ),
      body: const WebView(
          javascriptMode: JavascriptMode.unrestricted,
          // initialUrl: 'https://flutter.dev/'),
          initialUrl: 'http://info.cern.ch'),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.next_plan),
        onPressed: () async {},
      ),
    );
  }
}
