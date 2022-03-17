import 'package:flutter/material.dart'
    show
        BackButton,
        Container,
        EdgeInsets,
        Expanded,
        FontWeight,
        Key,
        Row,
        SizedBox,
        StatelessWidget,
        Text,
        TextStyle,
        Widget;
import 'package:flutter/widgets.dart';

class Header extends StatelessWidget {
  const Header({Key? key, this.title, this.button}) : super(key: key);

  final String? title;
  final Widget? button;

  @override
  Widget build(context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Row(
        children: [
          const SizedBox(width: 50, child: BackButton()),
          Expanded(
              child: Text(title!,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          SizedBox(width: 50, child: button),
        ],
      ),
    );
  }
}
