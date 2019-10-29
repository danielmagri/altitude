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

  static String competitionNameValidate(String text) {
    String treatedText = text.trim();
    if (treatedText.isEmpty) {
      return "Por favor preencha o nome.";
    } else if (treatedText.length < 3) {
      return "O nome precisa ser maior que 3 letras.";
    } else if (treatedText.length > 30) {
      return "O nome pode ter no máximo 30 caracteres.";
    }

    return null;
  }
}
