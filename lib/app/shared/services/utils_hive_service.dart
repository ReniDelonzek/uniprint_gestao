import 'dart:async';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hive/hive.dart';
import 'package:uniprintgestao/app/shared/db/tipo_folha.dart';
import 'package:uniprintgestao/app/shared/db/usuario.dart';
import 'package:uniprintgestao/app/shared/utils/utils_platform.dart';

class HiveService extends Disposable {
  Completer<bool> completer = Completer();

  HiveService() {
    _init();
  }

  _init() async {
    if (UtilsPlatform.isMobile()) {
      await Hive.initFlutter();
    } else if (UtilsPlatform.isDesktop()) {
      Hive.init(Directory.current.path + '/.hivedb');
    }
    Hive.registerAdapter(UsuarioHasuraAdapter());
    Hive.registerAdapter(TipoFolhaAdapter());
    completer.complete(true);
  }

  Future<Box> getBox(String name) async {
    if (!completer.isCompleted) {
      await completer.future;
    }
    return Hive.isBoxOpen(name) ? Hive.box(name) : (await Hive.openBox(name));
  }

  @override
  Future<void> dispose() async {
    await Hive.close();
  }
}
