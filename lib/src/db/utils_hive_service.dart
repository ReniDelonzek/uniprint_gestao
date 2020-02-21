import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hive/hive.dart';
import 'package:uniprintgestao/src/db/usuario.dart';

class UtilsHiveService extends Disposable {
  Completer<bool> completer = Completer();

  UtilsHiveService() {
    _init();
  }

  _init() async {
    Hive.init(Directory.current.path);
    Hive.registerAdapter(UsuarioHasuraAdapter());
    completer.complete(true);
  }

  Future<bool> inicializarHive() async {
    return await completer.future;
  }

  @override
  void dispose() {}
}
