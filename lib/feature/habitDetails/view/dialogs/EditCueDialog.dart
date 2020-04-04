import 'package:altitude/common/view/generic/BottomSheetLine.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/feature/habitDetails/logic/EditCueLogic.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class EditCueDialog extends StatefulWidget {
  const EditCueDialog();

  @override
  _EditCueDialogState createState() => _EditCueDialogState();
}

class _EditCueDialogState extends BaseState<EditCueDialog> {
  KeyboardVisibilityNotification keyboardVisibilityNotification = KeyboardVisibilityNotification();
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();

  EditCueLogic controller = GetIt.I.get<EditCueLogic>();

  @override
  void initState() {
    super.initState();
    // Seta o gatilho no textField
    textEditingController.text = controller.cue;

    keyboardVisibilityNotification.addNewListener(onChange: (bool visible) {
      if (visible)
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });

    // Ao clicar em "Saiba mais"
    tapGestureRecognizer.onTap = controller.showAllCueText;
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<EditCueLogic>();
    keyboardVisibilityNotification.dispose();
    scrollController.dispose();
    textEditingController.dispose();
    tapGestureRecognizer.dispose();
    super.dispose();
  }

  void onTextChanged(String text) {
    controller.fetchSuggestions(text);
  }

  void save() {
    String validate = ValidationHandler.cueTextValidate(textEditingController.text);

    if (validate == null) {
      showLoading(true);
      controller.saveCue(textEditingController.text).then((_) {
        showLoading(false);
      }).catchError(handleError);
    } else {
      showToast(validate);
    }
  }

  void remove() {
    showLoading(true);
    controller.removeCue().then((_) {
      showLoading(false);
    }).catchError(handleError);
  }

  List<TextSpan> _texts(bool showAll) {
    if (showAll) {
      return [
        TextSpan(
          text: "Todo hábito precisa de um \"gatilho\" para que ele se inicie. Mas o que seria esse gatilho?",
          style: TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w300),
        ),
        TextSpan(
          text: "\n  O gatilho é uma ação que estímula seu cérebro a realizar o hábito.",
          style: TextStyle(color: Colors.black, fontSize: 17.0, height: 1.2),
        ),
        TextSpan(
          text:
              " Por exemplo ao deixar sua roupa de corrida do lado da cama pode ser uma boa forma de iniciar seu hábito de correr de manhã.",
          style: TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w300),
        ),
        TextSpan(
          text:
              "\n\n  Qual seria um gatilho (ação) a ser tomado para que você realize seu hábito? Escreva ela para nós e te lembraremos de faze-la todas as vezes!",
          style: TextStyle(color: Colors.black, fontSize: 17.0),
        ),
      ];
    } else {
      return [
        TextSpan(
          text: "Todo hábito precisa de um \"gatilho\" para que ele se inicie. Mas o que seria esse gatilho? ",
          style: TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w300),
        ),
        TextSpan(
          text: "Continuar lendo...",
          recognizer: tapGestureRecognizer,
          style: TextStyle(color: Colors.black, fontSize: 18.0, decoration: TextDecoration.underline),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Column(
        children: <Widget>[
          const BottomSheetLine(),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            height: 30,
            child: Text(
              "Gatilho",
              style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold, color: controller.habitColor),
            ),
          ),
          Observer(builder: (_) {
            return RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(children: _texts(controller.showAllTutorialText)),
            );
          }),
          Container(
            height: (MediaQuery.of(context).size.height * 0.8) - 140,
            width: double.maxFinite,
            child: Column(
              children: <Widget>[
                const Spacer(),
                TextField(
                  controller: textEditingController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (text) => save(),
                  onChanged: onTextChanged,
                  minLines: 1,
                  maxLines: 2,
                  style: TextStyle(fontSize: 19),
                  cursorColor: controller.habitColor,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: controller.habitColor)),
                      hintText: "Escreva aqui seu gatilho",
                      hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                ),
                Observer(builder: (_) {
                  var suggestions = controller.suggestions;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding:
                        suggestions.isNotEmpty ? const EdgeInsets.only(top: 12, bottom: 8) : const EdgeInsets.all(0),
                    itemCount: suggestions.length < 3 ? suggestions.length : 3,
                    itemBuilder: (context, position) {
                      return GestureDetector(
                        onTap: () {
                          String text = suggestions[position];
                          textEditingController.value = new TextEditingValue(text: text);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            suggestions[position],
                            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                          ),
                        ),
                      );
                    },
                  );
                }),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    controller.cue.isNotEmpty
                        ? FlatButton(
                            onPressed: remove,
                            child: Text("Remover", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300)),
                          )
                        : SizedBox(),
                    FlatButton(
                      onPressed: save,
                      child: Text(
                        "Salvar",
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: controller.habitColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
