import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutUs extends StatelessWidget {
  final String aboutUs;

  AboutUs({this.aboutUs});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us').tr(),
      ),
      body: Text(aboutUs),
    );
  }
}
