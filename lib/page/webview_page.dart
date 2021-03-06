import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

enum MenuOptions { clearCache, clearCookies }

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _webViewController;
  double progress = 0;
  late bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
        } else {
          log('_webViewController error back');
        }
        return false;
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text("WebView"),
        //   actions: [
        //     IconButton(
        //         onPressed: () async {
        //           if (await _webViewController.canGoBack()) {
        //             _webViewController.goBack();
        //           } else {
        //             log('_webViewController error back');
        //           }
        //           return;
        //         },
        //         icon: const Icon(Icons.arrow_back_ios)),
        //     IconButton(
        //         onPressed: () async {
        //           if (await _webViewController.canGoForward()) {
        //             _webViewController.canGoForward();
        //           } else {
        //             log('_webViewController error forward');
        //           }
        //           return;
        //         },
        //         icon: const Icon(Icons.arrow_forward_ios)),
        //     IconButton(
        //         onPressed: () {
        //           _webViewController.reload();
        //         },
        //         icon: const Icon(Icons.replay)),
        //     PopupMenuButton<MenuOptions>(
        //         onSelected: (value) {
        //           switch (value) {
        //             case MenuOptions.clearCache:
        //               _onClearCache(_webViewController, context);
        //               break;
        //             case MenuOptions.clearCookies:
        //               _onClearCookies(context);
        //               break;
        //           }
        //         },
        //         itemBuilder: (context) => <PopupMenuItem<MenuOptions>>[
        //               const PopupMenuItem(
        //                   value: MenuOptions.clearCache,
        //                   child: Text('Clear Cache')),
        //               const PopupMenuItem(
        //                   value: MenuOptions.clearCookies,
        //                   child: Text('Clear Cookies')),
        //             ])
        //   ],
        // ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              color: Colors.red,
              backgroundColor: Colors.black,
            ),
            Expanded(
              child: WebView(
                  onProgress: (progress) {
                    this.progress = progress / 100;
                    setState(() {});
                  },
                  onPageStarted: (url) {
                    if (url.contains('https://flutter.dev/')) {
                      Future.delayed(const Duration(microseconds: 300));
                      _webViewController.evaluateJavascript(
                        "document.getElementsByTagName('notification)[0].style.display'='none'",
                      );
                    }
                    log('New site: $url');
                  },
                  onPageFinished: (url) {
                    log('Page loaded');
                    if(url.contains('https://m.facebook.com/')){
                      if (isSubmitting){
                        _webViewController.loadUrl('https://m.facebook.com/');
                        isSubmitting = false;
                      }
                    }
                  },
                  navigationDelegate: (request) {
                    if (request.url.startsWith('https://m.youtube.com')) {
                      log('Navigation block to $request');
                      return NavigationDecision.prevent;
                    }
                    log('Navigation to $request');
                    return NavigationDecision.navigate;
                  },
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: 'https://rezka.ag/'),
            ),
          ],
        ),
        // initialUrl: 'http://info.cern.ch'),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.next_plan),
          onPressed: () async {
            // final currentUrl = await _webViewController.currentUrl();
            // log("Previous page: $currentUrl");
            // _webViewController.loadUrl('https://www.youtube.com');
            // _webViewController.evaluateJavascript(
            //   "document.getElementsByTagName('footer)[0].style.display'='none'",
            // );
            const email = 'email';
            const pass = 'pass';
            _webViewController.evaluateJavascript(
              'document.getElementById("m_login_email").value="$email"',
            );
            _webViewController.evaluateJavascript(
              'document.getElementById("m_login_password").value="$pass"',
            );
            await Future.delayed(Duration(seconds: 1));
            isSubmitting = true;
            await _webViewController.evaluateJavascript(
              'document.forms[0].submit()',
            );
          },
        ),
      ),
    );
  }

  void _onClearCookies(BuildContext context) async {
    final bool hadCookies = await CookieManager().clearCookies();
    String message = 'Clear Cookies';
    if (!hadCookies) {
      message = 'Cookies Delete';
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _onClearCache(WebViewController controller, BuildContext context) async {
    await _webViewController.clearCache();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Cache Clear')));
  }
}
