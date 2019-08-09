abstract class Suggestions {
  static const List _habits = [
    "Ir na academia",
    "Ler",
    "Estudar inglês",
    "Natação",
    "Correr",
    "Meditar",
    "Fazer alongamento",
  ];

  static List getHabits() {
    return _habits;
  }

  static const List _cues = [
    "Deixar roupa do exercício do lado da cama",
    "Colocar livro ao lado da cama",
    "Levar roupa do exercício para o trabalho",
    "Deixar o óculos de leitura por perto",
    "Arrumar tapete do alongamento",
    "Colocar uma música",
  ];

  static List getCues() {
    return _cues;
  }
}
