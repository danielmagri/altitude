import 'package:habit/utils/enums.dart';

abstract class Suggestions {
  static const List physicalRewards = [
    "Emagrecer _kg",
    "Ganhar _kg",
    "Atingir _km a pé",
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
  ];

  static const List mentalRewards = [
    "Ler _ livros no ano",
    "Encontar a paz na meditação",
    "Aprender outro idioma",
  ];

  static const List socialRewards = [
    "Conversar com alguém novo todos os dias",
    "Sair com alguém diferente toda semana",
    "Conhecer um lugar novo",
  ];

  static List getRewards(Category category) {
    switch (category) {
      case Category.PHYSICAL:
        return physicalRewards;
      case Category.MENTAL:
        return mentalRewards;
      case Category.SOCIAL:
        return socialRewards;
    }
    return [];
  }

  static const List physicalHabits = [
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
  ];

  static const List mentalHabits = [
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
  ];

  static const List socialHabits = [
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
    "teste",
  ];

  static List getHabits(Category category) {
    switch (category) {
      case Category.PHYSICAL:
        return physicalHabits;
      case Category.MENTAL:
        return mentalHabits;
      case Category.SOCIAL:
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

  static List getCues(Category category) {
    switch (category) {
      case Category.PHYSICAL:
        return physicalCues;
      case Category.MENTAL:
        return mentalCues;
      case Category.SOCIAL:
        return socialCues;
    }
    return [];
  }
}