enum FrequencyType { DAYWEEK, WEEKLY }

extension FrequencyTypeExtension on FrequencyType {
  String? get title {
    switch (this) {
      case FrequencyType.DAYWEEK:
        return 'Diariamente';
      case FrequencyType.WEEKLY:
        return 'Semanalmente';
      default:
        return null;
    }
  }

  String? get exampleText {
    switch (this) {
      case FrequencyType.DAYWEEK:
        return 'Ex. Segunda, Quarta e Sexta';
      case FrequencyType.WEEKLY:
        return 'Ex. 3 vezes por semana';
      default:
        return null;
    }
  }
}
