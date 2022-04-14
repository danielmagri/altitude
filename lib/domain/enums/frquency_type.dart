enum FrequencyType { dayweek, weekly }

extension FrequencyTypeExtension on FrequencyType {
  String? get title {
    switch (this) {
      case FrequencyType.dayweek:
        return 'Diariamente';
      case FrequencyType.weekly:
        return 'Semanalmente';
      default:
        return null;
    }
  }

  String? get exampleText {
    switch (this) {
      case FrequencyType.dayweek:
        return 'Ex. Segunda, Quarta e Sexta';
      case FrequencyType.weekly:
        return 'Ex. 3 vezes por semana';
      default:
        return null;
    }
  }
}
