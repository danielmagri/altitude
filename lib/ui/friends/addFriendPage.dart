import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/view/generic/Loading.dart';
import 'package:altitude/common/view/generic/Toast.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:altitude/controllers/UserControl.dart';
import 'package:altitude/utils/Color.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  List<Person> persons = [];

  TextEditingController _controller = new TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String buttonText(int state) {
    if (state == 0) {
      return "Adicionar";
    } else if (state == 2) {
      return "Cancelar\nsolicitação";
    } else if (state == 3) {
      return "Aceitar\nsolicitação";
    }
    return "";
  }

  void onClickButton(Person person) {
    Loading.showLoading(context);
    if (person.state == 0) {
      UserControl().friendRequest(person.uid).then((_) {
        Loading.closeLoading(context);
        showToast("Pedido de amizade enviado.");
        Navigator.of(context).pop();
      }).catchError((error) {
        Loading.closeLoading(context);
        if (error is CloudFunctionsException) {
          if (error.details == true) {
            showToast(error.message);
            return;
          }
        }
        showToast("Ocorreu um erro");
      });
    } else if (person.state == 2) {
      Loading.showLoading(context);
      UserControl().cancelFriendRequest(person.uid).then((_) {
        Loading.closeLoading(context);
        Navigator.of(context).pop();
      }).catchError((error) {
        Loading.closeLoading(context);
        if (error is CloudFunctionsException) {
          if (error.details == true) {
            showToast(error.message);
            return;
          }
        }
        showToast("Ocorreu um erro");
      });
    } else if (person.state == 3) {
      Loading.showLoading(context);
      UserControl().acceptRequest(person.uid).then((_) {
        Loading.closeLoading(context);
        Navigator.of(context).pop(person);
      }).catchError((error) {
        Loading.closeLoading(context);
        if (error is CloudFunctionsException) {
          if (error.details == true) {
            showToast(error.message);
            return;
          }
        }
        showToast("Ocorreu um erro");
      });
    }
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  void search() {
    if (!isEmail(_controller.text)) {
      showToast("Email inválido.");
    } else {
      Loading.showLoading(context);
      UserControl().searchEmail(_controller.text).then((friends) async {
        Loading.closeLoading(context);
        if (friends.length == 0) {
          showToast("Esse email não foi encontrado.");
        } else {
          setState(() {
            persons = friends;
          });
        }
      }).catchError((_) {
        Loading.closeLoading(context);
        showToast("Ocorreu um erro");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          Center(
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: new BoxDecoration(
                color: Colors.white,
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
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.go,
                    minLines: 1,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.colorHabitMix)),
                        hintText: "Escreva o email do seu amigo",
                        hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 200,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: persons.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Container(
                          width: double.maxFinite,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      persons[index].name != null ? persons[index].name : "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        decoration: persons[index].you
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      persons[index].email != null ? persons[index].email : "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 4),
                              persons[index].state == 1
                                  ? Container()
                                  : RaisedButton(
                                      color: Colors.black,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(20.0)),
                                      padding: const EdgeInsets.all(10),
                                      elevation: 0,
                                      onPressed: () => onClickButton(persons[index]),
                                      child: Text(
                                        buttonText(persons[index].state),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  RaisedButton(
                    color: Colors.black,
                    shape:
                        new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    elevation: 5.0,
                    onPressed: search,
                    child: Text(
                      "Buscar",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
