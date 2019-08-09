abstract class Validate {
  static String nameTextValidate(String text) {
    String treatedText = text.trim();
    if (treatedText.isEmpty) {
      return "Por favor preencha o campo.";
    } else if (treatedText.length < 3) {
      return "O nome ser maior que 3 letras.";
    } else if (treatedText.length > 20) {
      return "O nome pode ter no máximo 20 caracteres.";
    }

    return null;
  }

  static String cueTextValidate(String text) {
    String treatedText = text.trim();
    if (treatedText.isEmpty) {
      return "Por favor preencha o campo.";
    } else if (treatedText.length < 3) {
      return "A deixa precisa ser maior que 3 letras.";
    } else if (treatedText.length > 45) {
      return "A deixa pode ter no máximo 45 caracteres.";
    }

    return null;
  }

  static String habitTextValidate(String text) {
    String treatedText = text.trim();
    if (treatedText.isEmpty) {
      return "Por favor preencha o campo.";
    } else if (treatedText.length < 3) {
      return "O hábito precisa ser maior que 3 letras.";
    } else if (treatedText.length > 30) {
      return "O hábito pode ter no máximo 30 caracteres.";
    }

    return null;
  }

  static String rewardTextValidate(String text) {
    String treatedText = text.trim();
    if (treatedText.isEmpty) {
      return "Por favor preencha o campo.";
    } else if (treatedText.length < 3) {
      return "A meta precisa ser maior que 3 letras.";
    } else if (treatedText.length > 40) {
      return "A meta pode ter no máximo 40 caracteres.";
    }

    return null;
  }

  static String progressNumericTextValidate(String text) {
    double number = double.tryParse(text);

    if (text.contains(",")) {
      return "O número do dia não pode conter vírgula.";
    } else if (number == null) {
      return "Preencha a quantidade.";
    } else if (number < 1) {
      return "O número precisa ser maior que 0.";
    }

    return null;
  }

  static String progressDayTextValidate(String text) {
    int number = int.tryParse(text);

    if (text.contains(",") || text.contains(".")) {
      return "O número do dia não pode conter vírgula ou ponto.";
    } else if (number == null) {
      return "Preencha a quantidade.";
    } else if (number < 1) {
      return "O número precisa ser maior que 0.";
    }

    return null;
  }
}
