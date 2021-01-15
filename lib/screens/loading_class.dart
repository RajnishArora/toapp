import 'package:firebase_admob/firebase_admob.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import 'package:webtoapp/Components/options_gatherer.dart';
import 'package:webtoapp/Helpers/adManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoapp/Data/constants.dart';
import 'package:webtoapp/Helpers/Firebase_Notifications.dart';

class LoadingClass {
  LoadingClass() {
    FirebaseNotifications().setUpFirebase();
  }

  Future<Map> getOptionsData() async {
    var options = Map<String, dynamic>();
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
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context) {
    //     return WebViewClass(optionsGathered: options);
    //   },
    // ));
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
