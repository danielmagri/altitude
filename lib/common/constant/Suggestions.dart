abstract class Suggestions {
  static const List<String> _habits = [
    'Ler',
    'Ir na academia',
    'Estudar inglês',
    'Correr',
    'Meditar',
    'Fazer alongamento',
    'Acordar cedo',
    'Caminhar',
    'Beber água',
    'Arrumar a cama',
    'Yoga',
    'Natação',
  ];

  static List<String> getHabits() {
    return _habits;
  }

  static const List<String> _cues = [
    'Colocar livro ao lado da cama',
    'Deixar roupa do exercício do lado da cama',
    'Arrumar tapete do alongamento',
    'Levar roupa do exercício para o trabalho',
    'Deixar garrafa em cima da mesa',
    'Levar livro para o trabalho',
    'Deixar o óculos de leitura por perto',
    'Colocar uma música',
  ];

  static List<String> getCues() {
    return _cues;
  }
}
