import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/header.dart';
import 'package:altitude/domain/models/person_entity.dart';
import 'package:altitude/presentation/friends/controllers/pending_friends_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PendingFriendsPage extends StatefulWidget {
  const PendingFriendsPage({Key? key}) : super(key: key);

  @override
  _PendingFriendsPageState createState() => _PendingFriendsPageState();
}

class _PendingFriendsPageState extends BaseStateWithController<
    PendingFriendsPage, PendingFriendsController> {
  @override
  void initState() {
    super.initState();
    controller.fetchData().catchError(handleError);
  }

  void acceptRequest(Person person) {
    showLoading(true);
    controller.acceptRequest(person).then((_) {
      showLoading(false);
    }).catchError(handleError);
  }

  void declineRequest(Person person) {
    showLoading(true);
    controller.declineRequest(person).then((_) {
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
          children: [
            const Header(title: 'Solicitações de amizade'),
            const SizedBox(height: 16),
            Observer(
              builder: (_) {
                return controller.pendingFriends.handleState(
                  loading: () {
                    return Column(
                      children: const <Widget>[
                        SizedBox(height: 48),
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Buscando pedidos de amizade...')
                      ],
                    );
                  },
                  success: (data) {
                    if (data.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: Text(
                          'Não tem nenhuma amizade pendente',
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
                          Person person = data[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        person.name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          decoration: person.you
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                        ),
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
                                actionButton(
                                  Icons.close,
                                  Colors.red,
                                  () => declineRequest(person),
                                ),
                                const SizedBox(width: 8),
                                actionButton(
                                  Icons.check,
                                  Colors.green,
                                  () => acceptRequest(person),
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
