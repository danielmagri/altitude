import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:habit/controllers/UserControl.dart';
import 'package:habit/objects/Person.dart';
import 'package:habit/ui/AddFriendPage.dart';
import 'package:habit/ui/PendingFriendsPage.dart';
import 'package:habit/ui/dialogs/BaseDialog.dart';
import 'package:habit/ui/loginPage.dart';
import 'package:habit/ui/widgets/generic/IconButtonStatus.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/utils/Util.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  bool isEmpty = false;
  List<Person> persons = [];
  List<Person> personsOrdened = [];

  bool pendingStatus = false;

  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    if (await UserControl().isLogged()) {
      Loading.showLoading(context);
      pendingStatus = await UserControl().getPendingFriendsStatus();
      UserControl().getFriends().then((friends) async {
        if (friends.length == 0) {
          isEmpty = true;
        } else {
          isEmpty = false;
          persons = friends;
          personsOrdened = friends.toList();
          personsOrdened.add(new Person(
              name: await UserControl().getName(),
              email: await UserControl().getEmail(),
              score: await UserControl().getScore(),
              you: true));
          sortLists();
        }
        Loading.closeLoading(context);
        setState(() {});
      }).catchError((_) {
        Loading.closeLoading(context);
        showToast("Ocorreu um erro");
        isEmpty = true;
        setState(() {});
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Util.dialogNavigator(context, LoginPage()).then((res) {
          if (res != null) {
            getData();
          }
        });
      });
      isEmpty = true;
      setState(() {});
    }
  }

  void sortLists() {
    persons.sort((a, b) => a.name.compareTo(b.name));
    personsOrdened.sort((a, b) => -a.score.compareTo(b.score));
  }

  Widget _positionWidget(int position) {
    if (position == 1) {
      return Image.asset("assets/first.png", height: 30);
    } else if (position == 2) {
      return Image.asset("assets/second.png", height: 30);
    } else if (position == 3) {
      return Image.asset("assets/third.png", height: 30);
    } else {
      return Text(
        "#$position",
        style: TextStyle(fontSize: 20),
      );
    }
  }

  Widget listFriends() {
    return ListView.builder(
      itemExtent: 75,
      padding: const EdgeInsets.only(bottom: 80),
      physics: BouncingScrollPhysics(),
      itemCount: persons.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return Column(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BaseDialog(
                        title: "Desfazer amizade",
                        body:
                            "Tem certeza que deseja desfazer amizade com ${persons[index].name}?",
                        action: <Widget>[
                          new FlatButton(
                            child: new Text(
                              "SIM",
                              style: TextStyle(fontSize: 17),
                            ),
                            onPressed: () async {
                              Loading.showLoading(context);
                              UserControl()
                                  .removeFriend(persons[index].uid)
                                  .then((_) {
                                Loading.closeLoading(context);
                                Navigator.of(context).pop();
                                personsOrdened.removeWhere((person) =>
                                    person.uid == persons[index].uid);
                                persons.removeAt(index);
                                setState(() {});
                              }).catchError((error) {
                                Loading.closeLoading(context);
                                if (error is CloudFunctionsException) {
                                  if (error.details == true) {
                                    showToast(error.message);
                                    return;
                                  }
                                }
                                showToast("Ocorreu um erro");
                              });
                            },
                          ),
                          new FlatButton(
                            child: new Text(
                              "NÃO",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          persons[index].name != null
                              ? persons[index].name
                              : "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            persons[index].getLevelText(),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "${persons[index].score} Km",
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.black12),
            ),
          ],
        );
      },
    );
  }

  Widget listRanking() {
    return ListView.builder(
      itemExtent: 75,
      padding: const EdgeInsets.only(bottom: 80),
      physics: BouncingScrollPhysics(),
      itemCount: personsOrdened.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19),
                child: Row(
                  children: <Widget>[
                    _positionWidget(index + 1),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        personsOrdened[index].name != null
                            ? personsOrdened[index].name
                            : "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          decoration: personsOrdened[index].you
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
                          personsOrdened[index].getLevelText(),
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "${personsOrdened[index].score} Km",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.black12),
            ),
          ],
        );
      },
    );
  }

  Widget emptyWidget() {
    return Center(
      child: Text(
        "Adicione seus amigos clicando no botão \"+\" abaixo.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22.0, color: Colors.black.withOpacity(0.2)),
      ),
    );
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
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            "Amigos",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButtonStatus(
                icon: Icon(Icons.group_add),
                status: pendingStatus,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return PendingFriendsPage();
                  })).then((res) {
                    if (res is List<Person>) {
                      persons.addAll(res);
                      personsOrdened.addAll(res);
                      sortLists();
                    }
                  });
                })
          ],
          bottom: TabBar(
            indicatorColor: AppColors.colorHabitMix,
            unselectedLabelColor: Colors.black,
            labelColor: AppColors.colorHabitMix,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: <Widget>[
              Tab(
                text: "Meus amigos",
              ),
              Tab(
                text: "Ranking",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            isEmpty ? emptyWidget() : listFriends(),
            isEmpty ? emptyWidget() : listRanking(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          heroTag: null,
          backgroundColor: AppColors.colorHabitMix,
          onPressed: () {
            Util.dialogNavigator(context, AddFriendPage()).then((data) {
              if (data is Person) {
                persons.add(data);
                personsOrdened.add(data);
                sortLists();
                setState(() {});
              }
            });
          },
        ),
      ),
    );
  }
}
