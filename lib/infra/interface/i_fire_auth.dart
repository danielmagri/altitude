abstract class IFireAuth {
  bool isLogged();

  String getUid();

  String? getName();

  Future<bool> setName(String name);

  String? getEmail();

  String? getPhotoUrl();

  Future<void> logout();
}
