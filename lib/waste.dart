// Image.asset(
// 'assets/images/logo.jpg',
// width: 200.0,
// height: 200.0,
// )

// from android Manifest
// <!-- Specifies an Android theme to apply to this Activity as soon as
// the Android process has started. This theme is visible to the user
// while the Flutter UI initializes. After that, this theme continues
// to determine the Window background behind the Flutter UI. -->
// <meta-data
// android:name="io.flutter.embedding.android.NormalTheme"
// android:resource="@style/NormalTheme"
// />
// <!-- Displays an Android View that continues showing the launch screen
// Drawable until Flutter paints its first frame, then this splash
// screen fades out. A splash screen is useful to avoid any visual
// gap between the end of Android's launch screen and the painting of
// Flutter's first frame. -->
// <meta-data
// android:name="io.flutter.embedding.android.SplashScreenDrawable"
// android:resource="@drawable/launch_background"
// />

// void evalJS() async {
//   // for css encode
//
//   print("In EVAL JS");
//   String css = await rootBundle.loadString('assets/styles.css');
//   print(css);
//   var bytes = utf8.encode(css);
//   var base64Str = base64.encode(bytes);
//   controller.evaluateJavascript("javascript:(function() {" +
//       // "document.getElementById('body').style.color = 'red';" +
//       "var parent = document.getElementsByTagName('head').item(0);" +
//       "var style = document.createElement('style');" +
//       "style.type = 'text/css';" +
//       // Tell the browser to BASE64-decode the string into your script !!!
//       "style.innerHTML = window.atob('" +
//       base64Str +
//       "');" +
//       "parent.appendChild(style)" +
//       "})()");
// //
// }

//Text(
//widget.optionsGathered['appTitle'],
//),
//title: Text('placeholder'),//Image(image: FileImage(file)),
/*
new FutureBuilder(
future: getImageFile(widget.optionsGathered['imageLocation']),
builder:
(BuildContext context, AsyncSnapshot<File> snapshot) {
return snapshot.data != null
? Image.file(snapshot.data)
    : Text(widget.optionsGathered['appTitle']);
}),
*/
/* use this for conditional statement in widget
(() {
// your code here
}())
*/

/*
for right icons in appbar
              actions: [
                IconButton(
                  icon: Icon(Icons.add_alert),
                  tooltip: 'Show SnackBar',
                  onPressed: () {
                    scaffoldKey.currentState.showSnackBar(snackBar);
                  },
                ),
                //IconButton(),
              ],
 */
/*
              actions: [
                widget.optionsGathered['rightFirstIcon'] == ""
                    ? ""
                    : IconButton(
                        // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                        icon: getHeaderIcon(
                            widget.optionsGathered['rightFirstIcon']),
                        //icon: FaIcon(FontAwesomeIcons.search),
                        onPressed: () {
                          print("Pressed");
                        }),
                getHeaderIcon(widget.optionsGathered['rightSecondIcon']) == null
                    ? ""
                    : IconButton(
                        // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                        icon: getHeaderIcon(
                            widget.optionsGathered['rightSecondIcon']),
                        //icon: FaIcon(FontAwesomeIcons.search),
                        onPressed: () {
                          print("Pressed");
                        }),
              ],
 */
/*
WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          //_loadHtmlFromNetworking();
        },
      ),
 */

/*
WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptChannels: <JavascriptChannel>[
              _toasterJavascriptChannel(context),
            ].toSet(),
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print("REQUEST.URL");
              print(request.url);
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('PAGE START LOADING : $url');
            },
            onPageFinished: (String url) {
              print('PAGE FINISHED LOADING : $url');
            },
            gestureNavigationEnabled: true,
          );
 */
// print(widget.optionsGathered['rightFirstIcon']);
// print(widget.optionsGathered['rightSecondIcon']);
//var networkHelper = NetworkHelper(url);
//Future test = networkHelper.getData();
//the test var has all the website body this could be useful if u want to
// alter any html but going to different pages needs to be checked
/*
ListView(
        children: [
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: _colorFromHex(optionsGathered['colSelFirst']),
              border: Border.all(
                width: 1.0,
              ),
            ),
          ),
          ListTile(
            title: Text('Tile 1'),
            onTap: () {
              // do something
              //....
              //pop out of drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Tile 2'),
            onTap: () {
              // do something
              //....
              //pop out of drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),

 */
