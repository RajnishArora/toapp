import 'package:flutter/material.dart';
import 'package:webtoapp/Lang/language.dart';
import 'package:easy_localization/easy_localization.dart';

class LangScreen extends StatefulWidget {
  //Language lang;
  final BuildContext context;

  const LangScreen({this.context});

  @override
  _LangScreenState createState() => _LangScreenState();
}

class _LangScreenState extends State<LangScreen> {
  //Locale locale;

  List<Language> langList = [
    Language(0, "🇺🇸", "English", "en"),
    Language(1, "🇮🇳", "हिंदी", "hi"),
    Language(2, "🇦🇫", "فارسی", "fa"),
    Language(3, "🇸🇦", "اَلْعَرَبِيَّةُ‎", "ar"),
    Language(4, "🇫🇷", "langue française", "fr"),
    Language(5, "🇪🇸", "lengua española", "es"),
    Language(6, "🇯🇵", "日本人", "ja"),
    Language(7, "🇨🇳", "中文", "zh"),
    Language(8, "🇩🇪", "Deutsche", "de"),
    Language(9, "🇷🇺", "русский", "ru"),
  ];

  // void _showToast(BuildContext context) {
  //   final scaffold = Scaffold.of(context);
  //   scaffold.showSnackBar(
  //     SnackBar(
  //       content: const Text('Language Changed AAJH UH UH UH JH JHJK HJ JJHJJ '),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Languages').tr(),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, k) {
          return ListTile(
            leading: Text(
              langList[k].flag,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            title: Text(
              langList[k].name,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              //print('Tapped ');
              //print(k);
              widget.context.locale = Locale(langList[k].languageCode);
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Text('Language updated to ').tr(),
                        content: Text(langList[k].name),
                        actions: [
                          FlatButton(
                            child: Text("OK").tr(),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ));
              //Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
