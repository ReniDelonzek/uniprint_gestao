import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uniprintgestao/src/db/utils_hive_service.dart';

import '../app_module.dart';

class PreferencesStore extends TokenStore {
  static const user = "user_id";
  static const keyToken = "auth_token";
  static const idTokenKey = "id_token";
  static const refreshTokenKey = "refresh_token";
  static const expiryTokenKey = "expiry_token";

  static Future<PreferencesStore> create() async {
    /*if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      Hive.init(Directory.current.path);
    } else {
      Hive.init((await getApplicationDocumentsDirectory()).path);
    }()*/
    //if ()
    await AppModule.to.getDependency<UtilsHiveService>().inicializarHive();

    return PreferencesStore._internal(Hive.isBoxOpen('token_box') ? Hive.box('token_box') : (await Hive.openBox('token_box')));
  }

  //PreferencesStore._internal(await SharedPreferences.getInstance());

  Box box;

  //PreferencesStore._internal(this._prefs);
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
    box.put(refreshTokenKey, token.toMap()['refreshToken'].toString());
    box.put(user, token.toMap()['_userId'].toString());
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
