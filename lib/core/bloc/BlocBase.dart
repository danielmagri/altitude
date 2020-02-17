import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class BlocBase {

  void initialize() {}
  void dispose();

  @protected
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

  @protected
  Future<T> navigatePushToPage<T>(BuildContext context, Widget page, [String name = ""]) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return page;
        },
        settings: RouteSettings(name: name)));
  }
}
