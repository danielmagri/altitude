import 'package:flutter/material.dart';
import 'package:habit/controllers/CompetitionsControl.dart';
import 'package:habit/controllers/HabitsControl.dart';
import 'package:habit/controllers/UserControl.dart';
import 'package:habit/objects/CompetitionPresentation.dart';
import 'package:habit/ui/competition/competitionDetailsPage.dart';
import 'package:habit/ui/competition/createCompetitionPage.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/ui/widgets/generic/Rocket.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';
import 'package:habit/utils/Color.dart';

class CompetitionPage extends StatefulWidget {
  @override
  _CompetitionPageState createState() => _CompetitionPageState();
}

class _CompetitionPageState extends State<CompetitionPage> {
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
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.only(
                  left: 16, right: 16, top: 0, bottom: 24),
              elevation: 4,
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _positionWidget(1),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Giovana",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: false
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Coach",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "${1000} Km",
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        _positionWidget(2),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Daniel",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: false
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Perseverante",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "${500} Km",
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        _positionWidget(3),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Joaquim",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: false
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Procrastinador",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "${0} Km",
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                    color: AppColors.colorHabitMix,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30)),
                    onPressed: () async {
                      Loading.showLoading(context);
                      List habits = await HabitsControl().getAllHabits();
                      List friends = await UserControl().getFriends();
                      Loading.closeLoading(context);

                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return CreateCompetitionPage(
                          habits: habits,
                          friends: friends,
                        );
                      }));
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            Loading.showLoading(context);
                            CompetitionsControl()
                                .getCompetitionDetail(competitions[index].id)
                                .then((competition) {
                              Loading.closeLoading(context);

                              if (competition != null) {
                                if (competition.title !=
                                    competitions[index].title) {
                                  CompetitionsControl().updateCompetitionDB(
                                      competitions[index].id,
                                      competition.title);
                                }

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return CompetitionDetailsPage(
                                      data: competition);
                                }));
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
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return Transform.rotate(
                                      angle: 0.523,
                                      child: Rocket(
                                        size: Size(constraints.maxWidth,
                                            constraints.maxWidth),
                                        color: AppColors.habitsColor[
                                            competitions[index].color],
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
