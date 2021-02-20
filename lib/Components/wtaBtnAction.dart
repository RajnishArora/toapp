import 'dart:async';
import 'dart:io';
import 'package:move_to_background/move_to_background.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webtoapp/Helpers/GetHeaderIcons.dart';
import 'package:share/share.dart';

class BtnAction extends StatefulWidget {
  final Completer<WebViewController> completer;
  final Map<String, dynamic> optionsGathered;

  final String str;

  BtnAction({
    this.completer,
    this.optionsGathered,
    this.str,
  });

  @override
  _BtnActionState createState() => _BtnActionState();
}

class _BtnActionState extends State<BtnAction> {
  GetHeaderIcon _getHeaderIcon = GetHeaderIcon();

  Future<bool> backPossible(WebViewController webController) async {
    if (await webController.canGoBack()) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  void backWithMin(WebViewController webController) async {
    if (await webController.canGoBack()) {
      await webController.goBack();
    } else {
      if (Platform.isAndroid) {
        MoveToBackground.moveTaskToBack();
        //MinimizeApp.minimizeApp();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("IN BTN ACTION CLASS");

    return FutureBuilder(
        future: widget.completer.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          //&&  ( backPossible(controller.data) == Future.value(false) )
          if (controller.hasData) {
            return IconButton(
                icon: _getHeaderIcon
                    .getHeaderIcon(widget.optionsGathered[widget.str + 'Icon']),
                onPressed: () {
                  String optionChosen =
                      widget.optionsGathered[widget.str + 'Icon'];

                  if (widget.str == 'left' &&
                      widget.optionsGathered['leftIcon'] == 'lmenu') {
                    Scaffold.of(context).openDrawer();
                  } else {
                    switch (optionChosen) {
                      case 'lhome':
                      case 'rhome':
                        try {
                          if (controller.data != null) {
                            setState(() async {
                              await controller.data
                                  .loadUrl(widget.optionsGathered['mainUrl']);
                            });
                          }
                        } catch (e) {
                          print(e);
                        }
                        break;

                      case 'rback':
                      case 'lback':
                        backWithMin(controller.data);
                        //controller.data.goBack();
                        break;
                      case 'rreload':
                        controller.data.reload();
                        break;
                      case 'lforward':
                      case 'rforward':
                        controller.data.goForward();
                        break;
                      case 'rcart':
                      case 'lcart':
                      case 'lsearch':
                      case 'rsearch':
                        if (widget.optionsGathered[widget.str + 'Url'] != "") {
                          try {
                            controller.data.loadUrl(
                                widget.optionsGathered[widget.str + 'Url']);
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          //msg option not set
                        }

                        break;
                      case 'rshare':
                        Share.share(widget.optionsGathered[widget.str + 'Url']);
                        break;
                      default:
                        break;
                    }
                  }
                });
          }

          return Container();
        });
  }
}
