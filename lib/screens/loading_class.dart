import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:webtoapp/Components/options_gatherer.dart';
import 'package:webtoapp/Helpers/adManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoapp/Data/constants.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:webtoapp/Helpers/Firebase_Notifications.dart';

class LoadingClass {
  var options = Map<String, dynamic>();
  LoadingClass() {
    FirebaseNotifications().setUpFirebase();
  }

  void createImagesDir() async {
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
    String dImage = options['drawerImageLocation'];
    dImage = dImage.trim();
    String dFileName = requiredPath + path.basename(dImage);
    File dFile = File(dFileName);
    if (await dFile.exists()) {
      print("IN LOADING CLASS FILE ALREADY EXISTS SO NO SAVING");
    } else {
      try {
        var response = await http.get(dImage);
        print("IN LOADING CLASS  FILE COPIED");
        File(dFileName)..writeAsBytesSync(response.bodyBytes);
        //fileNew.writeAsBytesSync(response.bodyBytes);

      } catch (e) {
        print("Could not copy file");
        print(e);
      }
    }

    int index = 0;
    index = int.parse(options['lmenuitemnumber']);
    for (int i = 0; i < index; i++) {
      String imgUrl = options['lmenuiconlocation' + i.toString()];
      imgUrl = imgUrl.trim();
      imgUrl = imgUrl.replaceAll('localhost', baseIp);
      print("LOADING IMGURL");
      print(imgUrl);
      String filename = requiredPath + path.basename(imgUrl);
      // extract file name from url by finding /.last
      print("LOADING FILENAME");
      print(filename);
      File file = File(filename);
      if (await file.exists()) {
        print("IN LOADING CLASS FILE ALREADY EXISTS SO NO SAVING");
      } else {
        try {
          var response = await http.get(imgUrl);
          print("IN LOADING CLASS  FILE COPIED");
          File(filename)..writeAsBytesSync(response.bodyBytes);
          //fileNew.writeAsBytesSync(response.bodyBytes);

        } catch (e) {
          print("Could not copy file");
          print(e);
        }
      }
    } // for loop ends
  }

  Future<Map<String, dynamic>> getOptionsData() async {
    //var options = Map<String, dynamic>();
    options.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String url = baseUrl + 'try_rest_api/app/optionsapi.php';
    String url = baseUrl + 'wp-json/raj/v1/getOptions';
    OptionsGatherer optionsGatherer = OptionsGatherer(url);
    try {
      var rawJson = await optionsGatherer.getData();
      print("raw Json");
      print(rawJson);
      if (rawJson != null) {
        Map<String, dynamic> optionsTemp = jsonDecode(rawJson);

        optionsTemp.forEach((key, value) {
          prefs.setString(key, value);
        });
      } else {
        print("raw Json failed");
        return null;
      }
    } catch (e) {
      print("no host so looking for shared pref");
      print(e);
    }

    print("OUT OF TRY ");
    prefs.getKeys().forEach((element) {
      options[element] = prefs.getString(element);
    });

    print("PRINTING SHARED PREFS");
    //print(options['socialMenu']);
    print(options);
    if (options.isEmpty) {
      print("no options found");
      //return;
    }
    print("OPTIONS ABOVE");
    //saveImage(prefs.getString('imageLocation'));
    //prefs.clear();

    //initialize admob if required
    if (options['admobOption'] == 'banner') {
      this._initAdMob(options);
    }
    return options;
  }

  void initOneSignal() async {
    await OneSignal.shared.init("faffb267-fd8d-4af7-8534-b94a0b715e5f",
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: false
        });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  Future<void> _initAdMob(Map<String, dynamic> option) {
    String appId = AdManager(optionsGathered: option).getAppId();
    return FirebaseAdMob.instance.initialize(appId: appId);
  }
}
