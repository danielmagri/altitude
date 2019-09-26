import 'package:flutter/material.dart';
import 'package:habit/controllers/AuthDataControl.dart';
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

  List<Person> personsOrdened;

  @override
  void initState() {
    personsOrdened = persons.toList();
    personsOrdened.sort((a, b) => -a.score.compareTo(b.score));
    persons.sort((a, b) => a.name.compareTo(b.name));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(!await AuthDataControl().isLogged()) {
        Util.dialogNavigator(context, LoginPage());
      }
    });
  }


    Widget _positionWidget(int position) {
      if (position == 1) {
        return Image.asset("assets/first.png", height: 30);
      }else if (position == 2) {
        return Image.asset("assets/second.png", height: 30);
      }else if (position == 3) {
        return Image.asset("assets/third.png", height: 30);
      }else{
        return Text("#$position", style: TextStyle(fontSize: 20),);
      }
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
            ListView.builder(
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
                                personsOrdened[index].name,
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: AppColors.colorHabitMix,
          onPressed: () {
          },
        ),
      ),
    );
  }
}
