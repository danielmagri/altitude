import 'package:flutter/material.dart';
import 'package:habit/objects/Progress.dart';
import 'package:habit/utils/enums.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomDialog extends StatelessWidget {
  final Progress progress;
  final TextEditingController controller;

  CustomDialog({
    @required this.progress,
    @required this.controller,
  });

  void validate(BuildContext context) {
    if (progress.type == ProgressEnum.NUMBER) {
      int number = int.tryParse(controller.text);
      if (number == null) {
        Navigator.of(context).pop(null);
      } else if (number < 0) {
        Fluttertoast.showToast(
            msg: "O número precisa ser maior que 0.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Color.fromARGB(255, 220, 220, 220),
            textColor: Colors.black,
            fontSize: 16.0);
      } else {
        Navigator.of(context).pop(number);
      }
    } else {
      Navigator.of(context).pop(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 82.0,
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            margin: EdgeInsets.only(top: 66.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  "Sucesso",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                progress.type == ProgressEnum.NUMBER
                    ? new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Qual é seu progresso? ",
                            style: TextStyle(color: Colors.black),
                          ),
                          Container(
                            width: 30,
                            child: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              textAlign: TextAlign.center,
                              textInputAction: TextInputAction.go,
                              onEditingComplete: () => validate(context),
                              decoration: InputDecoration(
                                counterText: "",
                              ),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: () {
                      validate(context);
                    },
                    child: Text("Ok"),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16.0,
            right: 16.0,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.check,
                size: 100,
                color: Colors.white,
              ),
              radius: 66.0,
            ),
          ),
        ],
      ),
    );
  }
}
