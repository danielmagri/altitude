import 'package:flutter/material.dart'
    show
        Align,
        Alignment,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Colors,
        Container,
        EdgeInsets,
        FontWeight,
        Navigator,
        Padding,
        RadialGradient,
        RaisedButton,
        RichText,
        RoundedRectangleBorder,
        Scaffold,
        SizedBox,
        Stack,
        StatelessWidget,
        Text,
        TextAlign,
        TextSpan,
        TextStyle,
        Widget,
        required;

class TutorialWidget extends StatelessWidget {
  TutorialWidget(
      {@required this.focusAlignment,
      @required this.focusRadius,
      @required this.textAlignment,
      @required this.text,
      this.hasNext = false});

  final Alignment focusAlignment;
  final double focusRadius;
  final Alignment textAlignment;
  final List<TextSpan> text;
  final bool hasNext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                center: focusAlignment,
                stops: [0.9, 1],
                radius: focusRadius,
              ),
            ),
          ),
          Align(
            alignment: textAlignment,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.2, fontFamily: "Montserrat"),
                  children: text,
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.92),
            child: SizedBox(
              width: 150,
              child: RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                elevation: 5.0,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  hasNext ? "próximo" : "fechar",
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
