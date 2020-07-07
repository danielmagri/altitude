import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/feature/home/logic/HomeLogic.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart'
    show
        Alignment,
        BorderRadius,
        BoxDecoration,
        BoxShape,
        BuildContext,
        ClipRRect,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        Divider,
        Drawer,
        EdgeInsets,
        Expanded,
        FontWeight,
        Icon,
        Icons,
        Image,
        Key,
        ListTile,
        ListView,
        MainAxisAlignment,
        MediaQuery,
        Navigator,
        Row,
        Size,
        SizedBox,
        StatelessWidget,
        Text,
        TextOverflow,
        TextStyle,
        Widget,
        required;

class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key key, @required this.goFriends, @required this.goLearn, @required this.goCompetition, @required this.goSettings})
      : controller = GetIt.I.get<HomeLogic>(),
        super(key: key);

  final HomeLogic controller;
  final Function goFriends;
  final Function(bool) goCompetition;
  final Function goLearn;
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
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 10),
              decoration: BoxDecoration(color: AppColors.colorAccent),
              child: Observer(builder: (_) {
                return controller.user.handleState(() {
                  return Skeleton.custom(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Row(children: [
                          Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Container(
                                  width: double.maxFinite,
                                  height: 20,
                                  margin: const EdgeInsets.only(right: 64),
                                  decoration:
                                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15))),
                              const SizedBox(height: 2),
                              Container(
                                  width: double.maxFinite,
                                  height: 14,
                                  decoration:
                                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)))
                            ]),
                          )
                        ]),
                        const SizedBox(height: 12),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Container(
                              width: 120,
                              height: 16,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15))),
                          const SizedBox(width: 4),
                          Rocket(size: const Size(25, 25), color: Colors.white, isExtend: true),
                        ]),
                      ],
                    ),
                  );
                }, (data) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                          alignment: Alignment.center,
                          child: data.imageUrl.isNotEmpty
                              ? ClipRRect(borderRadius: BorderRadius.circular(30), child: Image.network(data.imageUrl))
                              : const Icon(Icons.person, size: 32),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("Olá, ${data.name}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                              "${data.email}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ]),
                        )
                      ]),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text("${LevelControl.getLevelText(data.score)}",
                            style: const TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(width: 4),
                        Image.asset(LevelControl.getLevelImagePath(data.score), height: 25, width: 25),
                      ]),
                    ],
                  );
                }, (error) {
                  return const SizedBox();
                });
              }),
            ),
            ListTile(
              title: const Text('Competição', style: TextStyle(fontSize: 16)),
              leading: Image.asset("assets/ic_award.png", width: 25, color: Colors.black),
              trailing: controller.pendingCompetitionStatus
                  ? Container(width: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.orange))
                  : const SizedBox(),
              onTap: () => goCompetition(true),
            ),
            ListTile(
              title: const Text('Amigos', style: const TextStyle(fontSize: 16)),
              leading: const Icon(Icons.people, color: Colors.black),
              trailing: controller.pendingFriendStatus
                  ? Container(width: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.orange))
                  : const SizedBox(),
              onTap: goFriends,
            ),
            Divider(),
            ListTile(
              title: const Text('Altitude Learn', style: const TextStyle(fontSize: 16)),
              leading: const Icon(Icons.local_library, color: Colors.black),
              trailing: controller.pendingLearnStatus
                  ? Container(width: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.orange))
                  : const SizedBox(),
              onTap: goLearn,
            ),
            Divider(),
            ListTile(
              title: const Text('Avalie o app', style: TextStyle(fontSize: 16)),
              leading: const Icon(Icons.star, color: Colors.black),
              onTap: () => goRateApp(context),
            ),
            ListTile(
              title: const Text('Configurações', style: TextStyle(fontSize: 16)),
              leading: const Icon(Icons.settings, color: Colors.black),
              onTap: goSettings,
            ),
          ],
        ),
      ),
    );
  }
}
