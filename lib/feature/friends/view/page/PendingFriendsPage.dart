import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/feature/friends/logic/PendingFriendsLogic.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class PendingFriendsPage extends StatefulWidget {
  @override
  _PendingFriendsPageState createState() => _PendingFriendsPageState();
}

class _PendingFriendsPageState extends BaseState<PendingFriendsPage> {
  PendingFriendsLogic controller = GetIt.I.get<PendingFriendsLogic>();

  @override
  void initState() {
    super.initState();

    controller.fetchData().catchError(handleError);
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<PendingFriendsLogic>();
    super.dispose();
  }

  void acceptRequest(Person person) {
    showLoading(true);
    controller.acceptRequest(person).then((_) {
      showLoading(false);
    }).catchError((error) {
      showLoading(false);
      if (error is CloudFunctionsException) {
        if (error.details == true) {
          showToast(error.message);
          return;
        }
      }
      showToast("Ocorreu um erro");
    });
  }

  void declineRequest(Person person) {
    showLoading(true);
    controller.declineRequest(person).then((_) {
      showLoading(false);
    }).catchError((error) {
      showLoading(false);
      if (error is CloudFunctionsException) {
        if (error.details == true) {
          showToast(error.message);
          return;
        }
      }
      showToast("Ocorreu um erro");
    });
  }

  Widget actionButton(IconData icon, Color color, Function action) {
    return FloatingActionButton(
        child: Icon(icon), mini: true, heroTag: null, backgroundColor: color, elevation: 0, onPressed: action);
  }

  Future<bool> onBackPressed() {
    Navigator.pop(context, controller.addedFriends);
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
            Container(
              margin: const EdgeInsets.only(top: 40, bottom: 16),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 50, child: BackButton()),
                  Expanded(
                    child: const Text("Solicitações de amizade",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 50),
                ],
              ),
            ),
            Observer(builder: (_) {
              return controller.pendingFriends.handleState(() {
                return Column(
                  children: <Widget>[
                    const SizedBox(height: 48),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    const Text("Buscando pedidos de amizade...")
                  ],
                );
              }, (data) {
                if (data.isEmpty)
                  return Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Text("Não tem nenhuma amizade pendente",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22.0, color: Colors.black.withOpacity(0.2))),
                  );
                else
                  return ListView.separated(
                    separatorBuilder: (_, __) {
                      return Container(
                        height: 1,
                        width: double.maxFinite,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: Colors.black12),
                      );
                    },
                    padding: const EdgeInsets.only(bottom: 20),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (_, int index) {
                      Person person = data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    person.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        decoration: person.you ? TextDecoration.underline : TextDecoration.none),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    person.email,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            actionButton(Icons.close, Colors.red, () => declineRequest(person)),
                            const SizedBox(width: 8),
                            actionButton(Icons.check, Colors.green, () => acceptRequest(person)),
                          ],
                        ),
                      );
                    },
                  );
              }, (error) {
                return SizedBox();
              });
            }),
          ],
        ),
      ),
    );
  }
}
