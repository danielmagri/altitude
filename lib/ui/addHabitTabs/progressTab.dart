import 'package:flutter/material.dart';
import 'package:habit/objects/Progress.dart';
import 'package:habit/utils/enums.dart';
import 'package:habit/utils/Color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit/utils/Validator.dart';

class ProgressTab extends StatefulWidget {
  ProgressTab({Key key, this.category, this.onTap}) : super(key: key);

  final CategoryEnum category;
  final Function onTap;

  @override
  _ProgressTabState createState() => new _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  final numberController = TextEditingController();
  final dayController = TextEditingController();

  List<bool> expandList = [true, false, false];
  int expanded = 0;

  @override
  void dispose() {
    numberController.dispose();
    dayController.dispose();
    super.dispose();
  }

  void validateData() {
    if (expanded == 0) {
      String result = Validate.progressTextValidate(numberController.text);

      if (result == null) {
        Progress progress =
            new Progress(type: ProgressEnum.NUMBER, goal: int.tryParse(numberController.text), progress: 0);

        widget.onTap(true, progress);
      } else {
        Fluttertoast.showToast(
            msg: result,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Color.fromARGB(255, 220, 220, 220),
            textColor: Colors.black,
            fontSize: 16.0);
      }
    } else if (expanded == 1) {
      String result = Validate.progressTextValidate(dayController.text);

      if (result == null) {
        Progress progress = new Progress(type: ProgressEnum.DAY, goal: int.tryParse(dayController.text), progress: 0);

        widget.onTap(true, progress);
      } else {
        Fluttertoast.showToast(
            msg: result,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Color.fromARGB(255, 220, 220, 220),
            textColor: Colors.black,
            fontSize: 16.0);
      }
    } else if (expanded == 2) {
      Progress progress = new Progress(type: ProgressEnum.INFINITY, goal: 0, progress: 0);

      widget.onTap(true, progress);
    } else {
      Fluttertoast.showToast(
          msg: "Por favor, escolha alguma das opções",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color.fromARGB(255, 220, 220, 220),
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 50.0),
            child: new ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                if (!isExpanded) {
                  if (expanded != -1) expandList[expanded] = false;
                  expanded = index;
                } else {
                  if (expanded != -1) expandList[expanded] = false;
                  expanded = -1;
                }

                setState(() {
                  expandList[index] = !isExpanded;
                });
              },
              children: <ExpansionPanel>[
                new ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: const Text(
                        "Por um número",
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: const Text(
                        "Quantos kg perdeu, distancia percorrida...",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  isExpanded: expandList[0],
                  body: new Container(
                    height: 70.0,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Ao atingir qual valor sua meta será cumprida?",
                          style: TextStyle(color: Colors.black),
                        ),
                        Container(
                          width: 30,
                          child: TextField(
                            controller: numberController,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            textInputAction: TextInputAction.go,
                            onEditingComplete: validateData,
                            decoration: InputDecoration(
                              counterText: "",
                            ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: const Text(
                        "Por dias feito",
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: const Text(
                        "Realizar 30 vezes esse hábito...",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  isExpanded: expandList[1],
                  body: new Container(
                    height: 70.0,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Realizar o hábito por ",
                          style: TextStyle(color: Colors.black),
                        ),
                        Container(
                          width: 30,
                          child: TextField(
                            controller: dayController,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            textInputAction: TextInputAction.go,
                            onEditingComplete: validateData,
                            decoration: InputDecoration(
                              counterText: "",
                            ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          " dias para cumprí-la",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                new ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: const Text(
                        "Sem progresso",
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  isExpanded: expandList[2],
                  body: new Container(
                    height: 70.0,
                    child: Center(
                      child: Text(
                        "O seu hábito não tem uma meta",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  color: CategoryColors.getSecundaryColor(widget.category),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  elevation: 5.0,
                  onPressed: () {
                    widget.onTap(false, null);
                  },
                  child: const Text("VOLTAR"),
                ),
                RaisedButton(
                  color: CategoryColors.getSecundaryColor(widget.category),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  elevation: 5.0,
                  onPressed: validateData,
                  child: const Text("AVANÇAR"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
