import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:habit/controllers/UserControl.dart';
import 'package:habit/services/SharedPref.dart';
import 'package:habit/ui/helpPage.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';
import 'package:habit/utils/Validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit/ui/tutorialPage.dart';

import 'dialogs/BaseDialog.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _nameTextController = TextEditingController();

  String name = "";
  bool logged = false;

  @override
  initState() {
    super.initState();

    UserControl().getName().then((name) {
      setState(() {
        this.name = name;
      });
    });

    UserControl().isLogged().then((status) {
      setState(() {
        this.logged = status;
      });
    });
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  void saveName() async {
    String result = Validate.nameTextValidate(_nameTextController.text);

    if (result == null) {
      Loading.showLoading(context);
      if (!await UserControl().setName(_nameTextController.text)) {
        showToast("Ocorreu um erro");
      } else {
        setState(() {
          name = _nameTextController.text;
        });
      }

      Loading.closeLoading(context);
      Navigator.of(context).pop();
    } else {
      showToast(result);
    }
  }

  void _logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BaseDialog(
          title: "Logout",
          body: "Tem certeza que deseja sair?",
          subBody: "Você não vai poder mais competir com seus amigos..",
          action: <Widget>[
            new FlatButton(
              child: new Text(
                "SIM",
                style: TextStyle(fontSize: 17),
              ),
              onPressed: () async {
                Loading.showLoading(context);
                await UserControl().logout();
                Loading.closeLoading(context);
                Navigator.pop(context);
                setState(() {
                  logged = false;
                });
              },
            ),
            new FlatButton(
              child: new Text(
                "NÃO",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _showNameDialog(BuildContext context) async {
    _nameTextController.text = name;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Seu nome'),
            content: TextField(
              controller: _nameTextController,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              onEditingComplete: saveName,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text(
                  'SALVAR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: saveName,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 16),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: BackButton(),
                ),
                Spacer(),
                Text(
                  "CONFIGURAÇÕES",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                SizedBox(
                  width: 50,
                ),
              ],
            ),
          ),
          ListTile(
            title: Text("Seu nome"),
            trailing: Text(
              name,
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () => _showNameDialog(context),
          ),
          ListTile(
            title: Text("Logout"),
            enabled: logged,
            onTap: _logout,
          ),
          Divider(),
          ListTile(
            title: Text("Rever tutorial inicial"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return TutorialPage(
                  showNameTab: false,
                );
              }));
            },
          ),
          ListTile(
            title: Text("Ajuda"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return HelpPage();
              }));
            },
          ),
        ]),
      ),
    );
  }
}
