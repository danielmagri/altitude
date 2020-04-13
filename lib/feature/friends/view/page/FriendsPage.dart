import 'dart:async';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/view/generic/IconButtonStatus.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/feature/friends/logic/FriendsLogic.dart';
import 'package:altitude/feature/friends/view/dialog/AddFriendDialog.dart';
import 'package:altitude/feature/friends/view/widget/FriendsList.dart';
import 'package:altitude/feature/friends/view/widget/RankingList.dart';
import 'package:altitude/feature/login/view/dialog/LoginDialog.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends BaseState<FriendsPage> {
  FriendsLogic controller = GetIt.I.get<FriendsLogic>();

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
        navigateSmooth(LoginDialog(isCompetitionPage: false)).then((value) {
          if (value != null) getData();
        });
        controller.setEmptyData();
      });
    }
  }

  void getData() {
    controller.fetchData().catchError(handleError);
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<FriendsLogic>();
    super.dispose();
  }

  @override
  void onPageBack(Object value) {
    if (value is List<Person>) {
      controller.addPersons(value);
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
        controller.addPersons([value]);
      }
    });
  }

  void removeFriend(String uid) {
    showLoading(true);

    controller.removeFriend(uid).then((_) {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text("Amigos",
              style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            Observer(builder: (_) {
              return IconButtonStatus(
                  icon: Icon(Icons.mail), status: controller.pendingStatus, onPressed: goPendingFriends);
            })
          ],
          bottom: TabBar(
            indicatorColor: AppColors.colorAccent,
            unselectedLabelColor: Colors.black,
            labelColor: AppColors.colorAccent,
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: <Widget>[
              const Tab(text: "Meus amigos"),
              const Tab(text: "Ranking"),
            ],
          ),
        ),
        body: TabBarView(children: <Widget>[FriendsList(removeFriend: removeFriend), RankingList()]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          heroTag: null,
          backgroundColor: AppColors.colorAccent,
          onPressed: addNewFriend,
        ),
      ),
    );
  }
}
