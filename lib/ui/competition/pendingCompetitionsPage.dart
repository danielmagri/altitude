import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:habit/controllers/CompetitionsControl.dart';
import 'package:habit/controllers/HabitsControl.dart';
import 'package:habit/controllers/UserControl.dart';
import 'package:habit/objects/Competition.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/ui/widgets/generic/Rocket.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/utils/Constants.dart';

class PendingCompetitionsPage extends StatefulWidget {
  @override
  _PendingCompetitionsPageState createState() =>
      _PendingCompetitionsPageState();
}

class _PendingCompetitionsPageState extends State<PendingCompetitionsPage> {
  bool isEmpty = false;
  List<Competition> pendingCompetitions = [];

  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    if (await UserControl().isLogged()) {
      Loading.showLoading(context);
      CompetitionsControl().getPendingCompetitions().then((competitions) async {
        if (competitions.length == 0) {
          isEmpty = true;
          CompetitionsControl().setPendingCompetitionsStatus(false);
        } else {
          pendingCompetitions = competitions;
          pendingCompetitions.sort((a, b) => a.title.compareTo(b.title));
        }
        Loading.closeLoading(context);
        setState(() {});
      }).catchError((_) {
        Loading.closeLoading(context);
        showToast("Ocorreu um erro");
        isEmpty = true;
        setState(() {});
      });
    }
  }

  void _chooseHabit(BuildContext context, int index) async {
    Loading.showLoading(context);
    if ((await CompetitionsControl().listCompetitions()).length >=
        MAX_COMPETITIONS) {
      showToast("Você atingiu o número máximo de competições.");
      return;
    }
    List<Habit> habits = await HabitsControl().getAllHabits();

    Loading.closeLoading(context);

    if (habits == null) {
      showToast("Ocorreu um erro");
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return ChooseHabit(
              id: pendingCompetitions[index].id,
              title: pendingCompetitions[index].title,
              habits: habits,
              accepted: () {
                pendingCompetitions.removeAt(index);
                if (pendingCompetitions.length == 0) {
                  isEmpty = true;
                  CompetitionsControl().setPendingCompetitionsStatus(false);
                }
                setState(() {});
              },
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 16),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: BackButton(),
                ),
                Expanded(
                  child: Text(
                    "Solicitações de competição",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
              ],
            ),
          ),
          isEmpty
              ? Text(
                  "Não tem nenhuma competição pendente",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22.0, color: Colors.black.withOpacity(0.2)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: pendingCompetitions.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                      height: 90,
                      width: double.maxFinite,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 19),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          pendingCompetitions[index].title !=
                                                  null
                                              ? pendingCompetitions[index].title
                                              : "",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          pendingCompetitions[index]
                                              .listCompetitors(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FloatingActionButton(
                                      child: Icon(Icons.close),
                                      mini: true,
                                      heroTag: null,
                                      backgroundColor: Colors.red,
                                      elevation: 0,
                                      onPressed: () {
                                        Loading.showLoading(context);
                                        CompetitionsControl()
                                            .declineCompetitionRequest(
                                                pendingCompetitions[index].id)
                                            .then((_) {
                                          Loading.closeLoading(context);
                                          pendingCompetitions.removeAt(index);
                                          if (pendingCompetitions.length == 0) {
                                            isEmpty = true;
                                            CompetitionsControl()
                                                .setPendingCompetitionsStatus(
                                                    false);
                                          }
                                          setState(() {});
                                        }).catchError((error) {
                                          Loading.closeLoading(context);
                                          if (error
                                              is CloudFunctionsException) {
                                            if (error.details == true) {
                                              showToast(error.message);
                                              return;
                                            }
                                          }
                                          showToast("Ocorreu um erro");
                                        });
                                      }),
                                  SizedBox(width: 8),
                                  FloatingActionButton(
                                    child: Icon(Icons.check),
                                    mini: true,
                                    heroTag: null,
                                    backgroundColor: Colors.green,
                                    elevation: 0,
                                    onPressed: () =>
                                        _chooseHabit(context, index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: double.maxFinite,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(color: Colors.black12),
                          ),
                        ],
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }
}

class ChooseHabit extends StatefulWidget {
  ChooseHabit(
      {Key key,
      @required this.id,
      @required this.title,
      @required this.habits,
      @required this.accepted})
      : super(key: key);

  final String id;
  final String title;
  final List<Habit> habits;
  final Function accepted;

  @override
  _ChooseHabitState createState() => _ChooseHabitState();
}

class _ChooseHabitState extends State<ChooseHabit> {
  Habit selectedHabit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Escolha um hábito para competir'),
      content: Container(
        margin: const EdgeInsets.only(
          right: 8,
          left: 8,
        ),
        child: DropdownButton<Habit>(
            value: selectedHabit,
            isExpanded: true,
            hint: Text("Escolher um hábito"),
            items: widget.habits.map((habit) {
              return DropdownMenuItem(
                value: habit,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Rocket(
                        size: Size(30, 30),
                        isExtend: true,
                        color: AppColors.habitsColor[habit.color]),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      habit.habit,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedHabit = value;
              });
            }),
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
              'COMPETIR',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if ((await CompetitionsControl()
                          .listCompetitionsIds(selectedHabit.id))
                      .length >=
                  MAX_HABIT_COMPETITIONS) {
                showToast(
                    "O hábito já faz parte de $MAX_HABIT_COMPETITIONS competições.");
                return;
              }
              Loading.showLoading(context);
              CompetitionsControl()
                  .acceptCompetitionRequest(
                      widget.id, widget.title, selectedHabit.id)
                  .then((_) {
                Loading.closeLoading(context);
                Navigator.of(context).pop();
                widget.accepted();
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
            })
      ],
    );
  }
}
