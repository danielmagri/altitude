import 'package:flutter/material.dart';

class HabitWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
//        Navigator.push(context, MaterialPageRoute(builder: (_) {
//          return HabitDetailsPage();
//        }));
      },
      child: Container(
        height: 100.0,
        width: 100.0,
        child: Column(
          children: <Widget>[
            Container(
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.red,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3.0,
                    spreadRadius: 1.0,
                    offset: new Offset(1.0, 1.0),
                  )
                ],
              ),
              child: Icon(
                Icons.fitness_center,
                size: 42.0,
              ),
            ),
            Text(
              "Academia",
              style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}