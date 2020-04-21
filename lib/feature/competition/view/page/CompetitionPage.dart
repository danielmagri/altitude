import 'dart:async';
import 'package:altitude/common/model/CompetitionPresentation.dart';
import 'package:altitude/common/router/arguments/CompetitionDetailsPageArguments.dart';
import 'package:altitude/common/router/arguments/CreateCompetitionPageArguments.dart';
import 'package:altitude/common/view/dialog/BaseTextDialog.dart';
import 'package:altitude/common/view/generic/IconButtonStatus.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/common/view/generic/Toast.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/feature/competition/logic/CompetitionLogic.dart';
import 'package:altitude/feature/login/view/dialog/LoginDialog.dart';
import 'package:flutter/material.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class CompetitionPage extends StatefulWidget {
  @override
  _CompetitionPageState createState() => _CompetitionPageState();
}

class _CompetitionPageState extends BaseState<CompetitionPage> {
  CompetitionLogic controller = GetIt.I.get<CompetitionLogic>();

  @override
  void initState() {
    super.initState();

    initialize();
  }

  void initialize() async {
    if (await controller.isLogged) {
      getData();
    } else {
      Timer.run(() async {
        navigateSmooth(LoginDialog(isCompetitionPage: true)).then((value) {
          if (value != null) getData();
        });
      });
    }
  }

  void getData() {
    controller.fetchData().catchError(handleError);
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<CompetitionLogic>();
    super.dispose();
  }

  @override
  void onPageBack(Object value) {
    getData();
    super.onPageBack(value);
  }

  void createCompetition() async {
    showLoading(true);
    if (await controller.checkCreateCompetition()) {
      try {
        var data = await controller.getCreationData();
        showLoading(false);
        if (data.first == null || data.second == null) throw "Vazio";

        var arguments = CreateCompetitionPageArguments(data.first, data.second);
        navigatePush("createCompetition", arguments: arguments);
      } catch (error) {
        handleError(error);
      }
    } else {
      showLoading(false);
      showToast("Você atingiu o número máximo de competições.");
    }
  }

  void competitionTap(CompetitionPresentation item) {
    showLoading(true);
    controller.getCompetitionDetail(item.id).then((competition) {
      showLoading(false);

      if (competition != null) {
        if (competition.title != item.title) {
          controller.updateCompetitionTitle(item.id, competition.title);
        }
        var arguments = CompetitionDetailsPageArguments(competition);
        navigatePush('competitionDetails', arguments: arguments);
      } else {
        showToast("Ocorreu um erro");
      }
    }).catchError(handleError);
  }

  void competitionLongTap(CompetitionPresentation item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BaseTextDialog(
          title: "Largar competição",
          body: "Tem certeza que deseja sair da competição?",
          action: <Widget>[
            FlatButton(
              child: const Text("Sim", style: TextStyle(fontSize: 17)),
              onPressed: () {
                showLoading(true);
                controller.exitCompetition(item.id).then((res) {
                  showLoading(false);
                  Navigator.of(context).pop();
                }).catchError((error) {
                  handleError(error);
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              child: const Text("Não", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              onPressed: navigatePop,
            ),
          ],
        );
      },
    );
  }

  // Widget _positionWidget(int position) {
  //   if (position == 1) {
  //     return Image.asset("assets/first.png", height: 25);
  //   } else if (position == 2) {
  //     return Image.asset("assets/second.png", height: 25);
  //   } else if (position == 3) {
  //     return Image.asset("assets/third.png", height: 25);
  //   } else {
  //     return Container();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 40, bottom: 16),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 50, child: BackButton()),
                  const Spacer(),
                  const Text("COMPETIÇÕES", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  SizedBox(
                    width: 50,
                    child: Observer(builder: (_) {
                      return IconButtonStatus(
                        icon: Icon(Icons.mail),
                        status: controller.pendingStatus,
                        onPressed: () => navigatePush('pendingCompetition'),
                      );
                    }),
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
                  const Expanded(child: Text("Minhas competições", style: TextStyle(fontSize: 18))),
                  FlatButton(
                    color: AppColors.colorAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    child: const Text("Criar", style: TextStyle(color: Colors.white)),
                    onPressed: createCompetition,
                  ),
                ],
              ),
            ),
            Observer(
              builder: (_) {
                return controller.competitions.handleState(() {
                  return Skeleton.custom(
                    child: GridView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        itemBuilder: (_, index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                          );
                        }),
                  );
                }, (data) {
                  if (data.isEmpty)
                    return Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Center(
                        child: Text("Comece a competir com seus amigos agora mesmo",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22.0, color: Colors.black.withOpacity(0.2))),
                      ),
                    );
                  else
                    return GridView.builder(
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemBuilder: (_, index) {
                        CompetitionPresentation competition = data[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.all(10),
                          child: InkWell(
                            onLongPress: () => competitionLongTap(competition),
                            onTap: () => competitionTap(competition),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: -50,
                                  child: LayoutBuilder(builder: (_, constraints) {
                                    return Transform.rotate(
                                        angle: 0.523,
                                        child: Rocket(
                                            size: Size(constraints.maxWidth, constraints.maxWidth),
                                            color: AppColors.habitsColor[competition.color],
                                            isExtend: true));
                                  }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(competition.title, maxLines: 2, style: const TextStyle(fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                }, (error) {
                  return const SizedBox();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}