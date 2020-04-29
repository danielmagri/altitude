import 'package:flutter/material.dart'
    show
        Colors,
        Column,
        EdgeInsets,
        FontWeight,
        Key,
        MainAxisSize,
        Padding,
        SizedBox,
        StatelessWidget,
        Text,
        TextAlign,
        TextStyle,
        Widget;

class DataError extends StatelessWidget {
  const DataError({Key key, this.message = "Ocorreu um problema. Tente novamente mais tarde."}) : super(key: key);

  final String message;
  // final Function reload;

  @override
  Widget build(_) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 16),
          Text(message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.grey),
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          // OutlineButton(
          //   color: AppColors.colorAccent,
          //   highlightedBorderColor: AppColors.colorAccent,
          //   shape: const CircleBorder(),
          //   child: const Icon(Icons.replay, color: Colors.grey, size: 20),
          //   onPressed: reload,
          // ),
        ],
      ),
    );
  }
}
