import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import 'package:webtoapp/Components/options_gatherer.dart';
import 'package:webtoapp/Helpers/adManager.dart';
import 'package:webtoapp/screens/view_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:http/http.dart' as http;
//import 'package:path/path.dart' as path;
import 'package:webtoapp/Data/constants.dart';
import 'package:webtoapp/Helpers/Firebase_Notifications.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
//  SharedPreferences prefs;
  //final String baseUrl = "http://10.0.2.2/";

  //final FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _deleteCacheDir();
    FirebaseNotifications().setUpFirebase();
    //this._initAdMob();
    //_messaging.getToken().then((token) {
    //  print(token);
    //});
    //Future<SharedPreferences> prefs = getPrefs();
    getOptionsData();
    initOneSignal();
  }

  Future<void> _initAdMob(Map<String, dynamic> option) {
    String appId = AdManager(optionsGathered: option).getAppId();
    return FirebaseAdMob.instance.initialize(appId: appId);
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      print("DELETING CACHE");
      cacheDir.deleteSync(recursive: true);
    }
  }
//    var appDir = (await getTemporaryDirectory()).path + '/<package_name>';
//    new Directory(appDir).delete(recursive: true);

//  Future<void> _deleteAppDir() async {
//    final appDir = await getApplicationSupportDirectory();
//
//    if (appDir.existsSync()) {
//      appDir.deleteSync(recursive: true);
//    }
//  }

  void getOptionsData() async {
    var options = Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //prefs = await SharedPreferences.getInstance();
    //final String baseUrl = "http://192.168.43.203";

    final Directory documentDirectory =
        await getApplicationDocumentsDirectory();

    String filename = documentDirectory.path + '/wta.cfg';
    // extract file name from url by finding /.last
    File file = File(filename);
    // if (await file.exists()) {
    //   print("FILE EXISTS IN LOADINGSCREEN");
    //   //no need to
    // } else
    {
      //print("NO FILE IN LOADINGSCREEN");
      String url = baseUrl + 'try_rest_api/app/optionsapi.php';
      OptionsGatherer optionsGatherer = OptionsGatherer(url);
      // 'http://192.168.0.7/try_rest_api/app/optionsapi.php');
      //   'http://192.168.43.203/try_rest_api/app/optionsapi.php');
      //OptionsGatherer('http://10.0.2.2/try_rest_api/app/optionsapi.php');
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
          return;
        }
      } catch (e) {
        print("no host so looking for shared pref");
        print(e);
      }

      file.create(recursive: true);
      // create it
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

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return WebViewClass(optionsGathered: options);
      },
    ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
