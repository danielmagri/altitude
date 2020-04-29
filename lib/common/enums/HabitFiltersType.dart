enum HabitFiltersType { TODAY_HABITS, ALL_HABITS }

extension HabitFiltersTypeExtension on HabitFiltersType {
  String get title {
    switch (this) {
      case HabitFiltersType.TODAY_HABITS:
        return "Hábitos de hoje";
      case HabitFiltersType.ALL_HABITS:
        return "Todos os hábitos";
      default:
        return null;
    }
  }

  String get emptyMessage {
    switch (this) {
      case HabitFiltersType.TODAY_HABITS:
        return "Você não tem hábitos para hoje.";
      case HabitFiltersType.ALL_HABITS:
        return "Crie um novo hábito pelo botão \"+\" na tela principal.";
      default:
        return null;
    }
  }
}
