abstract class Suggestions {
  static const List<String> _habits = [
    "Ler",
    "Ir na academia",
    "Estudar inglês",
    "Correr",
    "Meditar",
    "Fazer alongamento",
    "Acordar cedo",
    "Caminhar",
    "Beber água",
    "Arrumar a cama",
    "Yoga",
    "Natação",
  ];

  static List<String> getHabits() {
    return _habits;
  }

  static const List _cues = [
    "Colocar livro ao lado da cama",
    "Deixar roupa do exercício do lado da cama",
    "Deixar garrafa em cima da mesa",
    "Levar roupa do exercício para o trabalho",
    "Levar livro para o trabalho",
    "Deixar o óculos de leitura por perto",
    "Arrumar tapete do alongamento",
    "Colocar uma música",
  ];

  static List getCues() {
    return _cues;
  }
}
