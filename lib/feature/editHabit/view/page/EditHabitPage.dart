import 'package:altitude/common/router/arguments/EditHabitPageArguments.dart';
import 'package:altitude/common/view/Header.dart';
import 'package:altitude/common/view/dialog/BaseTextDialog.dart';
import 'package:altitude/core/handler/AdsHandler.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/core/base/BaseState.dart';
import 'package:altitude/feature/addHabit/view/widget/HabitText.dart';
import 'package:altitude/feature/addHabit/view/widget/SelectColor.dart';
import 'package:altitude/feature/addHabit/view/widget/SelectFrequency.dart';
import 'package:altitude/feature/editHabit/logic/EditHabitLogic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EditHabitPage extends StatefulWidget {
  EditHabitPage(this.arguments);

  final EditHabitPageArguments arguments;

  @override
  _EditHabitPageState createState() => _EditHabitPageState();
}

class _EditHabitPageState extends BaseStateWithLogic<EditHabitPage, EditHabitLogic> {
  final habitTextController = TextEditingController();

  final InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: AdsHandler.edithabitOnSaveIntersticialAdUnitId,
    request: AdsHandler.adRequest,
    listener: AdsHandler.adListener,
  );

  @override
  void initState() {
    super.initState();
    myInterstitial.load();

    controller.setData(widget.arguments.habit);

    controller.color = widget.arguments.habit.colorCode;
    habitTextController.text = widget.arguments.habit.habit;
  }

  @override
  void dispose() {
    habitTextController.dispose();
    myInterstitial.dispose();
    super.dispose();
  }

  void updateHabit() {
    String habitValidation = ValidationHandler.habitTextValidate(habitTextController.text);
    if (habitValidation != null) {
      showToast(habitValidation);
    } else if (controller.frequency == null) {
      showToast("Escolha qual será a frequência.");
    } else {
      showLoading(true);
      controller.updateHabit(habitTextController.text).then((_) async {
        showLoading(false);
        showToast("O hábito foi editado!");
        if (await myInterstitial.isLoaded()) myInterstitial.show();
        Navigator.pop(context);
      }).catchError(handleError);
    }
  }

  void removeHabit() async {
    if (widget.arguments.hasCompetition) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BaseTextDialog(
              title: "Opss",
              body: "É preciso sair das competições que esse hábito faz parte para poder deletá-lo.",
              action: <Widget>[
                TextButton(
                  child: const Text("Ok", style: TextStyle(fontSize: 17, color: Colors.black)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });
    } else {
      showSimpleDialog("Deletar", "Você estava indo tão bem... Tem certeza que quer deletá-lo?",
          subBody: "(Todo o progresso dele será perdido e a quilômetragem perdida)", confirmCallback: () async {
        showLoading(true);
        (await controller.removeHabit()).result((data) {
          showLoading(false);
          navigatePop(result: false);
        }, (error) => handleError);
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
            Header(title: "EDITAR HÁBITO", button: IconButton(icon: Icon(Icons.delete), onPressed: removeHabit)),
            const SizedBox(height: 10),
            Observer(builder: (_) {
              return SelectColor(currentColor: controller.color, onSelectColor: controller.selectColor);
            }),
            const SizedBox(height: 20),
            Observer(builder: (_) {
              return HabitText(color: controller.habitColor, controller: habitTextController);
            }),
            Observer(builder: (_) {
              return SelectFrequency(
                  color: controller.habitColor,
                  currentFrequency: controller.frequency,
                  selectFrequency: controller.selectFrequency);
            }),
            Observer(builder: (_) {
              return Container(
                margin: const EdgeInsets.only(top: 30, bottom: 28),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(controller.habitColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0)),
                      overlayColor: MaterialStateProperty.all(Colors.white24),
                      elevation: MaterialStateProperty.all(2)),
                  onPressed: updateHabit,
                  child: const Text("SALVAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
