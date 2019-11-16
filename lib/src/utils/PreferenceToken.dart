import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:hive/hive.dart';

/// Stores tokens as preferences in Android and iOS.
/// Depends on the shared_preferences plugin: https://pub.dev/packages/shared_preferences
class PreferencesStore extends TokenStore {
  static const keyToken = "auth_token";

  static Future<PreferencesStore> create() async {
    Hive.init(Directory.current.path);
    return PreferencesStore._internal(await Hive.openBox('myBox'));
  }

  //PreferencesStore._internal(await SharedPreferences.getInstance());

  Box box;

  //PreferencesStore._internal(this._prefs);
  PreferencesStore._internal(this.box);

  @override
  Token read() => box.get(keyToken);

  /*_prefs.containsKey(keyToken)
  ? Token.fromMap(json.decode(_prefs.get(keyToken)))
      : null;*/

  @override
  void write(Token token) {
    box.put(keyToken, token);
  }

  //_prefs.setString(keyToken, json.encode(token.toMap()));

  @override
  void delete() => box.delete(keyToken); //_prefs.remove(keyToken);
}
