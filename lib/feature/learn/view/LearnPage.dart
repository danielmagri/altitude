import 'package:altitude/common/constant/Books.dart';
import 'package:altitude/common/model/Book.dart';
import 'package:altitude/common/router/arguments/LearnDetailPageArguments.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/common/view/Header.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:flutter/material.dart';

class LearnPage extends StatefulWidget {
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends BaseState<LearnPage> {
  @override
  void initState() {
    SharedPref.instance.pendingLearn = BOOKS.length;
    super.initState();
  }

  void goLearnDetail(int index) {
    LearnDetailPageArguments arguments = LearnDetailPageArguments(index);
    navigatePush('learnDetail', arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const Header(title: "Altitude Learn"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
              child: Text(
                  "Aqui você vai entender como funcionam seus hábitos e como eles podem melhorar e mudar a sua vida de vez!",
                  textAlign: TextAlign.center),
            ),
            Container(height: 1, width: double.maxFinite, decoration: const BoxDecoration(color: Colors.black12)),
            ListView.separated(
              separatorBuilder: (_, index) {
                return Container(
                    height: 1, width: double.maxFinite, decoration: const BoxDecoration(color: Colors.black12));
              },
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: BOOKS.length,
              itemBuilder: (_, index) {
                Book book = BOOKS[index];
                return InkWell(
                  onTap: () => goLearnDetail(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: <Widget>[
                        Image.asset(book.mainImage, width: 65, height: 65),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            book.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(height: 1, width: double.maxFinite, decoration: const BoxDecoration(color: Colors.black12))
          ],
        ),
      ),
    );
  }
}
