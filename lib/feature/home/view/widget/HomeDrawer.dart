import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/controllers/CompetitionsControl.dart';
import 'package:altitude/controllers/LevelControl.dart';
import 'package:altitude/controllers/UserControl.dart';
import 'package:altitude/feature/home/logic/HomeLogic.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
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
        Widget,
        required;

class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key key, @required this.goFriends, @required this.goCompetition, @required this.goSettings})
      : controller = GetIt.I.get<HomeLogic>(),
        super(key: key);

  final HomeLogic controller;
  final Function goFriends;
  final Function goCompetition;
  final Function goSettings;

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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(color: AppColors.colorAccent),
              child: Observer(builder: (_) {
                return controller.user.handleState(() {
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
                            ? ClipRRect(borderRadius: BorderRadius.circular(30), child: Image.network(data.imageUrl))
                            : Icon(Icons.person, size: 32),
                      ),
                      const SizedBox(height: 14),
                      Text("Olá, ${data.name}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("${LevelControl.getLevelText(data.score)}",
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300)),
                    ],
                  );
                }, (error) {
                  return SizedBox();
                });
              }),
            ),
            ListTile(
              title: Text('Amigos', style: const TextStyle(fontSize: 16)),
              leading: Icon(Icons.people, color: Colors.black),
              trailing: UserControl().getPendingFriendsStatus()
                  ? Container(
                      width: 10,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.colorAccent),
                    )
                  : const SizedBox(),
              onTap: goFriends,
            ),
            ListTile(
              title: Text('Competição', style: const TextStyle(fontSize: 16)),
              leading: Image.asset("assets/ic_award.png", width: 25, color: Colors.black),
              trailing: CompetitionsControl().getPendingCompetitionsStatus()
                  ? Container(
                      width: 10,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.colorAccent),
                    )
                  : const SizedBox(),
              onTap: goCompetition,
            ),
            ListTile(
              title: Text('Configurações', style: const TextStyle(fontSize: 16)),
              leading: Icon(Icons.settings, color: Colors.black),
              onTap: goSettings,
            ),
            ListTile(
              title: Text('Avalie o app', style: const TextStyle(fontSize: 16)),
              leading: Icon(Icons.star, color: Colors.black),
              onTap: () => goRateApp(context),
            ),
          ],
        ),
      ),
    );
  }
}
