import 'package:flutter/material.dart';

class BottomSheetLine extends StatelessWidget {
  const BottomSheetLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
