import 'package:flutter/material.dart';
import 'package:habit/utils/Color.dart';

class ColorWidget extends StatelessWidget {
  ColorWidget({Key key, this.currentColor, this.changeColor}) : super(key: key);

  final int currentColor;
  final Function changeColor;

  List<Widget> _colorsWidgets() {
    List<Widget> widgets = new List();

    for (int i = 0; i < AppColors.habitsColor.length; i++) {
      widgets.add(InkWell(
        onTap: () => changeColor(i),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: i == currentColor ? 45 : 30,
          height: i == currentColor ? 45 : 30,
          decoration: BoxDecoration(
            color: AppColors.habitsColor[i],
            shape: BoxShape.circle,
            border: i == currentColor ? Border.all(color: Colors.white, width: 2) : null,
            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))],
          ),
        ),
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Wrap(
        runSpacing: 12,
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: _colorsWidgets(),
      ),
    );
  }
}
