import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/router/arguments/CompetitionDetailsPageArguments.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/common/view/dialog/BaseTextDialog.dart';
import 'package:altitude/common/view/dialog/TutorialDialog.dart';
import 'package:altitude/common/view/generic/Loading.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/Toast.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:altitude/common/controllers/CompetitionsControl.dart';
import 'package:altitude/common/controllers/UserControl.dart';
import 'package:altitude/utils/Color.dart';
import 'package:altitude/utils/Util.dart';

class CompetitionDetailsPage extends StatefulWidget {
  CompetitionDetailsPage(this.arguments);

  final CompetitionDetailsPageArguments arguments;

  @override
  _CompetitionDetailsPageState createState() => _CompetitionDetailsPageState();
}

class _CompetitionDetailsPageState extends State<CompetitionDetailsPage> {
  TextEditingController _titleTextController = TextEditingController();

  String title = "";

  @override
  initState() {
    super.initState();

    title = widget.arguments.competition.title;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!SharedPref.instance.competitionTutorial) {
        await showTutorial();
        SharedPref.instance.competitionTutorial = true;
      }
    });
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    super.dispose();
  }

  Future showTutorial() async {
    Util.dialogNavigator(
        context,
        TutorialDialog(
          hero: "",
          texts: [
            TextSpan(
              text: "  E que comece a competição! Qual de vocês consegue ir mais longe?",
              style: TextStyle(color: Colors.black, fontSize: 18.0, height: 1.2),
            ),
            TextSpan(
              text:
                  "\n\n  Ao iniciar uma competição a quilometragem do hábito começa a ser contada a partir da semana do início da competição. Mas fique tranquilo o seu progresso pessoal não será perdido.",
              style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w300, height: 1.2),
            ),
          ],
        ));
  }

  void _showNameDialog(BuildContext context) async {
    _titleTextController.text = title;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alterar título'),
            content: TextField(
              controller: _titleTextController,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              onEditingComplete: saveTitle,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text(
                  'SALVAR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: saveTitle,
              )
            ],
          );
        });
  }

  void saveTitle() async {
    String result = ValidationHandler.competitionNameValidate(_titleTextController.text);

    if (result == null) {
      Loading.showLoading(context);
      CompetitionsControl().updateCompetition(widget.arguments.competition.id, _titleTextController.text).then((res) {
        Loading.closeLoading(context);
        Navigator.of(context).pop();

        if (res) {
          setState(() {
            title = _titleTextController.text;
          });
        }
      }).catchError((error) {
        Loading.closeLoading(context);
        Navigator.of(context).pop();

        showToast("Ocorreu um erro");
      });
    } else {
      showToast(result);
    }
  }

  void _addCompetitor(BuildContext context) async {
    Loading.showLoading(context);
    List<Person> friends = await UserControl().getFriends();
    Loading.closeLoading(context);

    if (friends == null) {
      showToast("Ocorreu um erro");
    } else {
      List<String> competitors = widget.arguments.competition.competitors.map((competitor) => competitor.uid).toList();

      showDialog(
          context: context,
          builder: (context) {
            return AddCompetitorsDialog(
              id: widget.arguments.competition.id,
              friends: friends,
              competitors: competitors,
            );
          });
    }
  }

  void _leaveCompetition() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BaseTextDialog(
          title: "Largar competição",
          body: "Tem certeza que deseja sair da competição?",
          action: <Widget>[
            new FlatButton(
              child: new Text(
                "SIM",
                style: TextStyle(fontSize: 17),
              ),
              onPressed: () async {
                Loading.showLoading(context);

                CompetitionsControl()
                    .removeCompetitor(widget.arguments.competition.id, await UserControl().getUid())
                    .then((res) {
                  Loading.closeLoading(context);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }).catchError((error) {
                  Loading.closeLoading(context);
                  Navigator.pop(context);

                  showToast("Ocorreu um erro");
                });
              },
            ),
            new FlatButton(
              child: new Text(
                "NÃO",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
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
            new FlatButton(
              child: new Text(
                "Fechar",
                style: TextStyle(fontSize: 17),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
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

  List<Widget> _competitorsWidget(BuildContext context) {
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
                size: Size(100, 100),
                color: AppColors.habitsColor[competitor.color],
                state: RocketState.ON_FIRE,
                fireForce: 2,
              ),
              Transform.rotate(
                angle: -1.57,
                child: FractionalTranslation(
                  translation: Offset(0.75, 0),
                  child: SizedBox(
                    width: 100,
                    child: Text(competitor.you ? "Eu" : competitor.name,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: competitor.you ? TextStyle(fontWeight: FontWeight.bold) : null),
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
                SizedBox(
                  width: 50,
                  child: BackButton(),
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: PopupMenuButton<int>(
                    onSelected: (int result) {
                      switch (result) {
                        case 1:
                          _showNameDialog(context);
                          break;
                        case 2:
                          _addCompetitor(context);
                          break;
                        case 3:
                          _leaveCompetition();
                          break;
                        case 4:
                          _aboutCompetition();
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text('Alterar título'),
                      ),
                      const PopupMenuItem<int>(
                        value: 2,
                        child: Text('Adicionar amigos'),
                      ),
                      const PopupMenuItem<int>(
                        value: 3,
                        child: Text('Sair da competição'),
                      ),
                      const PopupMenuItem<int>(
                        value: 4,
                        child: Text('Sobre'),
                      ),
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
                  children: _competitorsWidget(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Metrics extends StatelessWidget {
  Metrics({Key key, @required this.height}) : super(key: key);

  final double height;

  List<Widget> _metricList() {
    List<Widget> widgets = List();
    var km = (height / 10) - 6;

    widgets.insert(0, _metricWidget("0", 60));

    var h = 5;
    while (h <= km) {
      if (h <= 100) {
        widgets.insert(0, _metricWidget(h.toString(), 50));
      } else if (h <= 240) {
        widgets.insert(0, _metricWidget(h.toString(), 100));
      } else {
        widgets.insert(0, _metricWidget(h.toString(), 200));
      }

      if (h < 100) {
        h += 5;
      } else if (h < 240) {
        h += 10;
      } else {
        h += 20;
      }
    }

    return widgets;
  }

  Widget _metricWidget(String value, double height) {
    return Container(
      height: height,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
      child: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 50,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: _metricList(),
      ),
    );
  }
}

class AddCompetitorsDialog extends StatefulWidget {
  AddCompetitorsDialog({Key key, @required this.id, @required this.friends, @required this.competitors})
      : super(key: key);

  final String id;
  final List<Person> friends;
  final List<String> competitors;

  @override
  _AddCompetitorsDialogState createState() => _AddCompetitorsDialogState();
}

class _AddCompetitorsDialogState extends State<AddCompetitorsDialog> {
  List<Person> selectedFriends = [];

  void _addCompetitors() async {
    if (selectedFriends.isNotEmpty) {
      List<String> invitations = selectedFriends.map((person) => person.uid).toList();
      List<String> invitationsToken = selectedFriends.map((person) => person.fcmToken).toList();

      Loading.showLoading(context);

      CompetitionsControl()
          .addCompetitor(widget.id, await UserControl().getName(), invitations, invitationsToken)
          .then((res) {
        Loading.closeLoading(context);
        Navigator.of(context).pop();
        showToast("Convite enviado!");
      }).catchError((error) {
        Loading.closeLoading(context);
        Navigator.of(context).pop();

        showToast("Ocorreu um erro");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adicionar amigos'),
      content: Container(
        margin: const EdgeInsets.only(
          right: 8,
          left: 8,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            runSpacing: 6,
            spacing: 10,
            alignment: WrapAlignment.center,
            children: widget.friends.map((friend) {
              return ChoiceChip(
                label: Text(
                  friend.name,
                  style: TextStyle(fontSize: 15),
                ),
                selected: selectedFriends.contains(friend),
                selectedColor: AppColors.colorAccent,
                onSelected: widget.competitors.contains(friend.uid)
                    ? null
                    : (selected) {
                        setState(() {
                          selected ? selectedFriends.add(friend) : selectedFriends.remove(friend);
                        });
                      },
              );
            }).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text(
            'ADICIONAR',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: _addCompetitors,
        )
      ],
    );
  }
}
