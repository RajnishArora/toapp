import 'package:flutter/material.dart';
import 'package:webtoapp/Components/wtaAppbar.dart';
import 'package:webtoapp/Helpers/adManager.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:move_to_background/move_to_background.dart';
import 'package:webtoapp/Components/wtaDrawer.dart';
import 'package:firebase_admob/firebase_admob.dart';

class WebViewClass extends StatefulWidget {
  WebViewClass({this.optionsGathered});

  final Map<String, dynamic> optionsGathered;
  @override
  _WebViewClassState createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  String str = "";
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebViewController controller;

  final snackBar = SnackBar(content: Text('Snack Bar is lika a toast '));

  var paddingBottom = 70.0;

  bool isLoading = true;

  BannerAd _bannerAd;
  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(
        anchorType: (widget.optionsGathered['admobPosition'] == 'topads')
            ? AnchorType.top
            : AnchorType.bottom,
      );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    if (widget.optionsGathered['admobOption'] == 'banner') {
      _bannerAd = BannerAd(
        //adUnitId: AdManager.bannerAdUnitId,
        //size: AdSize.smartBanner,
        adUnitId: AdManager(optionsGathered: widget.optionsGathered)
            .getBannerAdUnitId(),
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.failedToLoad) {
            setState(() {
              paddingBottom = 0.0;
            });
          }
          print("BannerAd event is $event");
        },
      );
      _loadBannerAd();
    }
  }

  @override
  void dispose() {
    if (widget.optionsGathered['admobOption'] == 'banner') {
      _bannerAd?.dispose();
    }

    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String mainUrl = widget.optionsGathered['mainUrl'];

    // wrap Scaffold in WillPopScope and add function onWillPop:()goBack(),

    return WillPopScope(
      onWillPop: () async {
        //bool retVal = false;
        if (await controller.canGoBack()) {
          controller.goBack();

          //retVal = true;
        } else {
          if (Platform.isAndroid) {
            //  MinimizeApp.minimizeApp();
            MoveToBackground.moveTaskToBack();
          }
        }
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: WtaAppbar(
          optionsGathered: widget.optionsGathered,
          completer: _controller,
        ),
        drawer: WtaDrawer(
          optionsGathered: widget.optionsGathered,
          completer: _controller,
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Stack(children: [
              Padding(
                padding: EdgeInsets.only(
                  //add conditional padding acc to admobOption & admobPosition
                  bottom: (widget.optionsGathered['admobOption'] == 'banner' &&
                          widget.optionsGathered['admobPosition'] ==
                              'bottomads')
                      ? paddingBottom
                      : 0.0,
                ),
                child: WebView(
                  initialUrl: mainUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                    _controller.future.then((value) => controller = value);
                    //controller = webViewController;
                  },
                  javascriptChannels: <JavascriptChannel>[
                    _toasterJavascriptChannel(context),
                  ].toSet(),
                  onPageStarted: (String url) {
                    print('PAGE START LOADING : $url');
                  },
                  onPageFinished: (String url) {
                    setState(() {
                      isLoading = false;
                    });
                    print('PAGE FINISHED LOADING : $url');
                  },
                  gestureNavigationEnabled: true,
                ),
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(),
            ]);
          },
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
                content: Text(message.message != null ? message.message : ' ')),
            //SnackBar(content: Text("JavaScript Message")),
          );
        });
  }
}
