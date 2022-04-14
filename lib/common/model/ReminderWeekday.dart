import 'package:mobx/mobx.dart';
part 'ReminderWeekday.g.dart';

class ReminderWeekday = _ReminderWeekdayBase with _$ReminderWeekday;

abstract class _ReminderWeekdayBase with Store {
  _ReminderWeekdayBase(this.id, this.title, this.state);

  final int id;
  final String title;

  @observable
  bool state;
}
