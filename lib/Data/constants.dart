import 'dart:io';

String getIp() {
  if (Platform.isAndroid) {
    return "10.0.2.2";
  } else if (Platform.isIOS) {
    return "127.0.0.1";
  }
  return null;
}

//final baseIp = "10.0.2.2";
//final baseIp = "127.0.0.1";

String baseIp = getIp();
final baseUrl = "http://" + baseIp + "/";

//final String androidBaseUrl = "http://10.0.2.2/";
//final String iosBaseUrl = "http://127.0.0.1/"