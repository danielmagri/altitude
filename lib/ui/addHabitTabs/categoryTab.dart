import 'package:flutter/material.dart';
import 'package:habit/utils/enums.dart';
import 'package:habit/utils/Color.dart';

class CategoryTab extends StatelessWidget {
  CategoryTab({Key key, this.onCategoryTap}) : super(key: key);

  final Function onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
              child: Text(
            "Qual categoria se encaixa no seu hábito?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, height: 1.3),
          )),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onCategoryTap(Category.PHYSICAL);
            },
            child: Container(
              decoration: BoxDecoration(
                color: CategoryColors.physicalPrimary,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Align(
                          alignment: Alignment(-0.7, -0.2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Nome",
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ))),
                  Expanded(
                      child: Align(
                          alignment: Alignment(-1.0, -1.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Descrição",
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                            ),
                          ))),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onCategoryTap(Category.MENTAL);
            },
            child: Container(
              decoration: BoxDecoration(
                color: CategoryColors.mentalPrimary,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Align(
                          alignment: Alignment(-0.7, -0.2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Nome",
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ))),
                  Expanded(
                      child: Align(
                          alignment: Alignment(-1.0, -1.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Descrição",
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                            ),
                          ))),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onCategoryTap(Category.SOCIAL);
            },
            child: Container(
              decoration: BoxDecoration(
                color: CategoryColors.socialPrimary,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Align(
                          alignment: Alignment(-0.7, -0.2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Nome",
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ))),
                  Expanded(
                      child: Align(
                          alignment: Alignment(-1.0, -1.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Descrição",
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                            ),
                          ))),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
