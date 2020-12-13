//import 'dart:ffi';

//import 'dart:collection';

//return new Io.File('$path/${DateTime.now().toUtc().toIso8601String()}.png')..writeAsBytesSync(encodePng(thumbnail));

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:flutter/services.dart';
import 'package:webtoapp/Helpers/adManager.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:io' show Platform;
//import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
//import 'package:share/share.dart';
//import 'package:minimize_app/minimize_app.dart';
import 'package:webtoapp/Components/wtaDrawer.dart';
import 'package:webtoapp/Components/wtaCustomPopupMenu.dart';
import 'package:webtoapp/Components/wtaBtnAction.dart';
import 'package:http/http.dart' as http;
import 'package:webtoapp/Data/constants.dart';
//import 'dart:convert';
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
      );
      _loadBannerAd();
    }
  }

  @override
  void dispose() {
    // if (widget.optionsGathered['admobOption'] == 'banner') {
    //   _bannerAd?.dispose();
    // }

    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  //
  // Future<File> getImageFile(String imgUrl) async {
  //   try {
  //     return await SaveFile().saveImage(imgUrl);
  //   } on Error catch (e) {
  //     throw 'Error has occured while saving';
  //   }
  //   return null;
  // }
  //
  // final Directory _appDocDir = await getApplicationDocumentsDirectory();
  // //App Document Directory + folder name
  // final Directory _appDocDirFolder =  Directory('${_appDocDir.path}/$folderName/');
  //
  // if(await _appDocDirFolder.exists()){ //if folder already exists return path
  // return _appDocDirFolder.path;
  // }else{//if folder not exists create folder and then return its path
  // final Directory _appDocDirNewFolder=await _appDocDirFolder.create(recursive: true);
  // return _appDocDirNewFolder.path;
  // }

  Future<File> getImageFile(String imgUrl) async {
    if (imgUrl != "" && imgUrl != null) {
      imgUrl = imgUrl.trim();
      imgUrl = imgUrl.replaceAll('localhost', baseIp);
      //  print("IMGURL");
      //  print(imgUrl);
      String folderName = 'images';
      String requiredPath;
      final Directory documentDirectory =
          await getApplicationDocumentsDirectory();

      final Directory applicationDirectory =
          Directory('${documentDirectory.path}/$folderName/');

      if (await applicationDirectory.exists()) {
        print("VIEW_SCREEN DIR ALREADY EXISTS");
        requiredPath = applicationDirectory.path;
      } else {
        //if folder not exists create folder and then return its path
        //if folder not exists create folder and then return its path
        print("VIEW_SCREEN  CREATING DIR");
        final Directory applicationDirectoryNew =
            await applicationDirectory.create(recursive: true);
        requiredPath = applicationDirectoryNew.path;
      }

      String filename = requiredPath + path.basename(imgUrl);
      // extract file name from url by finding /.last
      File file = File(filename);
      if (await file.exists()) {
        print("FILE ALREADY EXISTS SO NO SAVING");
        return file;
      }
      str = filename;
      //File fileNew = File(path.join(requiredPath, filename));
      print("FILE PATH");
      print(filename);
      //File doesn't exist beforehand so fetch
      try {
        var response = await http.get(imgUrl);

        print("FILE COPIED");
        return new File(filename)..writeAsBytesSync(response.bodyBytes);
        //fileNew.writeAsBytesSync(response.bodyBytes);

      } catch (e) {
        print("Could not copy file");
        print(e);
      }
      //print("returning original method");
      //return File(str);
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.optionsGathered);
    String mainUrl = widget.optionsGathered['mainUrl'];
    bool hideAppbar =
        widget.optionsGathered['hideAppbar'] == 'yes' ? true : false;

    String headerOption = widget.optionsGathered['headerOption'];
    print("TITLE ALIGN");

    final Future<File> titleImage =
        getImageFile(widget.optionsGathered['imageLocation']);

    // Future<bool> backPossible(WebViewController webController) async {
    //   if (await webController.canGoBack()) {
    //     return Future.value(true);
    //   } else {
    //     return Future.value(false);
    //   }
    // }

    // wrap Scaffold in WillPopScope and add function onWillPop:()goBack(),

    return WillPopScope(
      onWillPop: () async {
        //bool retVal = false;
        if (await controller.canGoBack()) {
          controller.goBack();

          //retVal = true;
        } else {
          //  MinimizeApp.minimizeApp();
        }
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: hideAppbar
            ? null
            : AppBar(
                // title: (() {
                //   if (headerOption == 'only-text') {
                //     return Text(widget.optionsGathered['appTitle']);
                //   } else if (headerOption == 'only-image') {
                //     return FutureBuilder(
                //         future: titleImage,
                //         builder: (BuildContext context,
                //             AsyncSnapshot<File> snapshot) {
                //           return snapshot.data != null
                //               ? Image.file(snapshot.data)
                //               : Text(widget.optionsGathered['appTitle']);
                //         });
                //   } else {
                //     // headerOption == "nothing so do nothing
                //   }
                // }()),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (() {
                      if (widget.optionsGathered['leftIcon'] != 'lback' &&
                          Platform.isIOS) {
                        return IconButton(
                          icon: Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            controller.goBack();
                          },
                        );
                      } else {
                        return Container();
                      }
                    }()),
                    Expanded(
                      child: (() {
                        if (headerOption == 'only-text') {
                          return Text(widget.optionsGathered['appTitle']);
                        } else if (headerOption == 'only-image') {
                          return FutureBuilder(
                              future: titleImage,
                              builder: (BuildContext context,
                                  AsyncSnapshot<File> snapshot) {
                                return snapshot.data != null
                                    ? Image.file(snapshot.data)
                                    : Text(widget.optionsGathered['appTitle']);
                              });
                        } else {
                          // headerOption == "nothing so do nothing
                        }
                      }()),
                    ),
                  ],
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _colorFromHex(widget.optionsGathered['colSelFirst']),
                        widget.optionsGathered['gradientOptionSelected'] == 'no'
                            ? _colorFromHex(
                                widget.optionsGathered['colSelFirst'])
                            : _colorFromHex(
                                widget.optionsGathered['colSelSecond'])
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                centerTitle:
                    widget.optionsGathered['titleAlign'] == 'center-align'
                        ? true
                        : false,
                //backgroundColor: _colorFromHex(widget.optionsGathered['colSelFirst']),
                leading: Builder(
                  //using builder so that we can get context
                  builder: (context) => BtnAction(
                      completer: _controller,
                      optionsGathered: widget.optionsGathered,
                      str: 'left'),
                ),
                actions: [
                  //switch not working
                  widget.optionsGathered['rightFirstIcon'] == 'rmenu'
                      ? (CustomPopupMenu(
                          optionsGathered: widget.optionsGathered,
                          completer: _controller))
                      : (widget.optionsGathered['rightFirstIcon'] == ""
                          ? SizedBox.shrink()
                          : BtnAction(
                              completer: _controller,
                              str: 'rightFirst',
                              optionsGathered: widget.optionsGathered,
                            )),
                  widget.optionsGathered['rightSecondIcon'] == 'rmenu'
                      ? CustomPopupMenu(
                          optionsGathered: widget.optionsGathered,
                          completer: _controller,
                        )
                      : widget.optionsGathered['rightSecondIcon'] == ""
                          ? SizedBox.shrink()
                          : BtnAction(
                              completer: _controller,
                              str: 'rightSecond',
                              optionsGathered: widget.optionsGathered,
                            ),
                ],
              ),
        drawer: WtaDrawer(
          optionsGathered: widget.optionsGathered,
          completer: _controller,
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                //add conditional padding acc to admobOption & admobPosition
                bottom: (widget.optionsGathered['admobOption'] == 'banner' &&
                        widget.optionsGathered['admobPosition'] == 'bottomads')
                    ? 70.0
                    : 0.0,
                top: (widget.optionsGathered['admobOption'] == 'banner' &&
                        widget.optionsGathered['admobPosition'] == 'topads')
                    ? 50.0
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
                // for css inject
                //   webView.evaluateJavascript("javascript:(function() {" +
                //       "var parent = document.getElementsByTagName('head').item(0);" +
                //       "var style = document.createElement('style');" +
                //       "style.type = 'text/css';" +
                //       // Tell the browser to BASE64-decode the string into your script !!!
                //       "style.innerHTML = window.atob('" + base64Str + "');" +
                //       "parent.appendChild(style)" +
                //       "})()");
                //css inject ends
                javascriptChannels: <JavascriptChannel>[
                  _toasterJavascriptChannel(context),
                ].toSet(),
                // navigationDelegate: (NavigationRequest request) {
                //   if (request.url.startsWith('https://www.youtube.com/')) {
                //     print('blocking navigation to $request}');
                //     return NavigationDecision.prevent;
                //   }
                //   print("REQUEST.URL");
                //
                //   return NavigationDecision.navigate;
                // },
                onPageStarted: (String url) {
                  print('PAGE START LOADING : $url');
                },
                onPageFinished: (String url) {
                  print('PAGE FINISHED LOADING : $url');
                },
                gestureNavigationEnabled: true,
              ),
            );
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
