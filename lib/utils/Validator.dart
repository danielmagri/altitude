abstract class Validate {
  static String cueTextValidate(String text) {
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

  static String habitTextValidate(String text) {
    String treatedText = text.trim();
    if (treatedText.isEmpty) {
      return "Por favor preencha o campo.";
    } else if (treatedText.length < 3) {
      return "A meta precisa ser maior que 3 letras.";
    } else if (treatedText.length > 25) {
      return "A meta pode ter no máximo 25 caracteres.";
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

    if (text.contains(",") || text.contains(".")) {
      return "O número do dia não pode conter virgula ou ponto.";
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
      return "O número do dia não pode conter virgula ou ponto.";
    } else if (number == null) {
      return "Preencha a quantidade.";
    } else if (number < 1) {
      return "O número precisa ser maior que 0.";
    }

    return null;
  }
}
