import 'package:youtubedarker/models/common/colors.dart';
import 'package:flutter/material.dart';

class WidgetService {
  static void screenPopper(BuildContext context) {
    Navigator.pop(
      context,
    );
  }

  static void showSnackbar(String content, GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(right: 20.0, bottom: 10.0, left: 20.0),
        content: Text(
          content,
          style: TextStyle(fontSize: 16.0, color: textColor),
        ),
        backgroundColor: lightBackgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showConnectionSnackbar(String content, GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(right: 20.0, bottom: 5.0, left: 20.0),
        content: Text(
          content,
          style: TextStyle(fontSize: 16.0, color: textColor),
        ),
        backgroundColor: lightBackgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: Duration(days: 9999),
      ),
    );
  }

  static void hideSnackbar(GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState.removeCurrentSnackBar();
  }
}
