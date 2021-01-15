import 'package:flutter/material.dart';

class InternetError extends StatefulWidget {
  @override
  _InternetErrorState createState() => _InternetErrorState();
}

class _InternetErrorState extends State<InternetError> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image(
              image: AssetImage('assets/icon/sad-face.jpg'),
            ),
          ),
          Text('The device has no Internet Connection'),
          TextButton(
            child: Text('Check Connectivity Again '),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
