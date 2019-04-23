abstract class Validate {
  static String cueTextValidate(String text) {
    String treatedText = text.trim();
    if (treatedText.isEmpty) {
      return "Por favor preencha o campo.";
    } else if (treatedText.length < 3) {
      return "A meta precisa ser maior que 3 letras.";
    } else if (treatedText.length > 25) {
      return "A meta pode ter no máximo 25 caracteres.";
    }

    return "";
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

    return "";
  }

  static String rewardTextValidate(String text) {
    String treatedText = text.trim();
    if (treatedText.isEmpty) {
      return "Por favor preencha o campo.";
    } else if (treatedText.length < 3) {
      return "A meta precisa ser maior que 3 letras.";
    } else if (treatedText.length > 25) {
      return "A meta pode ter no máximo 25 caracteres.";
    }

    return "";
  }
}
