import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/view/generic/BottomSheetLine.dart';
import 'package:altitude/core/bloc/BlocProvider.dart';
import 'package:altitude/core/bloc/BlocWidget.dart';
import 'package:altitude/feature/habitDetails/blocs/EditCueBloc.dart';
import 'package:flutter/material.dart';

class EditCueDialog extends BlocWidget<EditCueBloc> {
  static StatefulWidget instance(Habit habit, Function(String) callback) {
    return BlocProvider<EditCueBloc>(
      blocCreator: () => EditCueBloc(habit, callback),
      widget: EditCueDialog(),
    );
  }

  List<TextSpan> _texts(EditCueBloc bloc, bool showAll) {
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
          recognizer: bloc.tapGestureRecognizer,
          style: TextStyle(color: Colors.black, fontSize: 18.0, decoration: TextDecoration.underline),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context, EditCueBloc bloc) {
    return SingleChildScrollView(
      controller: bloc.scrollController,
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Column(
        children: <Widget>[
          BottomSheetLine(),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            height: 30,
            child: Text(
              "Gatilho",
              style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold, color: bloc.habitColor),
            ),
          ),
          StreamBuilder<bool>(
              initialData: false,
              stream: bloc.cueTextShowStream,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: _texts(bloc, snapshot.data),
                  ),
                );
              }),
          Container(
            height: (MediaQuery.of(context).size.height * 0.8) - 140,
            width: double.maxFinite,
            child: Column(
              children: <Widget>[
                Spacer(),
                TextField(
                  controller: bloc.textEditingController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (text) => bloc.saveCue(context),
                  onChanged: bloc.onTextChanged,
                  minLines: 1,
                  maxLines: 2,
                  style: TextStyle(fontSize: 19),
                  cursorColor: bloc.habitColor,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: bloc.habitColor)),
                      hintText: "Escreva aqui seu gatilho",
                      hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                ),
                StreamBuilder<List<String>>(
                    initialData: [],
                    stream: bloc.suggestionListStream,
                    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: snapshot.data.length != 0 ? EdgeInsets.only(top: 12, bottom: 8) : EdgeInsets.all(0),
                        itemCount: snapshot.data.length < 3 ? snapshot.data.length : 3,
                        itemBuilder: (context, position) {
                          return GestureDetector(
                            onTap: () {
                              String text = snapshot.data[position];

                              bloc.textEditingController.value = new TextEditingValue(text: text);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                snapshot.data[position],
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    bloc.habit.cue.isNotEmpty
                        ? FlatButton(
                            onPressed: () => bloc.removeCue(context),
                            child: Text(
                              "Remover",
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                            ),
                          )
                        : SizedBox(),
                    FlatButton(
                      onPressed: () => bloc.saveCue(context),
                      child: Text(
                        "Salvar",
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: bloc.habitColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
