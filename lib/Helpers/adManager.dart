import 'dart:io';

class AdManager {
  AdManager({this.optionsGathered});

  final Map<String, dynamic> optionsGathered;

  String getAppId() {
    if (Platform.isAndroid) {
      if (optionsGathered['admobAppidAndroid'] != null) {
        return optionsGathered['admobAppidAndroid'];
      } else {
        return "ca-app-pub-3940256099942544~4354546703";
      }
    } else if (Platform.isIOS) {
      if (optionsGathered['admobAppidIos'] != null) {
        return optionsGathered['admobAppidIos'];
      } else {
        return "ca-app-pub-3940256099942544~2594085930";
      }
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      if (optionsGathered['bannerandroid'] != null) {
        return optionsGathered['bannerandroid'];
      } else {
        return "ca-app-pub-3940256099942544/8865242552";
      }
    } else if (Platform.isIOS) {
      if (optionsGathered['bannerios'] != null) {
        return optionsGathered['bannerios'];
      } else {
        return "ca-app-pub-3940256099942544/4339318960";
      }
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
