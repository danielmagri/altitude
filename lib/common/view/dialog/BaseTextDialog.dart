import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        BoxShadow,
        Center,
        Colors,
        Column,
        Container,
        EdgeInsets,
        FontWeight,
        Key,
        MainAxisAlignment,
        MainAxisSize,
        Material,
        Offset,
        Row,
        SizedBox,
        StatelessWidget,
        Text,
        TextAlign,
        TextStyle,
        Widget,
        required;

class BaseTextDialog extends StatelessWidget {
  BaseTextDialog({Key key, @required this.title, @required this.body, this.subBody, @required this.action})
      : super(key: key);

  final String title;
  final String body;
  final String subBody;
  final List<Widget> action;

  Widget build(_) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            const BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: const Offset(0.0, 10.0)),
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
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text(
                body,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, height: 1.1),
              ),
              const SizedBox(height: 4),
              subBody != null
                  ? Text(
                      subBody,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300, height: 1.1),
                    )
                  : SizedBox(),
              const SizedBox(height: 18),
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
