import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webtoapp/Components/wtaBtnAction.dart';
import 'package:webtoapp/Components/wtaCustomPopupMenu.dart';
import 'package:webtoapp/Data/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class WtaAppbar extends StatefulWidget implements PreferredSizeWidget {
  WtaAppbar({this.optionsGathered, this.completer});

  @override
  final Size preferredSize = Size.fromHeight(60.0);
  //WtaAppbar({this.optionsGathered, this.completer});
  final Map<String, dynamic> optionsGathered;

  final Completer<WebViewController> completer;
  @override
  _WtaAppbarState createState() => _WtaAppbarState();
}

class _WtaAppbarState extends State<WtaAppbar> {
  String str = "";

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Future<File> getImageFile(String imgUrl) async {
    if (imgUrl != "") {
      imgUrl = imgUrl.trim();
      imgUrl = imgUrl.replaceAll('localhost', baseIp);
      print("IMGURL");
      print(imgUrl);
      String folderName = 'wtaImages';
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
      return File("");
    }
    return File("");
  }

  @override
  Widget build(BuildContext context) {
    bool hideAppbar =
        widget.optionsGathered['hideAppbar'] == 'yes' ? true : false;

    final Future<File> titleImage =
        getImageFile(widget.optionsGathered['imageLocation']);

    if (hideAppbar) {
      return Container();
    } else {
      return FutureBuilder<WebViewController>(
          future: widget.completer.future,
          builder: (BuildContext context,
              AsyncSnapshot<WebViewController> controller) {
            if (controller.hasData) {
              return AppBar(
                title: (() {
                  if (widget.optionsGathered['headerOption'] == 'only-text') {
                    return Text(widget.optionsGathered['appTitle']);
                  } else if (widget.optionsGathered['headerOption'] ==
                      'only-image') {
                    return FutureBuilder(
                        future: titleImage,
                        builder: (BuildContext context,
                            AsyncSnapshot<File> snapshot) {
                          if (snapshot.hasData) {
                            return Image.file(snapshot.data);
                          }
                          return Container();
                        });
                  } else {
                    return Container();
                  }
                }()),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _colorFromHex(widget.optionsGathered['colSelFirst']),
                        ((widget.optionsGathered['gradientOptionSelected'] ==
                                    'no') ||
                                (widget.optionsGathered[
                                        'gradientOptionSelected'] ==
                                    null))
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
                      completer: widget.completer,
                      optionsGathered: widget.optionsGathered,
                      str: 'left'),
                ),
                actions: [
                  //switch not working
                  widget.optionsGathered['rightFirstIcon'] == 'rmenu'
                      ? (CustomPopupMenu(
                          optionsGathered: widget.optionsGathered,
                          completer: widget.completer))
                      : (widget.optionsGathered['rightFirstIcon'] == ""
                          ? SizedBox.shrink()
                          : BtnAction(
                              completer: widget.completer,
                              str: 'rightFirst',
                              optionsGathered: widget.optionsGathered,
                            )),
                  widget.optionsGathered['rightSecondIcon'] == 'rmenu'
                      ? CustomPopupMenu(
                          optionsGathered: widget.optionsGathered,
                          completer: widget.completer,
                        )
                      : widget.optionsGathered['rightSecondIcon'] == ""
                          ? SizedBox.shrink()
                          : BtnAction(
                              completer: widget.completer,
                              str: 'rightSecond',
                              optionsGathered: widget.optionsGathered,
                            ),
                ],
              );
            }
            return Container();
          });
    }
    // build
  }
}
