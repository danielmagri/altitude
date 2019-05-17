import 'package:flutter/material.dart';

class TutorialDialog extends StatelessWidget {
  final String title;
  final List<String> texts;

  TutorialDialog({
    @required this.title,
    @required this.texts,
  });

  List<Widget> textWidget() {
    List<Widget> widgets = new List();

    for (String text in texts) {
      widgets.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 3.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 16.0, height: 1.2),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: textWidget(),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Ok"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
