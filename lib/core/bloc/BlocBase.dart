import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class BlocBase {
  TickerProvider tickerProvider;

  void initialize() {}
  void dispose();

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Color.fromARGB(255, 220, 220, 220),
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
