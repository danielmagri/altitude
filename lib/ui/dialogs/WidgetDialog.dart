import 'package:flutter/material.dart';

class WidgetDialog extends StatelessWidget {
  WidgetDialog({Key key, this.title, this.body, this.action}) : super(key: key);

  final String title;
  final String body;
  final List<Widget> action;

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                body,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w300, height: 1.1),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: action,
              )
            ],
          ),
        ),
      ),
    );
  }
}
