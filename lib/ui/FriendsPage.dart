import 'package:flutter/material.dart';
import 'package:habit/objects/Person.dart';
import 'package:habit/ui/loginPage.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/utils/Util.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Person> persons = [
    new Person(name: "João", score: 100),
    new Person(name: "Ricardo", score: 1223),
    new Person(name: "Daniel", score: 0),
    new Person(name: "Giovana", score: 1500),
    new Person(name: "Haroldo", score: 23),
    new Person(name: "Joaquim da silva capistrano castro", score: 23),
    new Person(name: "Joaquim da silva capistrano castro", score: 23),
    new Person(name: "Joaquim da silva capistrano castro", score: 23),
    new Person(
        name:
            "Joaquim da silva capistrano castro junquira neto nogueira ghkgjfhdg",
        score: 23),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
        Util.dialogNavigator(context, LoginPage());
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
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Amigos",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
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
            ListView.builder(
              itemExtent: 75,
              padding: const EdgeInsets.only(bottom: 80),
              physics: BouncingScrollPhysics(),
              itemCount: persons.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 19),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                persons[index].name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
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
                    Container(
                      height: 1,
                      width: double.maxFinite,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black38,
                            Colors.transparent
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Text(
              "Second",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: AppColors.colorHabitMix,
        ),
      ),
    );
  }
}
