import 'package:flutter/material.dart';
import 'package:habit/utils/Color.dart';

class ColorWidget extends StatelessWidget {
  ColorWidget({Key key, this.currentColor, this.changeColor}) : super(key: key);

  final int currentColor;
  final Function changeColor;

  List<Widget> _colorsWidgets() {
    List<Widget> widgets = new List();

    for (int i = 0; i < HabitColors.colors.length; i++) {
      widgets.add(InkWell(
        onTap: () => changeColor(i),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: HabitColors.colors[i],
            shape: BoxShape.circle,
            border: i == currentColor ? Border.all(color: Colors.black, width: 2) : null,
            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))],
          ),
        ),
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 12,
      spacing: 12,
      children: _colorsWidgets(),
    );
  }
}
