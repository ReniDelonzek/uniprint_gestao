import 'package:firedart/firedart.dart';
import 'package:hive/hive.dart';
import 'package:uniprintgestao/src/app_module.dart';
import 'package:uniprintgestao/src/services/utils_hive_service.dart';

class PreferencesStore extends TokenStore {
  static const user = "user_id";
  static const keyToken = "auth_token";
  static const idTokenKey = "id_token";
  static const refreshTokenKey = "refresh_token";
  static const expiryTokenKey = "expiry_token";

  static Future<PreferencesStore> create() async {
    return PreferencesStore._internal(
        await AppModule.to.getDependency<HiveService>().getBox('token_box'));
  }

  Box box;
  PreferencesStore._internal(this.box);

  @override
  Token read() {
    Token token = Token(
        box.get(user),
        box.get(idTokenKey),
        box.get(refreshTokenKey), //DateTime.now()
        DateTime.tryParse(box.get(expiryTokenKey,
                defaultValue: DateTime.now().toIso8601String())) ??
            DateTime.now());

    return token;
  }

  @override
  Future write(Token token) async {
    await box.put(idTokenKey, token.toMap()['idToken']);
    await box.put(expiryTokenKey, token.toMap()['expiry']);
    await box.put(refreshTokenKey, token.toMap()['refreshToken'].toString());
    await box.put(user, token.toMap()['_userId'].toString());
  }

  @override
  void delete() {
    box.delete(idTokenKey);
    box.delete(expiryTokenKey);
    box.delete(refreshTokenKey);
  }
}
