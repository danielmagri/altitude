import 'package:flutter/material.dart'
    show
        BackButton,
        Container,
        EdgeInsets,
        FontWeight,
        Key,
        Row,
        SizedBox,
        Spacer,
        StatelessWidget,
        Text,
        TextStyle,
        Widget;

class Header extends StatelessWidget {
  const Header({Key key, this.title, this.button}) : super(key: key);

  final String title;
  final Widget button;

  @override
  Widget build(context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Row(
        children: [
          const SizedBox(width: 50, child: BackButton()),
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          SizedBox(width: 50, child: button),
        ],
      ),
    );
  }
}
