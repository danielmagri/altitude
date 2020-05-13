import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/router/arguments/BuyBookPageArguments.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyBookPage extends StatefulWidget {
  const BuyBookPage(this.arguments);

  final BuyBookPageArguments arguments;

  @override
  _BuyBookPageState createState() => _BuyBookPageState();
}

class _BuyBookPageState extends BaseState<BuyBookPage> {
  void buyBook() async {
    FireAnalytics().sendBuyButtonClicked();
    if (await canLaunch(BUY_BOOK)) {
      await launch(BUY_BOOK);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                SizedBox(width: 50, child: IconButton(icon: Icon(Icons.close, size: 20), onPressed: navigatePop))
              ]),
            ),
            Container(
              color: Colors.orange.withAlpha(100),
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(widget.arguments.book.title,
                  textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 20, top: 32),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 16, height: 1.2, fontFamily: "Montserrat"),
                    children: widget.arguments.book.body),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(child: Image.asset("assets/o_poder_do_habito.jpg")),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: double.maxFinite,
                    child: RaisedButton(
                      color: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      onPressed: buyBook,
                      child: Text("Compre agora",
                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
