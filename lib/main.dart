import 'package:flutter/material.dart';
//import 'screens/loading_screen.dart';
import 'screens/loading_class.dart';
import 'package:webtoapp/screens/view_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:connectivity/connectivity.dart';
//import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:webtoapp/screens/internet_error.dart';
import 'dart:io';
import 'dart:async';
//Admob WebtoApp(App Name) ca-app-pub-3634343166278168~4965266544(admob key)
//Easy Localisation handled in this file
//Admob & Firebase handled in loading screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LoadingClass loadingClass = LoadingClass();
  loadingClass.initOneSignal();

  Future<Map<String, dynamic>> getMap() async {
    Map<String, dynamic> options = await loadingClass.getOptionsData();
    loadingClass.createImagesDir();
    return options;
  }

  //
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
    child: MyApp(
      options: await getMap(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({this.options});

  final Map<String, dynamic> options;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  var _defaultHome;

  void getHomePage() {
    _defaultHome = WebViewClass(optionsGathered: widget.options);
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        setState(() {
          _defaultHome = InternetError();
        });
        break;
      case ConnectivityResult.mobile:
        setState(() {
          _defaultHome = WebViewClass(optionsGathered: widget.options);
        });
        break;
      case ConnectivityResult.wifi:
        setState(() {
          _defaultHome = WebViewClass(optionsGathered: widget.options);
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getHomePage();
    });

    return MaterialApp(
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: _defaultHome,
      // home: FutureBuilder<bool>(
      //   future: isInternet(),
      //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      //     if (snapshot.hasData) {
      //       return getHomePage(snapshot.data);
      //     } else {
      //       return CircularProgressIndicator();
      //     }
      //   },
      // ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = true;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