/*
Map<String, dynamic> createBarArray() {
    Map<String, dynamic> barMenuItems = Map<String, dynamic>();
    for (var k in optionsGathered.keys) {
      if (k.startsWith('lmenuitemname')) {
        String str = k.substring(13);
        barMenuItems[optionsGathered[k]] =
            optionsGathered['lmenuitemurl' + str];
        //print(optionsGathered[k]);
      }
    }
    //print(barMenuItems.length);
    return barMenuItems;
  }

 */
//                      ? PopupMenuButton<String>(
//                          onSelected: handleEvent,
//                          itemBuilder: (BuildContext context) {
//                            return {'Logout', 'Settings'}.map((String choice) {
//                              return PopupMenuItem<String>(
//                                value: choice,
//                                child: Text(choice),
//                              );
//                            }).toList();
//                          },
//                        )
//wtaDrawer before starting panga of future builder

/* Before Future builder panga with popupmenu

  @override
  Widget build(BuildContext context) {
    print("CREATE ELLIPSIS ARRAY");
    createEllipsisArray();
    print(rMenuItemNames);
    return PopupMenuButton<String>(
      onSelected: handleEvent,
      itemBuilder: (BuildContext context) {
        return rMenuItemNames.map((choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void handleEvent(String value) {
    int index = getIndex(value, rMenuItemNames);
    if (rMenuItemUrls[index] != "") {
      widget.controller.loadUrl(rMenuItemUrls[index]);
    }
  }

  int getIndex(String choice, List strList) {
    return strList.indexOf(choice);
  }
}

*/
//
//  void share(String passedText) {
//    print("IN SHARE $passedText");
//    Share.share(passedText);
//  }

//  loadCurrentUrl() async {
//    var currentUrl = await controller.currentUrl();
//    await controller.loadUrl(currentUrl);
//  }
//
///    FutureBuilder<WebViewController>(
//      future: _controller.future,
//      builder:
//          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
//        if (snapshot.hasData) {
//          print("HAS DATA");
//          snapshot.data.loadUrl(url);
//        } else {
//          print("NO DATA");
//        }
//        return Container();
//      },
//    );
//
//    if (await canLaunch(url)) {
//      await launch(
//        url,
//        forceSafariVC: true,
//        forceWebView: true,
//        enableJavaScript: true,
//      );
//    } else {
//      throw 'Could not launch $url';
//    }
//}

//  goBack([BuildContext context]) async {
//    bool canGoBack = await controller.canGoBack();
//    if (canGoBack == true) {
//      controller.goBack();
//    } else {
//      MinimizeApp.minimizeApp();
//    }
//  }
//
//  goForward() async {
//    bool canGoForward = await controller.canGoForward();
//    if (canGoForward) {
//      controller.goForward();
//    } else {
//      //TODO msg cant go forard
//    }
//  }
//
//  reload() async {
//    await controller.reload();
//  }
//
//  btnAction(String str, String strUrl) {
//    print("IN BTN ACTION");
//    print(str);
//    print(strUrl);
//    switch (str) {
//      case 'lhome':
//      case 'rhome':
//        try {
//          loadUrl(widget.optionsGathered['mainUrl']);
//          //loadCurrentUrl(_controller.future, widget.optionsGathered['mainUrl']);
//          //LoadCurrentUrl(_controller, widget.optionsGathered['mainUrl']);
//        } catch (e) {
//          print(e);
//        }
//        break;
//
//      case 'rback':
//      case 'lback':
//        goBack();
//        break;
//      case 'rreload':
//        reload();
//        break;
//      case 'lforward':
//      case 'rforward':
//        goForward();
//        break;
//      case 'rcart':
//      case 'lcart':
//      case 'lsearch':
//      case 'rsearch':
//        if (strUrl != "") {
//          try {
//            loadUrl(strUrl);
//          } catch (e) {
//            print(e);
//          }
//        } else {
//          //msg option not set
//        }
//
//        break;
//      case 'rshare':
//        share(strUrl);
//        break;
//      default:
//        break;
//    }
//  }
