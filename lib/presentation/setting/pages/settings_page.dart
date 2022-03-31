import 'package:altitude/common/enums/theme_type.dart';
import 'package:altitude/common/view/Header.dart';
import 'package:altitude/common/view/dialog/BaseDialog.dart';
import 'package:altitude/common/inputs/validations/ValidationHandler.dart';
import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/presentation/setting/controllers/settings_controller.dart';
import 'package:altitude/presentation/tutorialPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState
    extends BaseStateWithController<SettingsPage, SettingsController> {
  TextEditingController _nameTextController = TextEditingController();

  @override
  initState() {
    super.initState();
    controller.fetchData().catchError(handleError);
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  void logout() {
    showSimpleDialog("Logout", "Tem certeza que deseja sair?",
        confirmCallback: () {
      showLoading(true);
      controller.logout().then((_) {
        showLoading(false);
        navigateRemoveUntil('login');
      }).catchError(handleError);
    });
  }

  void editName() async {
    _nameTextController.text = controller.name!;
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
        action: [
          TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop()),
          TextButton(
              child: const Text('Salvar',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onPressed: saveName)
        ],
      ),
    );
  }

  void saveName() async {
    String? result =
        ValidationHandler.nameTextValidate(_nameTextController.text);

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

  void recalculateScore() {
    showSimpleDialog("Pontuação", "Deseja recalcular sua pontuação?",
        confirmCallback: () {
      showLoading(true);
      controller.recalculateScore().then((_) {
        showLoading(false);
        navigatePop();
        showToast("Pontuação recalculada.");
      }).catchError(handleError);
    });
  }

  void setTheme() {
    showDialog(
      context: context,
      builder: (_) => BaseDialog(
        title: "Tema",
        body: Observer(builder: (_) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(ThemeType.LIGHT.themePrettyString),
                leading: Radio<ThemeType>(
                  value: ThemeType.LIGHT,
                  groupValue: controller.theme,
                  onChanged: (ThemeType? value) =>
                      controller.changeTheme(context, value),
                ),
                onTap: () => controller.changeTheme(context, ThemeType.LIGHT),
              ),
              ListTile(
                title: Text(ThemeType.DARK.themePrettyString),
                leading: Radio<ThemeType>(
                  value: ThemeType.DARK,
                  groupValue: controller.theme,
                  onChanged: (ThemeType? value) =>
                      controller.changeTheme(context, value),
                ),
                onTap: () => controller.changeTheme(context, ThemeType.DARK),
              ),
              ListTile(
                title: Text(ThemeType.SYSTEM.themePrettyString),
                leading: Radio<ThemeType>(
                  value: ThemeType.SYSTEM,
                  groupValue: controller.theme,
                  onChanged: (ThemeType? value) =>
                      controller.changeTheme(context, value),
                ),
                onTap: () => controller.changeTheme(context, ThemeType.SYSTEM),
              ),
            ],
          );
        }),
        action: [
          TextButton(
              child: const Text('Fechar'),
              onPressed: () => Navigator.of(context).pop())
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          const Header(title: "CONFIGURAÇÕES"),
          const SizedBox(height: 16),
          ListTile(
            title: const Text("Seu nome"),
            trailing: Observer(builder: (_) {
              return Text(controller.name!,
                  style: TextStyle(color: Colors.grey));
            }),
            onTap: editName,
          ),
          const Divider(),
          ListTile(
            title: const Text("Tema"),
            trailing: Observer(builder: (_) {
              return Text(controller.theme.themePrettyString,
                  style: TextStyle(color: Colors.grey));
            }),
            onTap: setTheme,
          ),
          const Divider(),
          ListTile(
            title: const Text("Rever tutorial inicial"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => TutorialPage(),
                      settings: RouteSettings(name: "Tutorial Page")));
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Ajuda"),
            onTap: () => navigatePush('help'),
          ),
          const Divider(),
          ListTile(
            title: const Text("Siga o Altitude no Instagram"),
            onTap: () async {
              const INSTAGRAM_URL = 'https://www.instagram.com/sejaaltitude';
              if (await canLaunch(INSTAGRAM_URL)) {
                await launch(INSTAGRAM_URL);
              } else {
                throw 'Could not launch $INSTAGRAM_URL';
              }
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Minha pontuação está errada"),
            onTap: recalculateScore,
          ),
          const Divider(),
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
