import 'dart:ui' show ImageFilter;
import 'package:altitude/common/theme/app_theme.dart';
import 'package:flutter/material.dart'
    show
        Align,
        Alignment,
        BackdropFilter,
        BorderRadius,
        BouncingScrollPhysics,
        BoxDecoration,
        BoxShadow,
        Center,
        Colors,
        Column,
        Container,
        EdgeInsets,
        Flexible,
        Hero,
        Icon,
        IconData,
        Icons,
        MainAxisSize,
        Material,
        Navigator,
        Offset,
        SingleChildScrollView,
        SizedBox,
        StatelessWidget,
        Text,
        TextAlign,
        TextButton,
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
  Widget build(context) {
    return Material(
      color: Colors.black54,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
            decoration: BoxDecoration(
              color: AppTheme.of(context).materialTheme.cardColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: const Offset(0.0, 10.0)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: const Alignment(0.0, 0.0),
                  height: 50,
                  child: Hero(tag: hero, child: Icon(icon, size: 42)),
                ),
                const SizedBox(height: 24.0),
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text.rich(
                      TextSpan(style: const TextStyle(fontSize: 18, height: 1.2), children: texts),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok", style: const TextStyle(fontSize: 18.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
