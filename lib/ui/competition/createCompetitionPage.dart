import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:habit/controllers/CompetitionsControl.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Person.dart';
import 'package:habit/ui/addHabit/addHabitPage.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/ui/widgets/generic/Rocket.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/utils/Constants.dart';
import 'package:habit/utils/Validator.dart';

class CreateCompetitionPage extends StatefulWidget {
  CreateCompetitionPage({Key key, @required this.habits, @required this.friends}) : super(key: key);

  final List<Habit> habits;
  final List<Person> friends;

  @override
  _CreateCompetitionPageState createState() => _CreateCompetitionPageState();
}

class _CreateCompetitionPageState extends State<CreateCompetitionPage> {
  Habit selectedHabit;
  List<Habit> habits;
  List<Person> selectedFriends = [];

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    habits = widget.habits;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _createCompetitionTap() async {
    if (Validate.competitionNameValidate(controller.text) != null) {
      showToast(Validate.competitionNameValidate(controller.text));
    } else if (selectedHabit == null) {
      showToast("Escolha um hábito para competir.");
    } else if (selectedFriends.length == 0) {
      showToast("Escolha pelo menos um amigo.");
    } else if ((await CompetitionsControl().listCompetitionsIds(selectedHabit.id)).length >=
        MAX_HABIT_COMPETITIONS) {
      showToast("O hábito já faz parte de $MAX_HABIT_COMPETITIONS competições.");
    } else {
      List<String> invitations = selectedFriends.map((person) => person.uid).toList();
      List<String> invitationsToken = selectedFriends.map((person) => person.fcmToken).toList();

      Loading.showLoading(context);
      CompetitionsControl()
          .createCompetition(controller.text, selectedHabit.id, invitations, invitationsToken)
          .then((state) {
        Loading.closeLoading(context);
        Navigator.pop(context);
      }).catchError((error) {
        Loading.closeLoading(context);

        if (error is CloudFunctionsException) {
          if (error.details == true) {
            showToast(error.message);
            return;
          }
        }
        showToast("Ocorreu um erro");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                    child: BackButton(),
                  ),
                  Spacer(),
                  Text(
                    "CRIAR COMPETIÇÃO",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 50,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
              ),
              child: Text(
                "Noma da competição",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 8),
              child: TextField(
                controller: controller,
                style: TextStyle(color: Colors.black, fontSize: 18.0),
                decoration: InputDecoration(
                  hintText: "Competição de ...",
                  hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
                top: 42,
              ),
              child: Text(
                "Escolha um hábito para competir",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
                top: 12,
              ),
              child: DropdownButton<Habit>(
                  value: selectedHabit,
                  isExpanded: true,
                  hint: Text("Escolher um hábito"),
                  items: habits.map((habit) {
                    return DropdownMenuItem(
                      value: habit,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Rocket(
                              size: Size(30, 30),
                              isExtend: true,
                              color: AppColors.habitsColor[habit.color]),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            habit.habit,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedHabit = value;
                    });
                  }),
            ),
            Container(
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
              ),
              alignment: Alignment.topCenter,
              child: FlatButton(
                color: AppColors.colorHabitMix,
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) {
                                return AddHabitPage(backTo: true);
                              },
                              settings: RouteSettings(name: "Add Habit Page")))
                      .then((habit) {
                    if (habit != null) {
                      setState(() {
                        habits.add(habit);
                        selectedHabit = habit;
                      });
                    }
                  });
                },
                child: Text(
                  "ou crie um novo",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
                top: 42,
              ),
              child: Text(
                "Convidar amigos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                right: 16,
                left: 16,
                top: 12,
              ),
              alignment: Alignment.topCenter,
              child: Wrap(
                runSpacing: 6,
                spacing: 10,
                alignment: WrapAlignment.center,
                children: widget.friends.map((friend) {
                  return ChoiceChip(
                    label: Text(
                      friend.name,
                      style: TextStyle(fontSize: 15),
                    ),
                    selected: selectedFriends.contains(friend),
                    selectedColor: AppColors.colorHabitMix,
                    onSelected: (selected) {
                      setState(() {
                        selected ? selectedFriends.add(friend) : selectedFriends.remove(friend);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 38, bottom: 28),
              alignment: Alignment.topCenter,
              child: RaisedButton(
                color: AppColors.colorHabitMix,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
                elevation: 5.0,
                onPressed: _createCompetitionTap,
                child: const Text(
                  "CRIAR",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
