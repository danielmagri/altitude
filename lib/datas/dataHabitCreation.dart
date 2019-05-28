class DataHabitCreation {
  static final DataHabitCreation _singleton = new DataHabitCreation._internal();

  int icon;
  dynamic frequency;

  factory DataHabitCreation() {
    return _singleton;
  }

  DataHabitCreation._internal();

  void emptyData() {
    icon = 0xe028;
    frequency = null;
  }
}