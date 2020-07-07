import 'package:altitude/common/router/arguments/LearnDetailPageArguments.dart';
import 'package:altitude/common/view/Header.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnDetailPage extends StatefulWidget {
  const LearnDetailPage(this.arguments);

  final LearnDetailPageArguments arguments;

  @override
  _LearnDetailPageState createState() => _LearnDetailPageState();
}

class _LearnDetailPageState extends State<LearnDetailPage> {
  void buyBook() async {
    FireAnalytics().sendGenerateLead();
    if (await canLaunch(widget.arguments.book.link)) {
      await launch(widget.arguments.book.link);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Header(title: widget.arguments.book.title),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 32),
              alignment: AlignmentDirectional.centerStart,
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.25, fontFamily: "Montserrat"),
                    children: [
                      TextSpan(text: "Estimativa de leitura - ", style: const TextStyle(fontWeight: FontWeight.w300)),
                      TextSpan(text: "${widget.arguments.book.readTime} min"),
                    ]),
              ),
            ),
            Column(children: widget.arguments.book.body),
            Row(
              children: <Widget>[
                Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.asset(widget.arguments.book.bookImage),
                )),
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
                          style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
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
