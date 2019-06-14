abstract class Suggestions {
  static const List<Map> _habits = [
    {0: 0xeb43, 1: "Ir na academia"},
    {0: 0xe865, 1: "Ler"},
    {0: 0xe80c, 1: "Estudar inglês"},
    {0: 0xeb48, 1: "Natação"},
    {0: 0xe566, 1: "Correr"},
    {0: 0xe3f7, 1: "Meditar"},
    {0: 0xe92c, 1: "Fazer alongamento"},
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
