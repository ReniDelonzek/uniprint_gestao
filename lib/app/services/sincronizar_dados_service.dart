import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hive/hive.dart';
import 'package:uniprintgestao/app/shared/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/app/shared/api/querys.dart';
import 'package:uniprintgestao/app/shared/graph/tipo_folha.dart';
import 'package:uniprintgestao/app/shared/services/utils_hive_service.dart';
import 'package:uniprintgestao/app/shared/utils/utils_sentry.dart';

import '../app_module.dart';

class SincronizarDadosService extends Disposable {
  static bool sincronizando =
      false; //garantir que a funcao não execute varias vezes simultaneamente
  static SincronizarDadosService _instance;

  factory SincronizarDadosService() {
    _instance ??= SincronizarDadosService._internalConstructor();
    return _instance;
  }

  SincronizarDadosService._internalConstructor();

  FutureOr<void> sincronizar(String s) async {
    if (!sincronizando) {
      sincronizando = true;
      var res = await buscarDadosServidor();
      await salvarDados(res);
      dispose();
    }
  }

  Future buscarDadosServidor() async {
    return await GraphQlObject.hasuraConnect.query(Querys.getSincronizacao);
  }

  Future<bool> salvarDados(var res) async {
    try {
      if (res != null) {
        for (var map in res['data']['tipo_folha']) {
          TipoFolha valor = TipoFolha.fromMap(map);
          Box box = await AppModule.to
              .getDependency<HiveService>()
              .getBox('tipo_folha');
          await box.put(valor.id, valor);
        }
      }
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    sincronizando = false;
  }
}
