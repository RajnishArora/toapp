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
// static String get appId {
//   if (Platform.isAndroid) {
//     return "ca-app-pub-3940256099942544~4354546703";
//   } else if (Platform.isIOS) {
//     return "ca-app-pub-3940256099942544~2594085930";
//   } else {
//     throw new UnsupportedError("Unsupported platform");
//   }
// }
//
// static String get bannerAdUnitId {
//   if (Platform.isAndroid) {
//     return "ca-app-pub-3940256099942544/8865242552";
//   } else if (Platform.isIOS) {
//     return "ca-app-pub-3940256099942544/4339318960";
//   } else {
//     throw new UnsupportedError("Unsupported platform");
//   }
// }
//
// static String get interstitialAdUnitId {
//   if (Platform.isAndroid) {
//     return "ca-app-pub-3940256099942544/7049598008";
//   } else if (Platform.isIOS) {
//     return "ca-app-pub-3940256099942544/3964253750";
//   } else {
//     throw new UnsupportedError("Unsupported platform");
//   }
// }
//
// static String get rewardedAdUnitId {
//   if (Platform.isAndroid) {
//     return "ca-app-pub-3940256099942544/8673189370";
//   } else if (Platform.isIOS) {
//     return "ca-app-pub-3940256099942544/7552160883";
//   } else {
//     throw new UnsupportedError("Unsupported platform");
//   }
// }
//
