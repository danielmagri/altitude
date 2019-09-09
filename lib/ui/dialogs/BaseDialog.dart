import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  BaseDialog({Key key, this.title, this.body, this.subBody, this.action}) : super(key: key);

  final String title;
  final String body;
  final String subBody;
  final List<Widget> action;

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
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
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                body,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18, height: 1.1),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                subBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w300, height: 1.1),
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
