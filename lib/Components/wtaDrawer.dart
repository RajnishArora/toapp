import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webtoapp/screens/about_us.dart';
import 'package:webtoapp/screens/language_screen.dart';
import 'package:webtoapp/screens/privacy_policy.dart';
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
  var lMenuItemNames = [];
  var lMenuItemUrls = [];
  var lMenuItemIcons = [];

  var socialListIcon = [];
  var socialListName = [];
  var socialListUrl = [];

  var fileList = [];
  List<File> fileListArray = [];
  //GetHeaderIcon _getHeaderIcon = GetHeaderIcon();

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Future<File> getImageFile(String imgUrl) async {
    if (imgUrl != "") {
      imgUrl = imgUrl.trim();
      imgUrl = imgUrl.replaceAll('localhost', baseIp);

      String folderName = 'wtaImages';
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
      try {
        var response = await http.get(imgUrl);
        print("FILE COPIED");
        return new File(filename)..writeAsBytesSync(response.bodyBytes);
        //fileNew.writeAsBytesSync(response.bodyBytes);

      } catch (e) {
        print("Could not copy file");
        print(e);
      }
      return File("");
    }
    return File("");
  }

  Color _headerBgColor = Colors.white;
  Color _drawerBgColor = Colors.white;
  Color _fontColor = Colors.black;
  Color _fontColorH = Colors.black;

  void setDrawerColors() {
    _headerBgColor = _colorFromHex(widget.optionsGathered['colSelFirst']);
    switch (widget.optionsGathered['drawerHeaderCol']) {
      case 'dark':
        _headerBgColor = Colors.grey[900];
        _fontColorH = Colors.white;
        break;
      case 'light':
        _headerBgColor = Colors.white;
        _fontColorH = Colors.black;
        break;
      case 'default':
        _headerBgColor = _colorFromHex(widget.optionsGathered['colSelFirst']);
        _fontColorH = Colors.black;
        break;
      default:
        _headerBgColor = _colorFromHex(widget.optionsGathered['colSelFirst']);
        _fontColorH = Colors.black;
        break;
    }
    switch (widget.optionsGathered['drawerBackgroundCol']) {
      case 'dark':
        _drawerBgColor = Colors.grey[800];
        _fontColor = Colors.white;
        break;
      case 'light':
        _drawerBgColor = Colors.white;
        _fontColor = Colors.black;
        break;
      default:
        _drawerBgColor = Colors.white;
        _fontColor = Colors.black;
        break;
    }
  }

  Icon getFAIcon(String str) {
    Icon ic = Icon(
      FontAwesomeIcons.android,
      color: _fontColor,
    );
    switch (str) {
      case 'Facebook':
        ic = Icon(
          FontAwesomeIcons.facebookF,
          color: _fontColor,
        );
        break;
      case 'Whatsapp':
        ic = Icon(
          FontAwesomeIcons.whatsapp,
          color: _fontColor,
        );
        break;
      case 'Instagram':
        ic = Icon(
          FontAwesomeIcons.instagram,
          color: _fontColor,
        );
        break;
      case 'Youtube':
        ic = Icon(
          FontAwesomeIcons.youtube,
          color: _fontColor,
        );
        break;

      case 'SMS':
        ic = Icon(
          FontAwesomeIcons.sms,
          color: _fontColor,
        );
        break;
      case 'Call':
        ic = Icon(
          FontAwesomeIcons.phone,
          color: _fontColor,
        );
        break;
    }
    return ic;
  }

  Image getIconImage(String str) {
    Image img = Image.asset(
      'assets/images/socialLogo-min.png',
      width: 25.0,
      height: 25.0,
    );
    switch (str) {
      case 'Facebook':
        img = Image.asset(
          'assets/images/facebookLogo-min.png',
          width: 25.0,
          height: 25.0,
        );
        break;
      case 'Whatsapp':
        img = Image.asset(
          'assets/images/whatsappLogo-min.png',
          width: 25.0,
          height: 25.0,
        );
        break;
      case 'Instagram':
        img = Image.asset(
          'assets/images/instagramLogo-min.png',
          width: 25.0,
          height: 25.0,
        );
        break;
      case 'Youtube':
        img = Image.asset(
          'assets/images/youtubeLogo-min.png',
          width: 25.0,
          height: 25.0,
        );
        break;

      case 'SMS':
        img = Image.asset(
          'assets/images/smsLogo-min.png',
          width: 25.0,
          height: 25.0,
        );
        break;
      case 'Call':
        img = Image.asset(
          'assets/images/phoneLogo-min.png',
          width: 25.0,
          height: 25.0,
        );
        break;
    }
    return img;
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
    var nameList = [];
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
      //socialListIcon.add(getFAIcon(nameList[i]));
      socialListIcon.add(getIconImage(nameList[i]));
      int j = i + 1;
      socialListUrl.add(getItemUrl(nameList[i], nameList[j]));
      i += 2;
    }
