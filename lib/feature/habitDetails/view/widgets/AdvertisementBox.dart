import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart'
    show
        Border,
        BorderRadius,
        BoxDecoration,
        Color,
        Column,
        Container,
        EdgeInsets,
        FlatButton,
        FontWeight,
        Key,
        RoundedRectangleBorder,
        Row,
        SizedBox,
        Spacer,
        StatelessWidget,
        Text,
        TextAlign,
        TextStyle,
        Widget,
        required;

class AdvertisementBox extends StatelessWidget {
  const AdvertisementBox(
      {Key key,
      @required this.color,
      @required this.title,
      @required this.message,
      this.buttonText = "Saiba mais",
      @required this.onTap})
      : super(key: key);

  final Color color;
  final String title;
  final String message;
  final String buttonText;
  final Function onTap;

  @override
  Widget build(context) {
    return Container(
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration:
            BoxDecoration(border: Border.all(color: AppColors.lightGrey), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(title,
                textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message),
            const SizedBox(height: 12),
            Row(children: [
              const Spacer(),
              SizedBox(
                height: 28,
                child: FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  onPressed: onTap,
                  child: Text(buttonText, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
            ]),
          ],
        ));
  }
}
