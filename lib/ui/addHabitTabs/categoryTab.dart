import 'package:flutter/material.dart';
import 'package:habit/utils/enums.dart';

class CategoryTab extends StatelessWidget {
  CategoryTab({Key key, this.onCategoryTap}) : super(key: key);

  final Function onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(0.0, -0.7),
          child: Text("Escolha uma categoria:"),
        ),
        Align(
          alignment: Alignment(0.0, 0.5),
          child: GridView.count(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            crossAxisCount: 2,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                    onCategoryTap(Category.FISICO);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        spreadRadius: 0.0,
                        blurRadius: 5.0,
                        color: Colors.black26,
                      ),
                    ],
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
              GestureDetector(
                onTap: () {
                  onCategoryTap(Category.MENTAL);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        spreadRadius: 0.0,
                        blurRadius: 5.0,
                        color: Colors.black26,
                      ),
                    ],
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
              GestureDetector(
                onTap: () {
                  onCategoryTap(Category.LOCURA);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        spreadRadius: 0.0,
                        blurRadius: 5.0,
                        color: Colors.black26,
                      ),
                    ],
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
              GestureDetector(
                onTap: () {
                  onCategoryTap(Category.DOIDERA);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        spreadRadius: 0.0,
                        blurRadius: 5.0,
                        color: Colors.black26,
                      ),
                    ],
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
            ],
          ),
        ),
      ],
    );
  }
}