//    print("SOCIAL ARRAY");
//    print(socialListName);
//    print(socialListUrl);
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

  Future str;

  @override
  Widget build(BuildContext context) {
    setDrawerColors();
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
                //padding: EdgeInsets.only(top: 0),
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      FocusScope.of(context).unfocus(); //minimize keyboard
                      setState(() async {
                        await controller.data
                            .loadUrl(widget.optionsGathered['mainUrl']);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.zero,
                      child: DrawerHeader(
                        margin: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 70.0,
                                  child: (() {
                                    return FutureBuilder(
                                        future: drawerHeaderImage,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<File> snapshot) {
                                          if (snapshot.hasData &&
                                              snapshot.data != null) {
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0,
                                  right: 8.0,
                                  left: 8.0,
                                  bottom: 16.0),
                              child:
                                  (widget.optionsGathered['drawerHeaderText'] !=
                                          null)
                                      ? Text(
                                          widget.optionsGathered[
                                              'drawerHeaderText'],
                                          style: TextStyle(
                                            color: _fontColorH,
                                            fontFamily: 'ProductSans',
                                            fontSize: 24.0,
                                          ),
                                        )
                                      : Container(),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: _headerBgColor,
                          border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color: _fontColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //height: double.maxFinite,
                    color: _drawerBgColor,
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
                                            width: 25.0,
                                            height: 25.0,
                                            child: Image.file(
                                              snapshot.data,
                                              alignment: Alignment.center,
                                            ),
                                          );
                                        }
                                        return Container(
                                          width: 25.0,
                                          height: 25.0,
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
                                      color: _fontColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),

                                onTap: () {
                                  // print("ABOUT TO LAUNCH");
                                  Navigator.pop(context);
                                  FocusScope.of(context)
                                      .unfocus(); //minimize keyboard
                                  //print("LAUNCHED");
                                  if (lMenuItemNames[k] == 'Home') {
                                    setState(() async {
                                      await controller.data.loadUrl(
                                          widget.optionsGathered['mainUrl']);
                                    });
                                  } else {
                                    setState(() async {
                                      await controller.data
                                          .loadUrl(lMenuItemUrls[k]);
                                    });
                                  }
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
                  Divider(
                    height: 1.5,
                    color: _fontColor,
                  ),
                  Container(
                    color: _drawerBgColor,
                    child: ListTile(
                      leading: SizedBox(
                        width: 25.0,
                        height: 25.0,
                        child: Icon(
                          Icons.language,
                          color: _fontColor,
                        ),
                      ),
                      title: Text(
                        'Languages',
                        style: TextStyle(
                          fontFamily: 'ProductSans',
                          color: _fontColor,
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
                  Divider(
                    height: 1.0,
                    color: _fontColor,
                  ),
                  Container(
                      color: _drawerBgColor,
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
                                color: _fontColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            onTap: () async {
                              //print("ABOUT TO LAUNCH");

                              await launch(socialListUrl[index]);

                              Navigator.pop(context);
                            },
                          );
                        },
                      )),
                  Divider(
                    height: 1.0,
                    color: _fontColor,
                  ),
                  Container(
                    color: _drawerBgColor,
                    child: (widget.optionsGathered['ppOption'] == null ||
                            widget.optionsGathered['ppOption'] == 'no')
                        ? null
                        : ListTile(
                            leading: SizedBox(
                              width: 25.0,
                              height: 25.0,
                              child: Icon(
                                Icons.privacy_tip_outlined,
                                color: _fontColor,
                              ),
                            ),
                            title: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontFamily: 'ProductSans',
                                color: _fontColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ).tr(),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PrivacyPolicy(
                                            policy: widget
                                                .optionsGathered['ppText'],
                                          )));
                            },
                          ),
                  ),
                  Container(
                    color: _drawerBgColor,
                    child: (widget.optionsGathered['aboutUsOption'] == null ||
                            widget.optionsGathered['aboutUsOption'] == 'no')
                        ? null
                        : ListTile(
                            leading: SizedBox(
                              width: 25.0,
                              height: 25.0,
                              child: Icon(
                                Icons.account_circle,
                                color: _fontColor,
                              ),
                            ),
                            title: Text(
                              'About Us',
                              style: TextStyle(
                                fontFamily: 'ProductSans',
                                color: _fontColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ).tr(),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutUs(
                                            aboutUs: widget
                                                .optionsGathered['aboutUsText'],
                                          )));
                            },
                          ),
                  ),
                  Container(
                    color: _drawerBgColor,
                    height:
                        (widget.optionsGathered['admobOption'] == 'banner' &&
                                widget.optionsGathered['admobPosition'] ==
                                    'bottomads')
                            ? 50.0
                            : 0.0,
                  ),
                ],
              ),
            );
          }
          return Container();
        });
  }
}
