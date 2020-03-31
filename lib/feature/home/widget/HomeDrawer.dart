import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/controllers/CompetitionsControl.dart';
import 'package:altitude/controllers/LevelControl.dart';
import 'package:altitude/controllers/UserControl.dart';
import 'package:altitude/feature/home/viewmodel/HomeViewModel.dart';
import 'package:altitude/utils/Color.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart'
    show
        Alignment,
        AsyncSnapshot,
        BorderRadius,
        BoxDecoration,
        BoxShape,
        BuildContext,
        ClipRRect,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        Drawer,
        EdgeInsets,
        FontWeight,
        FutureBuilder,
        Icon,
        Icons,
        Image,
        Key,
        ListTile,
        ListView,
        MediaQuery,
        Navigator,
        SizedBox,
        StatelessWidget,
        Text,
        TextOverflow,
        TextStyle,
        Widget;

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key key}) : super(key: key);

  void goFriends(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, 'friends');
  }

  void goCompetition(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, 'competition');
  }

  void goSettings(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, 'settings');
  }

  void goRateApp(BuildContext context) async {
    Navigator.of(context).pop();
    //const APP_STORE_URL =
    //    'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=YOUR-APP-ID&mt=8';
    const PLAY_STORE_URL = 'https://play.google.com/store/apps/details?id=com.magrizo.habit';
    if (await canLaunch(PLAY_STORE_URL)) {
      await launch(PLAY_STORE_URL);
    } else {
      throw 'Could not launch $PLAY_STORE_URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<HomeViewModel>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(color: AppColors.colorAccent),
              child: viewmodel.user.handleState(() {
                return Skeleton.custom(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.maxFinite,
                        height: 20,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.circular(15)),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.maxFinite,
                        height: 15,
                        margin: const EdgeInsets.only(right: 32),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.circular(15)),
                      )
                    ],
                  ),
                );
              }, (data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${data.email}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      alignment: Alignment.center,
                      child: data.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(data.imageUrl),
                            )
                          : Icon(
                              Icons.person,
                              size: 32,
                            ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "Olá, ${data.name}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${LevelControl.getLevelText(data.score)}",
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                  ],
                );
              }, (error) {
                return SizedBox();
              }),
            ),
            ListTile(
              title: Text('Amigos', style: TextStyle(fontSize: 16)),
              leading: Icon(Icons.people, color: Colors.black),
              trailing: FutureBuilder(
                future: UserControl().getPendingFriendsStatus(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data) {
                      return Container(
                        width: 10,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.colorAccent),
                      );
                    }
                  }
                  return SizedBox();
                },
              ),
              onTap: () => goFriends(context),
            ),
            ListTile(
              title: Text(
                'Competição',
                style: TextStyle(fontSize: 16),
              ),
              leading: Image.asset(
                "assets/ic_award.png",
                width: 25,
                color: Colors.black,
              ),
              trailing: FutureBuilder(
                future: CompetitionsControl().getPendingCompetitionsStatus(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data) {
                      return Container(
                        width: 10,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.colorAccent),
                      );
                    }
                  }
                  return SizedBox();
                },
              ),
              onTap: () => goCompetition(context),
            ),
            ListTile(
              title: Text('Configurações', style: TextStyle(fontSize: 16)),
              leading: Icon(Icons.settings, color: Colors.black),
              onTap: () => goSettings(context),
            ),
            ListTile(
              title: Text('Avalie o app', style: TextStyle(fontSize: 16)),
              leading: Icon(Icons.star, color: Colors.black),
              onTap: () => goRateApp(context),
            ),
          ],
        ),
      ),
    );
  }
}
