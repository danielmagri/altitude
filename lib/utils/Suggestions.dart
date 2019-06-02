import 'package:habit/utils/enums.dart';

abstract class Suggestions {
  static const List<Map> physicalHabits = [
    {0: 0xeb43, 1: "Ir na academia"},
    {0: 0xe92c, 1: "Fazer alongamento"},
    {0: 0xeb48, 1: "Natação"},
    {0: 0xe566, 1: "Correr"},
    {0: 0xe028, 1: "teste"},
    {0: 0xe028, 1: "teste"},
    {0: 0xe028, 1: "teste"},
  ];

  static const List<Map> mentalHabits = [
    {0: 0xe3f7, 1: "Meditar"},
    {0: 0xe865, 1: "Ler"},
    {0: 0xe80c, 1: "Estudar inglês"},
    {0: 0xe028, 1: "teste"},
    {0: 0xe028, 1: "teste"},
    {0: 0xe028, 1: "teste"},
    {0: 0xe028, 1: "teste"},
  ];

  static const List<Map> socialHabits = [
    {0: 0xe028, 1: "teste"},
    {0: 0xe028, 1: "teste"},
    {0: 0xe028, 1: "teste"},
    {0: 0xe028, 1: "teste"},
    {0: 0xe028, 1: "teste"},
    {0: 0xe028, 1: "teste"},
    {0: 0xe028, 1: "teste"},
  ];

  static List getHabits(CategoryEnum category) {
    switch (category) {
      case CategoryEnum.PHYSICAL:
        return physicalHabits;
      case CategoryEnum.MENTAL:
        return mentalHabits;
      case CategoryEnum.SOCIAL:
        return socialHabits;
    }
    return [];
  }

  static const List physicalCues = [
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
  ];

  static const List mentalCues = [
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
  ];

  static const List socialCues = [
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
  ];

  static List getCues(CategoryEnum category) {
    switch (category) {
      case CategoryEnum.PHYSICAL:
        return physicalCues;
      case CategoryEnum.MENTAL:
        return mentalCues;
      case CategoryEnum.SOCIAL:
        return socialCues;
    }
    return [];
  }
}
