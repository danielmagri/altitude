import 'package:altitude/common/model/CompetitionPresentation.dart';
import 'package:altitude/common/view/generic/IconButtonStatus.dart';
import 'package:altitude/common/view/generic/Loading.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/Toast.dart';
import 'package:flutter/material.dart';
import 'package:altitude/controllers/CompetitionsControl.dart';
import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/controllers/UserControl.dart';
import 'package:altitude/feature/competition/competitionDetailsPage.dart';
import 'package:altitude/feature/competition/createCompetitionPage.dart';
import 'package:altitude/feature/competition/pendingCompetitionsPage.dart';
import 'package:altitude/feature/dialogs/BaseDialog.dart';
import 'package:altitude/utils/Color.dart';
import 'package:altitude/common/Constants.dart';
import 'package:altitude/utils/Util.dart';

import '../loginPage.dart';

class CompetitionPage extends StatefulWidget {
  @override
  _CompetitionPageState createState() => _CompetitionPageState();
}

class _CompetitionPageState extends State<CompetitionPage> {
  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    if (!await UserControl().isLogged()) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Util.dialogNavigator(context, LoginPage(isCompetitionPage: true,)).then((res) {
          if (res != null) {
            getData();
          }
        });
      });
    }
  }

  Widget _positionWidget(int position) {
    if (position == 1) {
      return Image.asset("assets/first.png", height: 25);
    } else if (position == 2) {
      return Image.asset("assets/second.png", height: 25);
    } else if (position == 3) {
      return Image.asset("assets/third.png", height: 25);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 16),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                    child: BackButton(),
                  ),
                  Spacer(),
                  Text(
                    "COMPETIÇÕES",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 50,
                    child: FutureBuilder(
                      future: CompetitionsControl().getPendingCompetitionsStatus(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        bool pending = false;
                        if (snapshot.hasData) {
                          if (snapshot.data) {
                            pending = snapshot.data;
                          }
                        }
                        return IconButtonStatus(
                          icon: Icon(Icons.group_add),
                          status: pending,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) {
                                      return PendingCompetitionsPage();
                                    },
                                    settings: RouteSettings(name: "Pending Competition Page")));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
//            Card(
//              margin: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 24),
//              elevation: 4,
//              child: Container(
//                width: double.maxFinite,
//                padding: const EdgeInsets.all(8),
//                child: Column(
//                  children: <Widget>[
//                    Row(
//                      children: <Widget>[
//                        _positionWidget(1),
//                        SizedBox(width: 12),
//                        Expanded(
//                          child: Text(
//                            "Giovana",
//                            overflow: TextOverflow.ellipsis,
//                            maxLines: 2,
//                            style: TextStyle(
//                              fontSize: 16,
//                              decoration: false ? TextDecoration.underline : TextDecoration.none,
//                            ),
//                          ),
//                        ),
//                        Column(
//                          mainAxisSize: MainAxisSize.max,
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: <Widget>[
//                            Text(
//                              "Coach",
//                              style: TextStyle(fontSize: 15),
//                            ),
//                            Text(
//                              "${1000} Km",
//                              style: TextStyle(fontWeight: FontWeight.w300),
//                            ),
//                          ],
//                        )
//                      ],
//                    ),
//                    SizedBox(height: 8),
//                    Row(
//                      children: <Widget>[
//                        _positionWidget(2),
//                        SizedBox(width: 12),
//                        Expanded(
//                          child: Text(
//                            "Daniel",
//                            overflow: TextOverflow.ellipsis,
//                            maxLines: 2,
//                            style: TextStyle(
//                              fontSize: 16,
//                              decoration: false ? TextDecoration.underline : TextDecoration.none,
//                            ),
//                          ),
//                        ),
//                        Column(
//                          mainAxisSize: MainAxisSize.max,
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: <Widget>[
//                            Text(
//                              "Perseverante",
//                              style: TextStyle(fontSize: 15),
//                            ),
//                            Text(
//                              "${500} Km",
//                              style: TextStyle(fontWeight: FontWeight.w300),
//                            ),
//                          ],
//                        )
//                      ],
//                    ),
//                    SizedBox(height: 8),
//                    Row(
//                      children: <Widget>[
//                        _positionWidget(3),
//                        SizedBox(width: 12),
//                        Expanded(
//                          child: Text(
//                            "Joaquim",
//                            overflow: TextOverflow.ellipsis,
//                            maxLines: 2,
//                            style: TextStyle(
//                              fontSize: 16,
//                              decoration: false ? TextDecoration.underline : TextDecoration.none,
//                            ),
//                          ),
//                        ),
//                        Column(
//                          mainAxisSize: MainAxisSize.max,
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: <Widget>[
//                            Text(
//                              "Procrastinador",
//                              style: TextStyle(fontSize: 15),
//                            ),
//                            Text(
//                              "${0} Km",
//                              style: TextStyle(fontWeight: FontWeight.w300),
//                            ),
//                          ],
//                        )
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Minhas competições",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  FlatButton(
                    color: AppColors.colorAccent,
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
                    onPressed: () async {
                      Loading.showLoading(context);
                      if ((await CompetitionsControl().listCompetitions()).length >=
                          MAX_COMPETITIONS) {
                        showToast("Você atingiu o número máximo de competições.");
                        Loading.closeLoading(context);
                        return;
                      }
                      List habits = await HabitsControl().getAllHabits();
                      List friends = await UserControl().getFriends();
                      Loading.closeLoading(context);

                      if (friends != null && habits != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) {
                                  return CreateCompetitionPage(
                                    habits: habits,
                                    friends: friends,
                                  );
                                },
                                settings: RouteSettings(name: "Create Competition Page")));
                      } else {
                        showToast("Ocorreu um erro");
                      }
                    },
                    child: Text(
                      "Criar",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: CompetitionsControl().listCompetitions(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<CompetitionPresentation> competitions = snapshot.data;
                  return GridView.builder(
                    itemCount: competitions.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(10),
                        child: InkWell(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BaseDialog(
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
                                            .removeCompetitor(competitions[index].id,
                                                await UserControl().getUid())
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
                          },
                          onTap: () {
                            Loading.showLoading(context);
                            CompetitionsControl()
                                .getCompetitionDetail(competitions[index].id)
                                .then((competition) {
                              Loading.closeLoading(context);

                              if (competition != null) {
                                if (competition.title != competitions[index].title) {
                                  CompetitionsControl().updateCompetitionDB(
                                      competitions[index].id, competition.title);
                                }

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) {
                                          return CompetitionDetailsPage(data: competition);
                                        },
                                        settings: RouteSettings(name: "Competition Details Page")));
                              } else {
                                showToast("Ocorreu um erro");
                              }
                            }).catchError((_) {
                              Loading.closeLoading(context);
                              showToast("Ocorreu um erro");
                            });
                          },
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: -50,
                                child: LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    return Transform.rotate(
                                      angle: 0.523,
                                      child: Rocket(
                                        size: Size(constraints.maxWidth, constraints.maxWidth),
                                        color: AppColors.habitsColor[competitions[index].color],
                                        isExtend: true,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  competitions[index].title,
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
