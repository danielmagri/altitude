import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/generic/IconButtonStatus.dart';
import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/feature/friends/presentation/controllers/friends_controller.dart';
import 'package:altitude/feature/friends/presentation/dialogs/add_friend_dialog.dart';
import 'package:altitude/feature/friends/presentation/widgets/friends_list.dart';
import 'package:altitude/feature/friends/presentation/widgets/ranking_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends BaseStateWithController<FriendsPage, FriendsController> {
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
    navigateSmooth(AddFriendDialog()).then((value) {
      if (value is Person) {
        controller.addPersons([value].asObservable());
      }
    });
  }

  void removeFriend(Person person) {
    showSimpleDialog("Desfazer amizade", "Tem certeza que deseja desfazer amizade com ${person.name}?",
        confirmCallback: () {
      showLoading(true);

      controller.removeFriend(person.uid).then((_) {
        showLoading(false);
      }).catchError(handleError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Amigos"),
          actions: [
            Observer(
                builder: (_) => IconButtonStatus(
                    icon: Icon(Icons.mail), status: controller.pendingStatus, onPressed: goPendingFriends))
          ],
          bottom: TabBar(
            tabs: [
              const Tab(text: "Meus amigos"),
              const Tab(text: "Ranking"),
            ],
          ),
        ),
        body: TabBarView(children: [FriendsList(removeFriend: removeFriend), RankingList()]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          heroTag: null,
          backgroundColor: AppTheme.of(context).materialTheme.accentColor,
          onPressed: addNewFriend,
        ),
      ),
    );
  }
}
