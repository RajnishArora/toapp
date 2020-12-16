import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webtoapp/screens/language_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:webtoapp/Data/constants.dart';
import 'package:easy_localization/easy_localization.dart';

class WtaDrawer extends StatefulWidget {
  WtaDrawer({this.optionsGathered, this.completer});
  final Map<String, dynamic> optionsGathered;

  final Completer<WebViewController> completer;

  @override
  _WtaDrawerState createState() => _WtaDrawerState();
}

class _WtaDrawerState extends State<WtaDrawer> {
  var lMenuItemNames = List();
  var lMenuItemUrls = List();
  var lMenuItemIcons = List();

  var socialListIcon = List();
  var socialListName = List();
  var socialListUrl = List();

  var fileList = List();
  List<File> fileListArray = List();
  //GetHeaderIcon _getHeaderIcon = GetHeaderIcon();

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Future<File> getImageFile(String imgUrl) async {
    if (imgUrl != "" && imgUrl != null) {
      imgUrl = imgUrl.trim();
      imgUrl = imgUrl.replaceAll('localhost', baseIp);

      String folderName = 'images';
      String requiredPath;
      final Directory documentDirectory =
          await getApplicationDocumentsDirectory();

      final Directory applicationDirectory =
          Directory('${documentDirectory.path}/$folderName/');
      //
      if (await applicationDirectory.exists()) {
        print("DIR ALREADY EXISTS");
        requiredPath = applicationDirectory.path;
      } else {
        //if folder not exists create folder and then return its path
        print("CREATING DIR");
        final Directory applicationDirectoryNew =
            await applicationDirectory.create(recursive: true);
        requiredPath = applicationDirectoryNew.path;
      }

      String filename = requiredPath + path.basename(imgUrl);
      // extract file name from url by finding /.last
      print(filename);
      File file = File(filename);
      if (await file.exists()) {
        print("FILE ALREADY EXISTS SO NO SAVING");
        return file;
      }
      //String str = filename;
      //File fileNew = File(path.join(requiredPath, filename));
      //print("FILE PATH");
      //print(filename);
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

  Icon getFAIcon(String str) {
    Icon ic = Icon(FontAwesomeIcons.android);
    switch (str) {
      case 'Facebook':
        ic = Icon(FontAwesomeIcons.facebookF);
        break;
      case 'Whatsapp':
        ic = Icon(FontAwesomeIcons.whatsapp);
        break;
      case 'Instagram':
        ic = Icon(FontAwesomeIcons.instagram);
        break;
      case 'Youtube':
        ic = Icon(FontAwesomeIcons.youtube);
        break;

      case 'SMS':
        ic = Icon(FontAwesomeIcons.sms);
        break;
      case 'Call':
        ic = Icon(FontAwesomeIcons.phone);
        break;
    }
    return ic;
  }

  String getItemUrl(String str, String toAdd) {
    // add facebook id or whatapp id later;
    String selectedUrl = "";
    if (toAdd == "!") {
      toAdd = "";
    }
    switch (str) {
      case 'Facebook':
        selectedUrl = "fb://arorarajnish" + toAdd;
        break;
      case 'Whatsapp':
        selectedUrl = "whatsapp://send?phone=" + toAdd;
        break;
      case 'Instagram':
        selectedUrl = "https://instagram.com/" + toAdd;
        break;
      case 'Youtube':
        selectedUrl = "https://youtube.com/" + toAdd;
        break;
      case 'SMS':
        selectedUrl = "sms://" + toAdd;
        break;
      case 'Call':
        selectedUrl = "tel://" + toAdd;
        break;
    }

    return selectedUrl;
  }

  void createSocialArray() {
    // Covert into 1 2-D array Later
    var nameList = new List();
    socialListName.clear();
    socialListIcon.clear();
    socialListUrl.clear();
    int len = 0;
    if (widget.optionsGathered['socialMenu'] != null) {
      nameList = widget.optionsGathered['socialMenu'].split(',');
    }

    len = nameList.length;
    int i = 0;
    while (i < len) {
      socialListName.add(nameList[i]);
      socialListIcon.add(getFAIcon(nameList[i]));
      int j = i + 1;
      socialListUrl.add(getItemUrl(nameList[i], nameList[j]));
      i += 2;
    }
    // for (int i = 0; i < len; i++) {
    //   socialListName.add(nameList[i]);
    //   socialListIcon.add(getFAIcon(nameList[i]));
    //   socialListUrl.add(getItemUrl(nameList[i]));
    // }
    print("SOCIAL ARRAY");
    //print(nameList);
    //print(nameList.length);
    print(socialListName);
    print(socialListUrl);
  }

  void createBarArray() {
    int index = 0;
    lMenuItemIcons.clear();
    lMenuItemNames.clear();
    lMenuItemUrls.clear();

    index = int.parse(widget.optionsGathered['lmenuitemnumber']);
    print("INDEX");
    print(index);
    //this is done so the final array is in ascending order
    for (int i = 0; i < index; i++) {
      if (widget.optionsGathered['lmenuitemname' + i.toString()] != null &&
          widget.optionsGathered['lmenuitemname' + i.toString()] != "") {
        lMenuItemIcons
            .add(widget.optionsGathered['lmenuiconlocation' + i.toString()]);
        lMenuItemNames
            .add(widget.optionsGathered['lmenuitemname' + i.toString()]);
        lMenuItemUrls
            .add(widget.optionsGathered['lmenuitemurl' + i.toString()]);
      }
    }
    //print("LMENU ITEM ICONS");
    //print(lMenuItemIcons);
    //print(lMenuItemNames);
    //print(lMenuItemUrls);
  }

  //creates array of file items in fileList
  createFileArray(int maxItems) {
    fileList.clear();
    for (int i = 0; i < maxItems; i++) {
      fileList.add(createFileItem(i));
    }
  }

  Future<File> createFileItem(int i) async {
    return await getImageFile(lMenuItemIcons[i]);
  }

  @override
  Widget build(BuildContext context) {
    createBarArray();
    createSocialArray();
    //Future<File> temp = getImageFile(lMenuItemIcons[0]);
    int itemCount = lMenuItemNames.length;
    createFileArray(itemCount); // to create array of file of image(icon)

    int socialItemCount = socialListName.length;

    final Future<File> drawerHeaderImage =
        getImageFile(widget.optionsGathered['drawerImageLocation']);

    return FutureBuilder<WebViewController>(
        future: widget.completer.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return Drawer(
              child: ListView(
                children: [
                  Container(
                    height: 155.0,
                    child: DrawerHeader(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              height: 70.0,
                              child: (() {
                                return FutureBuilder(
                                    future: drawerHeaderImage,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<File> snapshot) {
                                      if (snapshot.hasData) {
                                        return SizedBox(
                                          //width: 100.0,
                                          height: 70.0,
                                          child: Image.file(snapshot.data),
                                        );
                                      }
                                      return Container(
                                        width: 70.0,
                                        height: 70.0,
                                        //child: Text('Oh!'),
                                      );
                                    });
                              }()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: (widget
                                        .optionsGathered['drawerHeaderText'] !=
                                    null)
                                ? Text(
                                    widget.optionsGathered['drawerHeaderText'],
                                    style: TextStyle(
                                      fontFamily: 'ProductSans',
                                      fontSize: 20.0,
                                    ),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: _colorFromHex(
                              widget.optionsGathered['colSelFirst']),
                          border: Border.all(
                            width: 1.0,
                          )),
                    ),
                  ),
                  Container(
                    //height: double.maxFinite,
                    child: (itemCount > 0)
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            padding: const EdgeInsets.only(
                              top: 0.0,
                            ),
                            itemCount: itemCount,
                            itemBuilder: (BuildContext context, k) {
                              //print(k);

                              return ListTile(
                                leading: (() {
                                  return FutureBuilder(
                                      future: fileList[k],
                                      builder: (BuildContext context,
                                          AsyncSnapshot<File> snapshot) {
                                        if (snapshot.hasData) {
                                          return SizedBox(
                                            width: 40.0,
                                            height: 40.0,
                                            child: Image.file(snapshot.data),
                                          );
                                        }
                                        return Container(
                                          width: 40.0,
                                          height: 40.0,
                                          //child: Text('Oh!'),
                                        );
                                      });
                                }()),
                                //leading: Image.file(temp),
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    lMenuItemNames[k],
                                    style: TextStyle(
                                      fontFamily: 'ProductSans',
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  print("ABOUT TO LAUNCH");
                                  CircularProgressIndicator(
                                    backgroundColor: Colors.red,
                                  );
                                  print("LAUNCHED");
                                  if (lMenuItemNames[k] == 'Home') {
                                    await controller.data.loadUrl(
                                        widget.optionsGathered['mainUrl']);
                                  } else {
                                    await controller.data
                                        .loadUrl(lMenuItemUrls[k]);
                                  }

                                  Navigator.pop(context);
                                  FocusScope.of(context)
                                      .unfocus(); //minimize keyboard
                                },
                                // trailing: IconButton(
                                //   icon: FaIcon(FontAwesomeIcons.angleRight),
                                //   onPressed: () {},
                                // ),
                              );
                            },
                          )
                        : Center(child: Container()),
                  ),
                  Divider(),
                  Container(
                    child: ListTile(
                      leading: SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Icon(Icons.language),
                      ),
                      title: Text(
                        'Languages',
                        style: TextStyle(
                          fontFamily: 'ProductSans',
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ).tr(),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LangScreen(
                                      context: context,
                                    )));
                      },
                    ),
                  ),
                  Divider(),
                  Container(
                      child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                      top: 0.0,
                    ),
                    physics: ClampingScrollPhysics(),
                    itemCount: socialItemCount,
                    itemBuilder: (BuildContext context, index) {
                      return ListTile(
                        leading: socialListIcon[index],
                        title: Text(
                          socialListName[index],
                          style: TextStyle(
                            fontFamily: 'ProductSans',
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        onTap: () async {
                          print("ABOUT TO LAUNCH");
                          CircularProgressIndicator(
                            backgroundColor: Colors.red,
                            value: 8.0,
                          );
                          print("LAUNCHED");
                          await launch(socialListUrl[index]);
                          // using url_launcher
                          // if (await canLaunch(socialListUrl[index])) {
                          //   await launch(socialListUrl[index]);
                          // } else {
                          //   throw 'Could not launch socialListUrl[index]';
                          // }
                          //await controller.data.loadUrl(socialListUrl[index]);
                          Navigator.pop(context);
                        },
                      );
                    },
                  )),
                ],
              ),
            );
          }
          return Container();
        });
  }
}
