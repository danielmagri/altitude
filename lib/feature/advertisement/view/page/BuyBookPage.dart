import 'package:flutter/material.dart';

class BuyBookPage extends StatefulWidget {
  @override
  _BuyBookPageState createState() => _BuyBookPageState();
}

class _BuyBookPageState extends State<BuyBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 40, bottom: 16),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 50, child: const BackButton()),
                  const Spacer(),
                  Text(
                    "O Poder do hábito",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
