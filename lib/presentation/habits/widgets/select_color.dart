import 'package:altitude/common/constant/app_colors.dart';
import 'package:flutter/material.dart'
    show
        AnimatedContainer,
        Border,
        BorderRadius,
        BoxDecoration,
        BoxShadow,
        Colors,
        EdgeInsets,
        GestureDetector,
        Key,
        SizedBox,
        StatelessWidget,
        Widget,
        Wrap,
        WrapAlignment,
        WrapCrossAlignment;

class SelectColor extends StatelessWidget {
  const SelectColor({Key? key, this.currentColor, this.onSelectColor})
      : super(key: key);

  final int? currentColor;
  final Function(int index)? onSelectColor;

  @override
  Widget build(context) {
    return SizedBox(
      height: 45,
      child: Wrap(
        runSpacing: 12,
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: AppColors.habitsColor
            .asMap()
            .keys
            .map(
              (index) => GestureDetector(
                onTap: () => onSelectColor!(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  margin:
                      EdgeInsets.only(bottom: index == currentColor ? 10 : 0),
                  decoration: BoxDecoration(
                    color: AppColors.habitsColor[index],
                    borderRadius: BorderRadius.circular(13),
                    border: index == currentColor
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                    boxShadow: const [
                      BoxShadow(blurRadius: 5, color: Colors.black38)
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
