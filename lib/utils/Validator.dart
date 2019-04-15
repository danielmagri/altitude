class Validator {

  bool cueTextValidate(String text) {
    String treatedText = text.trim();
    if(treatedText.isEmpty) {
      return false;
    } else if (treatedText.length < 3) {
      return false;
    } else if(treatedText.length > 24) {
      return false;
    }

    return true;
  }
}