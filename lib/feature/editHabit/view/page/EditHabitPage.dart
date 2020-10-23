import 'package:altitude/common/router/arguments/EditHabitPageArguments.dart';
import 'package:altitude/common/view/Header.dart';
import 'package:altitude/common/view/dialog/BaseTextDialog.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/core/base/BaseState.dart';
import 'package:altitude/feature/addHabit/view/widget/HabitText.dart';
import 'package:altitude/feature/addHabit/view/widget/SelectColor.dart';
import 'package:altitude/feature/addHabit/view/widget/SelectFrequency.dart';
import 'package:altitude/feature/editHabit/logic/EditHabitLogic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class EditHabitPage extends StatefulWidget {
  EditHabitPage(this.arguments);

  final EditHabitPageArguments arguments;

  @override
  _EditHabitPageState createState() => _EditHabitPageState();
}

class _EditHabitPageState extends BaseState<EditHabitPage> {
  final habitTextController = TextEditingController();

  final EditHabitLogic controller = GetIt.I.get<EditHabitLogic>();

  @override
  void initState() {
    super.initState();

    controller.setData(widget.arguments.habit);

    controller.color = widget.arguments.habit.colorCode;
    habitTextController.text = widget.arguments.habit.habit;
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<EditHabitLogic>();
    super.dispose();
  }

  void updateHabit() {
    String habitValidation =
        ValidationHandler.habitTextValidate(habitTextController.text);
    if (habitValidation != null) {
      showToast(habitValidation);
    } else if (controller.frequency == null) {
      showToast("Escolha qual será a frequência.");
    } else {
      showLoading(true);
      controller.updateHabit(habitTextController.text).then((_) {
        showLoading(false);
        Navigator.pop(context);
      }).catchError(handleError);
      showToast("O hábito foi editado!");
    }
  }

  void removeHabit() async {
    if (widget.arguments.hasCompetition) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BaseTextDialog(
              title: "Opss",
              body:
                  "É preciso sair das competições que esse hábito faz parte para poder deletá-lo.",
              action: <Widget>[
                FlatButton(
                  child: const Text("Ok", style: TextStyle(fontSize: 17)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BaseTextDialog(
              title: "Deletar",
              body:
                  "Você estava indo tão bem... Tem certeza que quer deletá-lo?",
              subBody:
                  "(Todo o progresso dele será perdido e a quilômetragem perdida)",
              action: <Widget>[
                FlatButton(
                  child: const Text("Sim", style: TextStyle(fontSize: 17)),
                  onPressed: () async {
                    showLoading(true);
                    (await controller.removeHabit()).result((data) {
                      showLoading(false);
                      Navigator.pop(context);
                      navigatePop(result: false);
                    }, (error) => handleError);
                  },
                ),
                FlatButton(
                  child: const Text("Não",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Header(
                title: "EDITAR HÁBITO",
                button: IconButton(
                    icon: Icon(Icons.delete), onPressed: removeHabit)),
            const SizedBox(height: 10),
            Observer(builder: (_) {
              return SelectColor(
                  currentColor: controller.color,
                  onSelectColor: controller.selectColor);
            }),
            const SizedBox(height: 20),
            Observer(builder: (_) {
              return HabitText(
                  color: controller.habitColor,
                  controller: habitTextController);
            }),
            Observer(builder: (_) {
              return SelectFrequency(
                  color: controller.habitColor,
                  currentFrequency: controller.frequency,
                  selectFrequency: controller.selectFrequency);
            }),
            Observer(builder: (_) {
              return Container(
                margin: const EdgeInsets.only(top: 20, bottom: 28),
                child: RaisedButton(
                  color: controller.habitColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 16.0),
                  elevation: 5.0,
                  onPressed: updateHabit,
                  child: const Text("SALVAR",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
