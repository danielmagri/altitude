import 'package:flutter/material.dart'
    show
        Align,
        Alignment,
        BorderRadius,
        BouncingScrollPhysics,
        BoxDecoration,
        BoxShadow,
        BuildContext,
        Center,
        Colors,
        Column,
        Container,
        EdgeInsets,
        FlatButton,
        Flexible,
        GestureDetector,
        Hero,
        Icon,
        IconData,
        Icons,
        MainAxisSize,
        Navigator,
        Offset,
        RichText,
        Scaffold,
        SingleChildScrollView,
        SizedBox,
        Stack,
        StatelessWidget,
        Text,
        TextAlign,
        TextSpan,
        TextStyle,
        Widget,
        required;

class TutorialDialog extends StatelessWidget {
  TutorialDialog({@required this.texts, @required this.hero, this.icon = Icons.help_outline});

  final String hero;
  final List<TextSpan> texts;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  const BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: const Offset(0.0, 10.0)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    alignment: Alignment(0.0, 0.0),
                    height: 50,
                    child: Hero(tag: hero, child: Icon(icon, size: 42)),
                  ),
                  const SizedBox(height: 24.0),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18, height: 1.2, fontFamily: "Montserrat"),
                            children: texts),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Ok", style: const TextStyle(fontSize: 18.0, color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
