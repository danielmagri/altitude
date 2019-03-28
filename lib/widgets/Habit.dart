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
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Color.fromARGB(255, 250, 127, 114),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3.0,
                    spreadRadius: 1.0,
                  )
                ],
              ),
              child: Icon(
                Icons.fitness_center,
                size: 42.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "Academia",
                style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
