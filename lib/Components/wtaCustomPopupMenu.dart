import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomPopupMenu extends StatefulWidget {
  CustomPopupMenu({this.optionsGathered, this.completer});
  final Map<String, dynamic> optionsGathered;

  final Completer<WebViewController> completer;

  @override
  _CustomPopupMenuState createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  var rMenuItemNames = [];
  //List rMenuItemNames;
  var rMenuItemUrls = [];

  void createEllipsisArray() {
    if (rMenuItemNames.isNotEmpty) {
      rMenuItemNames.clear();
    }
    if (rMenuItemUrls.isNotEmpty) {
      rMenuItemUrls.clear();
    }
    int index = int.parse(widget.optionsGathered['rmenuitemnumber']);
    //this is done so the final array is in ascending order
    for (int i = 0; i < index; i++) {
      rMenuItemNames
          .add(widget.optionsGathered['rmenuitemname' + i.toString()]);
      rMenuItemUrls.add(widget.optionsGathered['rmenuitemurl' + i.toString()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("CREATE ELLIPSIS ARRAY");
    createEllipsisArray();
    print(rMenuItemNames);
    return FutureBuilder<WebViewController>(
        future: widget.completer.future,
        builder: (
          BuildContext context,
          AsyncSnapshot<WebViewController> controller,
        ) {
          if (controller.hasData) {
            return PopupMenuButton<String>(
              onSelected: (choice) => controller.data
                  .loadUrl(rMenuItemUrls[rMenuItemNames.indexOf(choice)]),
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
          return Container(); //controller doesnot have data
        });
  }
}
