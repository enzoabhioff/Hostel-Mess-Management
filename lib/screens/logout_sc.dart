import 'package:flutter/material.dart';

class LogoutHandler {
  static void logout(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
