import 'package:altitude/common/model/Competitor.dart';
import 'dart:async' show Timer;
import 'package:altitude/common/router/arguments/CompetitionDetailsPageArguments.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/common/view/dialog/BaseDialog.dart';
import 'package:altitude/common/view/dialog/BaseTextDialog.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/TutorialPresentation.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/core/model/BackDataItem.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/feature/competition/logic/CompetitionDetailsLogic.dart';
import 'package:altitude/feature/competition/view/dialog/AddCompetitorsDialog.dart';
import 'package:altitude/feature/competition/view/widget/Metrics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:altitude/utils/Color.dart';
import 'package:get_it/get_it.dart';

class CompetitionDetailsPage extends StatefulWidget {
  CompetitionDetailsPage(this.arguments);

  final CompetitionDetailsPageArguments arguments;

  @override
  _CompetitionDetailsPageState createState() => _CompetitionDetailsPageState();
}

class _CompetitionDetailsPageState extends BaseState<CompetitionDetailsPage> {
  CompetitionDetailsLogic controller = GetIt.I.get<CompetitionDetailsLogic>();

  TextEditingController titleTextController = TextEditingController();

  @override
  initState() {
    super.initState();

    controller.title = widget.arguments.competition.title;

    showInitialTutorial();
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<CompetitionDetailsLogic>();
    titleTextController.dispose();
    super.dispose();
  }

  void showInitialTutorial() async {
    if (!SharedPref.instance.competitionTutorial) {
      Timer.run(() async {
        await Future.delayed(Duration(milliseconds: 600));
        await navigateSmooth(
          TutorialPresentation(
              focusAlignment: Alignment(0, 0),
              focusRadius: 0,
              textAlignment: Alignment(0, 0),
              text: const [
                TextSpan(
                    text: "  E que comece a competição! Qual de vocês consegue ir mais longe?",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        "\n\n  Ao iniciar uma competição a quilometragem do hábito começa a ser contada a partir da semana do início da competição. Mas fique tranquilo o seu progresso pessoal não será perdido."),
              ],
              hasNext: false),
        );
      });
      SharedPref.instance.competitionTutorial = true;
    }
  }

  void saveTitle() async {
    String result = ValidationHandler.competitionNameValidate(titleTextController.text);

    if (result != null) {
      showToast(result);
    } else {
      showLoading(true);
      controller.changeTitle(widget.arguments.competition.id, titleTextController.text).then((res) {
        showLoading(false);
        navigatePop();
      }).catchError(handleError);
    }
  }

  void _showTitleDialog() async {
    titleTextController.text = controller.title;

    return showDialog(
        context: context,
        builder: (context) {
          return BaseDialog(
            title: 'Alterar título',
            body: TextField(
              controller: titleTextController,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              onEditingComplete: saveTitle,
            ),
            action: <Widget>[
              FlatButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(context).pop()),
              FlatButton(
                  child: const Text('Salvar', style: TextStyle(fontWeight: FontWeight.bold)), onPressed: saveTitle)
            ],
          );
        });
  }

  void _addCompetitor() async {
    showLoading(true);
    controller.getFriends().then((friends) {
      showLoading(false);
      if (friends == null) {
        showToast("Ocorreu um erro");
      } else {
        List<String> competitors =
            widget.arguments.competition.competitors.map((competitor) => competitor.uid).toList();
        showDialog(
            context: context,
            builder: (context) =>
                AddCompetitorsDialog(id: widget.arguments.competition.id, friends: friends, competitors: competitors));
      }
    }).catchError(handleError);
  }

  void _leaveCompetition() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BaseTextDialog(
          title: "Sair da competição",
          body: "Tem certeza que deseja sair da competição?",
          action: <Widget>[
            FlatButton(
              child: const Text("Sim", style: TextStyle(fontSize: 17)),
              onPressed: () {
                showLoading(true);
                controller.leaveCompetition(widget.arguments.competition.id).then((res) {
                  showLoading(false);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(BackDataItem.removed(widget.arguments.competition));
                }).catchError(handleError);
              },
            ),
            FlatButton(
              child: const Text("Não", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _aboutCompetition() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BaseTextDialog(
          title: "Sobre",
          body:
              "Data de início: ${widget.arguments.competition.initialDate.day.toString().padLeft(2, '0')}/${widget.arguments.competition.initialDate.month.toString().padLeft(2, '0')}/${widget.arguments.competition.initialDate.year}",
          action: <Widget>[
            FlatButton(
              child: const Text("Fechar", style: TextStyle(fontSize: 17)),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  double getMaxHeight(BuildContext context) {
    double height = 0;

    if (widget.arguments.competition.competitors != null && widget.arguments.competition.competitors.isNotEmpty) {
      height = (widget.arguments.competition.competitors[0].score * 10.0) + 200;
    }

    if (height < MediaQuery.of(context).size.height) {
      return MediaQuery.of(context).size.height - 110;
    } else {
      return height;
    }
  }

  List<Widget> _competitorsWidget() {
    List<Widget> widgets = List();

    widgets.add(Metrics(height: getMaxHeight(context)));

    for (Competitor competitor in widget.arguments.competition.competitors) {
      widgets.add(Expanded(
        child: SizedBox(
          height: (competitor.score * 10.0) + 60,
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.topCenter,
            children: <Widget>[
              Positioned(
                top: 70,
                bottom: 0,
                width: 25,
                child: Image.asset("assets/smoke.png", repeat: ImageRepeat.repeatY),
              ),
              Rocket(
                size: const Size(100, 100),
                color: AppColors.habitsColor[competitor.color],
                state: RocketState.ON_FIRE,
                fireForce: 2,
              ),
              Transform.rotate(
                angle: -1.57,
                child: FractionalTranslation(
                  translation: const Offset(0.75, 0),
                  child: SizedBox(
                    width: 100,
                    child: Text(competitor.you ? "Eu" : competitor.name,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: competitor.you ? const TextStyle(fontWeight: FontWeight.bold) : null),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sky,
      body: Column(
        children: <Widget>[
          Container(
            height: 106,
            child: Row(
              children: <Widget>[
                const SizedBox(width: 50, child: BackButton()),
                Expanded(
                    child: Text(controller.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20))),
                SizedBox(
                  width: 50,
                  child: PopupMenuButton<int>(
                    onSelected: (int result) {
                      switch (result) {
                        case 1:
                          _showTitleDialog();
                          break;
                        case 2:
                          _addCompetitor();
                          break;
                        case 3:
                          _leaveCompetition();
                          break;
                        case 4:
                          _aboutCompetition();
                          break;
                      }
                    },
                    itemBuilder: (_) => <PopupMenuEntry<int>>[
                      const PopupMenuItem<int>(value: 1, child: Text('Alterar título')),
                      const PopupMenuItem<int>(value: 2, child: Text('Adicionar amigos')),
                      const PopupMenuItem<int>(value: 3, child: Text('Sair da competição')),
                      const PopupMenuItem<int>(value: 4, child: Text('Sobre')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _competitorsWidget(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
