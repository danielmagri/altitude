import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/ui/widgets/ClipShadowPath.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/utils/Validator.dart';

class HeaderBackgroundClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height);
    path.quadraticBezierTo(size.width / 2, size.height - 20, size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class EditHabitPage extends StatefulWidget {
  EditHabitPage({Key key, this.habit, this.frequency}) : super(key: key);

  final Habit habit;
  final dynamic frequency;

  @override
  _EditHabitPagePageState createState() => _EditHabitPagePageState();
}

class _EditHabitPagePageState extends State<EditHabitPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final rewardController = TextEditingController();
  final habitController = TextEditingController();
  final cueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    rewardController.text = widget.habit.reward;
    habitController.text = widget.habit.habit;
    cueController.text = widget.habit.cue;
  }

  @override
  void dispose() {
    rewardController.dispose();
    habitController.dispose();
    cueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ClipShadowPath(
                child: Container(
                  color: CategoryColors.getPrimaryColor(widget.habit.category),
                  padding: EdgeInsets.only(top: 20.0),
                  height: 90.0,
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      BackButton(color: Colors.white),
                      Text(
                        "Editar hábito",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text("Deletar"),
                                  content: new Text("Você deseja deletar permanentemente o hábito?\n(Todos o progresso dele será perdido)"),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text("Sim"),
                                      onPressed: () {
                                        DataControl().deleteHabit(widget.habit.id).then((status) {
                                          Navigator.of(context).popUntil((route) => route.isFirst);
                                        });
                                      },
                                    ),
                                    new FlatButton(
                                      child: new Text("Não"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                    ],
                  ),
                ),
                clipper: HeaderBackgroundClip(),
                shadow: Shadow(blurRadius: 5, color: Colors.grey[500], offset: Offset(0.0, 1)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: rewardController,
                  validator: Validate.rewardTextValidate,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: "Escreva aqui",
                    filled: true,
                    labelText: "Meta",
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: habitController,
                  validator: Validate.habitTextValidate,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: "Escreva aqui",
                    filled: true,
                    labelText: "Hábito",
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: cueController,
                  validator: Validate.cueTextValidate,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: "Escreva aqui",
                    filled: true,
                    labelText: "Deixa",
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Habit newHabit = new Habit(
                id: widget.habit.id,
                cue: cueController.text,
                habit: habitController.text,
                reward: rewardController.text,
                category: widget.habit.category);

            DataControl().updateHabit(newHabit).then((status) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text("Sucesso"),
                    content: new Text("A edição foi realizada!"),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              ).then((res) => Navigator.of(context).pop());
            });
          }
        },
        tooltip: 'Salvar',
        backgroundColor: CategoryColors.getPrimaryColor(widget.habit.category),
        icon: Icon(Icons.save),
        label: Text("Salvar"),
      ),
    );
  }
}
