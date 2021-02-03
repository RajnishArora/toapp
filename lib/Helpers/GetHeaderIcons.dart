import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetHeaderIcon {
//  GetHeaderIcon(this.optionsPassed);
//  final String optionsPassed;

  FaIcon getMenuIcon(String optionsPassed) {
    optionsPassed = optionsPassed.toLowerCase();
    switch (optionsPassed) {
      case 'home':
        return FaIcon(FontAwesomeIcons.home);
        break;
      case 'birthday-cake':
        return FaIcon(FontAwesomeIcons.birthdayCake);
        break;
      default:
        break;
    }
    return FaIcon(FontAwesomeIcons.question);
  }

  FaIcon getHeaderIcon(String optionsPassed) {
    //String returnStr = "";
    switch (optionsPassed) {
      case 'lmenu':
        return FaIcon(FontAwesomeIcons.bars);
        break;
      case 'rmenu':
        return FaIcon(FontAwesomeIcons.ellipsisV);
        break;
      case 'lhome':
        return FaIcon(FontAwesomeIcons.home);
        break;
      case 'rhome':
        return FaIcon(FontAwesomeIcons.home);
        break;
      case 'lback':
        return FaIcon(FontAwesomeIcons.arrowLeft);
        break;
      case 'lcart':
        return FaIcon(FontAwesomeIcons.shoppingCart);
        break;
      case 'rcart':
        return FaIcon(FontAwesomeIcons.shoppingCart);
        break;
      case 'lsearch':
        return FaIcon(FontAwesomeIcons.search);
        break;
      case 'rsearch':
        return FaIcon(FontAwesomeIcons.search);
        break;
      case 'rreload':
        return FaIcon(FontAwesomeIcons.redo);
        break;
      case 'rshare':
        return FaIcon(FontAwesomeIcons.shareAlt);
        break;
      case 'lnothing':
        return FaIcon(FontAwesomeIcons.question);
        break;
      default:
        break;
    }
    return FaIcon(FontAwesomeIcons.question);
  }
}
