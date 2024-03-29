import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/common/enums/theme_type.dart';
import 'package:altitude/common/inputs/validations/validation_handler.dart';
import 'package:altitude/common/view/dialog/base_dialog.dart';
import 'package:altitude/common/view/header.dart';
import 'package:altitude/presentation/setting/controllers/settings_controller.dart';
import 'package:altitude/presentation/tutorial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState
    extends BaseStateWithController<SettingsPage, SettingsController> {
  final TextEditingController _nameTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.fetchData().catchError(handleError);
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  void logout() {
    showSimpleDialog(
      'Logout',
      'Tem certeza que deseja sair?',
      confirmCallback: () {
        showLoading(true);
        controller.logout().then((_) {
          showLoading(false);
          navigateRemoveUntil('login');
        }).catchError(handleError);
      },
    );
  }

  Future<void> editName() async {
    _nameTextController.text = controller.name!;
    showDialog(
      context: context,
      builder: (_) => BaseDialog(
        title: 'Seu nome',
        body: TextField(
          controller: _nameTextController,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          onEditingComplete: saveName,
        ),
        action: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text(
              'Salvar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: saveName,
          )
        ],
      ),
    );
  }

  Future<void> saveName() async {
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
    showSimpleDialog(
      'Pontuação',
      'Deseja recalcular sua pontuação?',
      confirmCallback: () {
        showLoading(true);
        controller.recalculateScore().then((_) {
          showLoading(false);
          navigatePop();
          showToast('Pontuação recalculada.');
        }).catchError(handleError);
      },
    );
  }

  void setTheme() {
    showDialog(
      context: context,
      builder: (_) => BaseDialog(
        title: 'Tema',
        body: Observer(
          builder: (_) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(ThemeType.light.themePrettyString),
                  leading: Radio<ThemeType>(
                    value: ThemeType.light,
                    groupValue: controller.theme,
                    onChanged: (value) =>
                        controller.changeTheme(context, value),
                  ),
                  onTap: () => controller.changeTheme(context, ThemeType.light),
                ),
                ListTile(
                  title: Text(ThemeType.dark.themePrettyString),
                  leading: Radio<ThemeType>(
                    value: ThemeType.dark,
                    groupValue: controller.theme,
                    onChanged: (value) =>
                        controller.changeTheme(context, value),
                  ),
                  onTap: () => controller.changeTheme(context, ThemeType.dark),
                ),
                ListTile(
                  title: Text(ThemeType.system.themePrettyString),
                  leading: Radio<ThemeType>(
                    value: ThemeType.system,
                    groupValue: controller.theme,
                    onChanged: (value) =>
                        controller.changeTheme(context, value),
                  ),
                  onTap: () =>
                      controller.changeTheme(context, ThemeType.system),
                ),
              ],
            );
          },
        ),
        action: [
          TextButton(
            child: const Text('Fechar'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const Header(title: 'CONFIGURAÇÕES'),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Seu nome'),
              trailing: Observer(
                builder: (_) {
                  return Text(
                    controller.name!,
                    style: const TextStyle(color: Colors.grey),
                  );
                },
              ),
              onTap: editName,
            ),
            const Divider(),
            ListTile(
              title: const Text('Tema'),
              trailing: Observer(
                builder: (_) {
                  return Text(
                    controller.theme.themePrettyString,
                    style: const TextStyle(color: Colors.grey),
                  );
                },
              ),
              onTap: setTheme,
            ),
            const Divider(),
            ListTile(
              title: const Text('Rever tutorial inicial'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TutorialPage(),
                    settings: const RouteSettings(name: 'Tutorial Page'),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Ajuda'),
              onTap: () => navigatePush('help'),
            ),
            const Divider(),
            ListTile(
              title: const Text('Siga o Altitude no Instagram'),
              onTap: () async {
                const instagramUrl = 'https://www.instagram.com/sejaaltitude';
                if (await canLaunch(instagramUrl)) {
                  await launch(instagramUrl);
                } else {
                  throw 'Could not launch $instagramUrl';
                }
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Minha pontuação está errada'),
              onTap: recalculateScore,
            ),
            const Divider(),
            Observer(
              builder: (_) {
                return ListTile(
                  title: const Text('Logout'),
                  enabled: controller.isLogged,
                  onTap: logout,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
