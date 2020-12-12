import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';
import 'package:easy_localization/easy_localization.dart';

//Admob WebtoApp(App Name) ca-app-pub-3634343166278168~4965266544(admob key)
//Easy Localisation handled in this file
//Admob & Firebase handled in loading screen
void main() async {
  runApp(EasyLocalization(
    supportedLocales: [
      Locale('en'),
      Locale('hi'),
      Locale('fa'),
      Locale('ar'),
      Locale('fr'),
      Locale('es'),
      Locale('ja'),
      Locale('zh'),
      Locale('de'),
      Locale('ru'),
    ],
    path: 'assets/translations',
    fallbackLocale: Locale('en', 'US'),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: LoadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
