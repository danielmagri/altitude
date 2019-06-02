import 'package:flutter/material.dart';
import 'package:habit/controllers/DataPreferences.dart';
import 'package:habit/utils/Validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _nameTextController = TextEditingController();

  String name = "";

  @override
  initState() {
    super.initState();

    DataPreferences().getName().then((name) {
      setState(() {
        this.name = name;
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
      await DataPreferences().setName(_nameTextController.text);

      setState(() {
        name = _nameTextController.text;
      });
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(
          msg: result,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color.fromARGB(255, 220, 220, 220),
          textColor: Colors.black,
          fontSize: 16.0);
    }
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
      body: ListView(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            children: <Widget>[
              BackButton(),
              Text(
                "Configurações",
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 64,
        ),
        ListTile(
          title: Text("Seu nome"),
          trailing: Text(
            name,
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () => _showNameDialog(context),
        ),
        Divider(),
      ]),
    );
  }
}
