import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/back_data_item.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/Header.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:altitude/presentation/competitions/controllers/pending_competition_controller.dart';
import 'package:altitude/presentation/competitions/widgets/choose_habit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PendingCompetitionPage extends StatefulWidget {
  const PendingCompetitionPage({Key? key}) : super(key: key);

  @override
  _PendingCompetitionPageState createState() => _PendingCompetitionPageState();
}

class _PendingCompetitionPageState extends BaseStateWithController<
    PendingCompetitionPage, PendingCompetitionController> {
  @override
  void initState() {
    super.initState();

    controller.fetchData().catchError(handleError);
  }

  Future<void> acceptRequest(Competition competition) async {
    showLoading(true);
    if (!await controller.checkCreateCompetition()) {
      List<Habit> habits = await controller.getAllHabits();
      showLoading(false);

      showDialog(
        context: context,
        builder: (context) =>
            ChooseHabit(competition: competition, habits: habits),
      ).then((res) {
        if (res is Competition) {
          controller.acceptedCompetitionRequest(res);
        }
      });
    } else {
      showToast('Você atingiu o número máximo de competições.');
    }
  }

  Future<void> declineRequest(Competition competition) async {
    showLoading(true);
    controller.declineCompetitionRequest(competition.id).then((_) {
      showLoading(false);
    }).catchError(handleError);
  }

  Widget actionButton(IconData icon, Color color, Function action) {
    return FloatingActionButton(
      child: Icon(icon),
      mini: true,
      heroTag: null,
      backgroundColor: color,
      elevation: 0,
      onPressed: action as void Function()?,
    );
  }

  Future<bool> onBackPressed() {
    var result = BackDataItem.added(controller.addedCompetitions);
    Navigator.pop(context, result);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Header(title: 'Solicitações de competição'),
            const SizedBox(height: 16),
            Observer(
              builder: (_) {
                return controller.pendingCompetition.handleState(
                  loading: () {
                    return Column(
                      children: const <Widget>[
                        SizedBox(height: 48),
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Buscando competições pendentes...')
                      ],
                    );
                  },
                  success: (data) {
                    if (data.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: Text(
                          'Não tem nenhuma competição pendente',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: AppTheme.of(context)
                                .materialTheme
                                .textTheme
                                .headline1!
                                .color!
                                .withOpacity(0.2),
                          ),
                        ),
                      );
                    } else {
                      return ListView.separated(
                        separatorBuilder: (_, __) =>
                            const Divider(endIndent: 16, indent: 16),
                        padding: const EdgeInsets.only(bottom: 20),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (_, index) {
                          Competition competition = data[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        competition.title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        competition.listCompetitors(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                actionButton(
                                  Icons.close,
                                  Colors.red,
                                  () => declineRequest(competition),
                                ),
                                const SizedBox(width: 8),
                                actionButton(
                                  Icons.check,
                                  Colors.green,
                                  () => acceptRequest(competition),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
