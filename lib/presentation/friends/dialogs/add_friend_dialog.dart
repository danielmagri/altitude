import 'dart:ui' show ImageFilter;
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/generic/focus_fixer.dart';
import 'package:altitude/common/inputs/validations/ValidationHandler.dart';
import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/presentation/friends/controllers/add_friend_controller.dart';
import 'package:flutter/material.dart'
    show
        AlwaysStoppedAnimation,
        BackdropFilter,
        BorderRadius,
        BorderSide,
        BouncingScrollPhysics,
        BoxDecoration,
        BoxShadow,
        ButtonStyle,
        Center,
        CircularProgressIndicator,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        ElevatedButton,
        Expanded,
        FontWeight,
        InputDecoration,
        ListView,
        MainAxisAlignment,
        MainAxisSize,
        Material,
        MaterialStateProperty,
        Navigator,
        Offset,
        RoundedRectangleBorder,
        Row,
        SizedBox,
        StatefulWidget,
        Text,
        TextAlign,
        TextButton,
        TextDecoration,
        TextEditingController,
        TextField,
        TextInputAction,
        TextInputType,
        TextOverflow,
        TextStyle,
        UnderlineInputBorder,
        Widget;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class AddFriendDialog extends StatefulWidget {
  @override
  _AddFriendDialogState createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends BaseState<AddFriendDialog> {
  AddFriendController controller = GetIt.I.get<AddFriendController>();

  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    GetIt.I.resetLazySingleton<AddFriendController>();
    super.dispose();
  }

  String buttonText(int? state) {
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
      controller.sendFriendRequest(person.uid!).then((_) {
        showLoading(false);
        showToast("Pedido de amizade enviado.");
        Navigator.of(context).pop();
      }).catchError(handleError);
    } else if (person.state == 2) {
      showLoading(true);
      controller.cancelFriendRequest(person.uid!).then((_) {
        showLoading(false);
        Navigator.of(context).pop();
      }).catchError(handleError);
    } else if (person.state == 3) {
      showLoading(true);
      controller.acceptFriendRequest(person.uid!).then((_) {
        showLoading(false);
        Navigator.of(context).pop(person);
      }).catchError(handleError);
    }
  }

  void search() {
    String? result = ValidationHandler.email(_textEditingController.text);
    if (result != null) {
      showToast(result);
    } else {
      controller.searchFriend(_textEditingController.text).then((_) {
        if (controller.searchResult.data!.isEmpty)
          showToast("Esse email não foi encontrado.");
      }).catchError(handleError);
    }
  }

  @override
  Widget build(context) {
    return FocusFixer(
      child: Material(
        color: Colors.black54,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Center(
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 10),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.of(context).materialTheme.cardColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0))
                ],
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
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.of(context)
                                    .materialTheme
                                    .textTheme
                                    .headline1!
                                    .color!)),
                        hintText: "Escreva o email do seu amigo",
                        hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 200,
                    child: Observer(builder: (_) {
                      return controller.searchResult
                          .handleStateLoadableWithData(loading: (data) {
                        return Column(
                          children: <Widget>[
                            const SizedBox(height: 32),
                            CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    AppTheme.of(context).loading)),
                            const SizedBox(height: 12),
                            const Text("Buscando...")
                          ],
                        );
                      }, success: (data) {
                        if (data == null)
                          return SizedBox();
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            person.name!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              decoration: person.you!
                                                  ? TextDecoration.underline
                                                  : TextDecoration.none,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            person.email!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    person.state == 1
                                        ? Container()
                                        : ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black),
                                                shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20))),
                                                padding: MaterialStateProperty.all(
                                                    const EdgeInsets.all(10)),
                                                overlayColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white24),
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        0)),
                                            onPressed: () =>
                                                onClickButton(person),
                                            child: Text(
                                              buttonText(person.state),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            },
                          );
                      });
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        child: const Text("Cancelar",
                            style: const TextStyle(fontSize: 15)),
                        onPressed: () => navigatePop(),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10)),
                            overlayColor:
                                MaterialStateProperty.all(Colors.white24),
                            elevation: MaterialStateProperty.all(2)),
                        onPressed: search,
                        child: Text("Buscar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
