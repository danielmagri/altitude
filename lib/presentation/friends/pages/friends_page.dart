import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/generic/IconButtonStatus.dart';
import 'package:altitude/domain/models/person_entity.dart';
import 'package:altitude/presentation/friends/controllers/friends_controller.dart';
import 'package:altitude/presentation/friends/dialogs/add_friend_dialog.dart';
import 'package:altitude/presentation/friends/widgets/friends_list.dart';
import 'package:altitude/presentation/friends/widgets/ranking_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState
    extends BaseStateWithController<FriendsPage, FriendsController> {
  @override
  void initState() {
    super.initState();

    controller.fetchData().catchError(handleError);
  }

  @override
  void onPageBack(Object? value) {
    if (value is List<Person>) {
      controller.addPersons(value.asObservable());
    }
    controller.checkPendingFriendsStatus();
    super.onPageBack(value);
  }

  void goPendingFriends() {
    navigatePush('pendingFriends');
  }

  void addNewFriend() {
    navigateSmooth(const AddFriendDialog()).then((value) {
      if (value is Person) {
        controller.addPersons([value].asObservable());
      }
    });
  }

  void removeFriend(Person person) {
    showSimpleDialog(
      'Desfazer amizade',
      'Tem certeza que deseja desfazer amizade com ${person.name}?',
      confirmCallback: () {
        showLoading(true);

        controller.removeFriend(person.uid).then((_) {
          showLoading(false);
        }).catchError(handleError);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Amigos'),
          actions: [
            Observer(
              builder: (_) => IconButtonStatus(
                icon: const Icon(Icons.mail),
                status: controller.pendingStatus,
                onPressed: goPendingFriends,
              ),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Meus amigos'),
              Tab(text: 'Ranking'),
            ],
          ),
        ),
        body: TabBarView(
          children: [FriendsList(removeFriend: removeFriend), RankingList()],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          heroTag: null,
          backgroundColor: AppTheme.of(context).materialTheme.accentColor,
          onPressed: addNewFriend,
        ),
      ),
    );
  }
}
