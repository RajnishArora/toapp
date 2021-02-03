import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  bool gotResult() {
    return true;
  }

  Future getData() async {
    http.Response response = await http.Client().get(Uri.parse(url));
    if (response.statusCode == 200) {
      var document = parse(response.body);
      var header = parse(document.getElementsByTagName('header')[0].innerHtml);
      print(header.getElementsByTagName('a')[1].innerHtml);
      print(header.getElementsByTagName('a')[1].attributes['href']);
      return document;
    } else {
      print('Failed');
      return response.statusCode;
    }
  }
}
