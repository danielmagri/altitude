import 'package:altitude/common/view/dialog/BaseDialog.dart';
import 'package:altitude/common/view/dialog/BaseTextDialog.dart';
import 'package:altitude/common/view/generic/Toast.dart';
import 'package:altitude/core/handler/ValidationHandler.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/feature/setting/logic/SettingsLogic.dart';
import 'package:altitude/feature/tutorialPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends BaseState<SettingsPage> {
  SettingsLogic controller = GetIt.I.get<SettingsLogic>();

  TextEditingController _nameTextController = TextEditingController();

  @override
  initState() {
    super.initState();

    controller.fetchData().catchError(handleError);
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<SettingsLogic>();
    _nameTextController.dispose();
    super.dispose();
  }

  void logout() {
    showDialog(
      context: context,
      builder: (_) => BaseTextDialog(
        title: "Logout",
        body: "Tem certeza que deseja sair?",
        subBody: "Você não vai poder mais competir com seus amigos..",
        action: <Widget>[
          FlatButton(
            child: const Text("Sim", style: TextStyle(fontSize: 17)),
            onPressed: () async {
              showLoading(true);
              controller.logout().then((_) {
                showLoading(false);
                Navigator.pop(context);
              }).catchError(handleError);
            },
          ),
          FlatButton(
            child: const Text("Não", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void editName() async {
    _nameTextController.text = controller.name;
    showDialog(
      context: context,
      builder: (_) => BaseDialog(
        title: "Seu nome",
        body: TextField(
          controller: _nameTextController,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          onEditingComplete: saveName,
        ),
        action: <Widget>[
          FlatButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(context).pop()),
          FlatButton(
              child: const Text('Salvar', style: const TextStyle(fontWeight: FontWeight.bold)), onPressed: saveName)
        ],
      ),
    );
  }

  void saveName() async {
    String result = ValidationHandler.nameTextValidate(_nameTextController.text);

    if (result == null) {
      showLoading(true);
      controller.changeName(_nameTextController.text).then((_) {
        showLoading(false);
        navigatePop();
      }).catchError(handleError);
    } else {
      showToast(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 40, bottom: 16),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 50, child: BackButton()),
                const Spacer(),
                const Text("CONFIGURAÇÕES", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const Spacer(),
                const SizedBox(width: 50),
              ],
            ),
          ),
          ListTile(
            title: const Text("Seu nome"),
            trailing: Observer(builder: (_) {
              return Text(controller.name, style: TextStyle(color: Colors.grey));
            }),
            onTap: editName,
          ),
          const Divider(),
          ListTile(
            title: const Text("Rever tutorial inicial"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) {
                        return TutorialPage(
                          showNameTab: false,
                        );
                      },
                      settings: RouteSettings(name: "Tutorial Page")));
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Ajuda"),
            onTap: () => navigatePush('help'),
          ),
          Observer(builder: (_) {
            return ListTile(
              title: const Text("Logout"),
              enabled: controller.isLogged,
              onTap: logout,
            );
          }),
        ]),
      ),
    );
  }
}
