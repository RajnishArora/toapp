import 'package:http/http.dart' as http;
//import 'dart:convert';

class OptionsGatherer {
  OptionsGatherer(this.url);

  final String url;

  Future getData() async {
//    http.Response response = await http.Client().get(Uri.parse(url));
//    this is useful when u want to go inside the url data
    http.Response response = await http.get(url).timeout(
        Duration(
          seconds: 100,
        ), onTimeout: () {
      print('FAILED BY TIMEOUT');
      return null;
    });
    if (response.statusCode == 200) {
      return response.body;
      //return jsonDecode(response.body);
    } else {
      print('Failed');
      return null;
    }
  }
}
