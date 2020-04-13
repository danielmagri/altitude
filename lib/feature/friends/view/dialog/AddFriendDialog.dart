import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/feature/friends/logic/AddFriendLogic.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class AddFriendDialog extends StatefulWidget {
  @override
  _AddFriendDialogState createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends BaseState<AddFriendDialog> {
  AddFriendLogic controller = GetIt.I.get<AddFriendLogic>();

  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    GetIt.I.resetLazySingleton<AddFriendLogic>();
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
    if (person.state == 0) {
      showLoading(true);
      controller.sendFriendRequest(person.uid).then((_) {
        showLoading(false);
        showToast("Pedido de amizade enviado.");
        Navigator.of(context).pop();
      }).catchError(handleRequestError);
    } else if (person.state == 2) {
      showLoading(true);
      controller.cancelFriendRequest(person.uid).then((_) {
        showLoading(false);
        Navigator.of(context).pop();
      }).catchError(handleRequestError);
    } else if (person.state == 3) {
      showLoading(true);
      controller.acceptFriendRequest(person.uid).then((_) {
        showLoading(false);
        Navigator.of(context).pop(person);
      }).catchError(handleRequestError);
    }
  }

  void handleRequestError(dynamic error) {
    showLoading(false);
    if (error is CloudFunctionsException) {
      if (error.details == true) {
        showToast(error.message);
        return;
      }
    }
    showToast("Ocorreu um erro");
  }

  void search() {
    String result = ValidationHandler.email(_textEditingController.text);
    if (result != null) {
      showToast(result);
    } else {
      controller.searchFriend(_textEditingController.text).then((_) {
        if (controller.searchResult.data.isEmpty) showToast("Esse email não foi encontrado.");
      }).catchError(handleError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(color: Colors.black.withOpacity(0.2)),
          Center(
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: const Offset(0.0, 10.0))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.go,
                    minLines: 1,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.colorAccent)),
                        hintText: "Escreva o email do seu amigo",
                        hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 200,
                    child: Observer(builder: (_) {
                      return controller.searchResult.handleStateLoadable(() {
                        return const SizedBox();
                      }, (data, loading) {
                        if (loading)
                          return Column(
                            children: <Widget>[
                              const SizedBox(height: 32),
                              const CircularProgressIndicator(),
                              const SizedBox(height: 12),
                              const Text("Buscando...")
                            ],
                          );
                        else
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (_, index) {
                              Person person = data[index];
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
                                            person.name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              decoration: person.you ? TextDecoration.underline : TextDecoration.none,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            person.email,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    person.state == 1
                                        ? Container()
                                        : RaisedButton(
                                            color: Colors.black,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                            padding: const EdgeInsets.all(10),
                                            elevation: 0,
                                            onPressed: () => onClickButton(person),
                                            child: Text(
                                              buttonText(person.state),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            },
                          );
                      }, (error) {
                        return const SizedBox();
                      });
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: const Text("Cancelar", style: const TextStyle(fontSize: 17)),
                        onPressed: () => navigatePop(),
                      ),
                      RaisedButton(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        elevation: 5.0,
                        onPressed: search,
                        child: Text("Buscar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
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
