import 'package:flutter/material.dart';
import 'package:habit/utils/enums.dart';

class CategoryTab extends StatelessWidget {
  CategoryTab({Key key, this.onCategoryTap}) : super(key: key);

  final Function onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
              margin: EdgeInsets.only(top: 60.0, left: 8.0),
              child: Text(
                "Qual categoria se encaixa no seu hábito?",
                style: TextStyle(fontSize: 28.0, color: Colors.black, fontWeight: FontWeight.w300),
              )),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/category/fisico.png'), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: <BoxShadow>[BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.5))],
            ),
            child: new Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(30.0),
                onTap: () {
                  onCategoryTap(CategoryEnum.PHYSICAL);
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                            alignment: Alignment(-0.9, -0.4),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Físico",
                                style: TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ))),
                    Expanded(
                        child: Align(
                            alignment: Alignment(-1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                              ),
                            ))),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/category/mental.png'), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: <BoxShadow>[BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.5))],
            ),
            child: new Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(30.0),
                onTap: () {
                  onCategoryTap(CategoryEnum.MENTAL);
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                            alignment: Alignment(-0.9, -0.4),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Mental",
                                style: TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ))),
                    Expanded(
                        child: Align(
                            alignment: Alignment(-1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                              ),
                            ))),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/category/social.png'), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: <BoxShadow>[BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.5))],
            ),
            child: new Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(30.0),
                onTap: () {
                  onCategoryTap(CategoryEnum.SOCIAL);
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Align(
                            alignment: Alignment(-0.9, -0.4),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Social",
                                style: TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ))),
                    Expanded(
                        child: Align(
                            alignment: Alignment(-1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                              ),
                            ))),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
