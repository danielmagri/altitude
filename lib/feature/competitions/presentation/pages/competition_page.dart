import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/router/arguments/CompetitionDetailsPageArguments.dart';
import 'package:altitude/common/router/arguments/CreateCompetitionPageArguments.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/Header.dart';
import 'package:altitude/common/view/generic/DataError.dart';
import 'package:altitude/common/view/generic/IconButtonStatus.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/common/view/generic/Toast.dart';
import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/feature/competitions/presentation/controllers/competition_controller.dart';
import 'package:flutter/material.dart';
import 'package:altitude/common/constant/app_colors.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CompetitionPage extends StatefulWidget {
  @override
  _CompetitionPageState createState() => _CompetitionPageState();
}

class _CompetitionPageState
    extends BaseStateWithController<CompetitionPage, CompetitionController> {
  @override
  void initState() {
    super.initState();

    controller.fetchData();
  }

  @override
  void onPageBack(Object? value) {
    controller.fetchCompetitions();
    super.onPageBack(value);
  }

  void createCompetition() async {
    showLoading(true);
    if (!await controller.checkCreateCompetition()) {
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

  void competitionTap(Competition competition) {
    showLoading(true);
    controller.getCompetitionDetails(competition.id).then((value) {
      showLoading(false);
      var arguments = CompetitionDetailsPageArguments(value);
      navigatePush('competitionDetails', arguments: arguments);
    }).catchError(handleError);
  }

  void competitionLongTap(Competition item) {
    showSimpleDialog(
        "Largar competição", "Tem certeza que deseja sair da competição?",
        confirmCallback: () {
      showLoading(true);
      controller.exitCompetition(item).then((res) {
        showLoading(false);
      }).catchError((error) {
        handleError(error);
      });
    });
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
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Header(
                title: "COMPETIÇÕES",
                button: Observer(builder: (_) {
                  return IconButtonStatus(
                    icon: Icon(Icons.mail),
                    status: controller.pendingStatus,
                    onPressed: () => navigatePush('pendingCompetition'),
                  );
                })),
            const SizedBox(height: 20),
            Observer(
              builder: (_) => controller.ranking.handleState(
                loading: () {
                  return Skeleton(
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, top: 0, bottom: 24),
                      width: double.maxFinite,
                      height: 130);
                },
                success: (data) {
                  return Card(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, top: 0, bottom: 24),
                    elevation: 4,
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: Column(
                          children: data.asMap().entries.map((entry) {
                        var index = entry.key;
                        var person = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: <Widget>[
                              _positionWidget(index + 1),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  person.name!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: person.you!
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(person.levelText,
                                      style: const TextStyle(fontSize: 15)),
                                  Text("${person.score} Km",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300)),
                                ],
                              )
                            ],
                          ),
                        );
                      }).toList()),
                    ),
                  );
                },
                error: (error) {
                  return const SizedBox();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  const Expanded(
                      child: Text("Minhas competições",
                          style: TextStyle(fontSize: 18))),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            AppTheme.of(context).materialTheme.accentColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0)),
                        overlayColor: MaterialStateProperty.all(Colors.white24),
                        elevation: MaterialStateProperty.all(0)),
                    child: const Text("Criar",
                        style: TextStyle(color: Colors.white)),
                    onPressed: createCompetition,
                  ),
                ],
              ),
            ),
            Observer(
              builder: (_) => controller.competitions.handleState(
                loading: () {
                  return Skeleton.custom(
                    child: GridView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (_, index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                          );
                        }),
                  );
                },
                success: (data) {
                  if (data.isEmpty)
                    return Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Center(
                        child: Text(
                            "Comece a competir com seus amigos agora mesmo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.black.withOpacity(0.2))),
                      ),
                    );
                  else
                    return GridView.builder(
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (_, index) {
                        Competition competition = data[index];
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
                                  child:
                                      LayoutBuilder(builder: (_, constraints) {
                                    return Transform.rotate(
                                        angle: 0.523,
                                        child: Rocket(
                                            size: Size(constraints.maxWidth,
                                                constraints.maxWidth),
                                            color: AppColors.habitsColor[
                                                competition
                                                    .getMyCompetitor()
                                                    .color!],
                                            isExtend: true));
                                  }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(competition.title!,
                                      maxLines: 2,
                                      style: const TextStyle(fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                },
                error: (error) {
                  return const DataError();
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
