import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:hive/hive.dart';

class PreferencesStore extends TokenStore {
  static const keyToken = "auth_token";
  static const idTokenKey = "id_token";
  static const refreshTokenKey = "refresh_token";
  static const expiryTokenKey = "expiry_token";

  static Future<PreferencesStore> create() async {
    Hive.init(Directory.current.path);
    return PreferencesStore._internal(await Hive.openBox('tokenBox'));
  }

  //PreferencesStore._internal(await SharedPreferences.getInstance());

  Box box;

  //PreferencesStore._internal(this._prefs);
  PreferencesStore._internal(this.box);

  @override
  Token read() {
    Token token = Token(
        box.get(idTokenKey),
        box.get(refreshTokenKey),
        DateTime.tryParse(
            box.get(expiryTokenKey, defaultValue: DateTime.now())));

    //box.get(keyToken);
    return token;
  }

  /*_prefs.containsKey(keyToken)
  ? Token.fromMap(json.decode(_prefs.get(keyToken)))
      : null;*/

  @override
  void write(Token token) {
    box.put(idTokenKey, token.toMap()['idToken']);
    box.put(expiryTokenKey, token.toMap()['expiry']);
    box.put(refreshTokenKey, token.toMap()['refreshToken']);
    //box.put(keyToken, token);
  }

  //_prefs.setString(keyToken, json.encode(token.toMap()));

  @override
  void delete() {
    box.delete(idTokenKey);
    box.delete(expiryTokenKey);
    box.delete(refreshTokenKey);
  } //_prefs.remove(keyToken);
}
