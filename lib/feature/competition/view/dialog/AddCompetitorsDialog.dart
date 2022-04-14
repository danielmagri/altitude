import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/view/dialog/BaseDialog.dart';
import 'package:altitude/core/base/BaseState.dart';
import 'package:flutter/material.dart'
    show
        BouncingScrollPhysics,
        ChoiceChip,
        Container,
        EdgeInsets,
        FontWeight,
        Key,
        SingleChildScrollView,
        StatefulWidget,
        Text,
        TextButton,
        TextStyle,
        Widget,
        Wrap,
        WrapAlignment,
        required;
import 'package:get_it/get_it.dart';

class AddCompetitorsDialog extends StatefulWidget {
  AddCompetitorsDialog({Key key, @required this.id, @required this.friends, @required this.competitors})
      : super(key: key);

  final String id;
  final List<Person> friends;
  final List<String> competitors;

  @override
  _AddCompetitorsDialogState createState() => _AddCompetitorsDialogState();
}

class _AddCompetitorsDialogState extends BaseState<AddCompetitorsDialog> {
  final CompetitionUseCase _competitionUseCase = GetIt.I.get<CompetitionUseCase>();

  List<Person> selectedFriends = [];

  void _addCompetitors() async {
    if (selectedFriends.isNotEmpty) {
      List<String> invitations = selectedFriends.map((person) => person.uid).toList();
      List<String> invitationsToken = selectedFriends.map((person) => person.fcmToken).toList();

      showLoading(true);

      _competitionUseCase.inviteCompetitor(widget.id, invitations, invitationsToken).then((res) {
        showLoading(false);
        navigatePop();
        showToast("Convite enviado!");
      }).catchError((error) {
        handleError(error);
        navigatePop();
      });
    }
  }

  @override
  Widget build(_) {
    return BaseDialog(
      title: 'Adicionar amigos',
      body: Container(
        margin: const EdgeInsets.only(right: 8, left: 8),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            runSpacing: 6,
            spacing: 10,
            alignment: WrapAlignment.center,
            children: widget.friends.map((friend) {
              return ChoiceChip(
                label: Text(friend.name),
                selected: selectedFriends.contains(friend),
                selectedColor: AppTheme.of(context).chipSelected,
                onSelected: widget.competitors.contains(friend.uid)
                    ? null
                    : (selected) {
                        setState(() {
                          selected ? selectedFriends.add(friend) : selectedFriends.remove(friend);
                        });
                      },
              );
            }).toList(),
          ),
        ),
      ),
      action: <Widget>[
        TextButton(child: const Text('Cancelar'), onPressed: navigatePop),
        TextButton(
            child: const Text('Adicionar', style: TextStyle(fontWeight: FontWeight.bold)), onPressed: _addCompetitors)
      ],
    );
  }
}
