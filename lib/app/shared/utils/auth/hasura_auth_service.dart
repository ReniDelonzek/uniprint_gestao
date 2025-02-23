import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hive/hive.dart';
import 'package:uniprintgestao/app/app_module.dart';
import 'package:uniprintgestao/app/shared/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/app/shared/api/querys.dart';
import 'package:uniprintgestao/app/shared/db/usuario.dart';
import 'package:uniprintgestao/app/shared/services/utils_hive_service.dart';
import 'package:uniprintgestao/app/shared/utils/utils_sentry.dart';

class HasuraAuthService extends Disposable {
  UsuarioHasura usuario;
  Completer<Box> completer = Completer();

  HasuraAuthService() {
    _init();
  }

  _init() async {
    Box box =
        await AppModule.to.getDependency<HiveService>().getBox('hasura_user');
    completer.complete(box);
  }

  logOut() async {
    FirebaseAuth.instance.signOut();
    usuario = null;
    Box box = await completer.future;
    await box.clear();

    GraphQlObject.hasuraConnect
        .cleanCache()
        .then((value) => print('Cache limpo com sucesso'));
  }

  void obterDadosUsuario(
      String uid, ValueChanged<UsuarioHasura> onChanged) async {
    if (usuario == null) {
      Box box = await completer.future;
      if (box.containsKey('usuario')) {
        usuario = box.get('usuario');
        if (usuario.codPontoAtendimento != null &&
            usuario.codAtendente != null) {
          onChanged(usuario);
        } else {
          obterDadosHasura(uid, onChanged);
        }
      } else {
        obterDadosHasura(uid, onChanged);
      }
    } else {
      onChanged(usuario);
    }
  }

  @override
  void dispose() {
    completer.future?.then((value) => value.close());
  }

  void obterDadosHasura(String uid, onChanged) {
    GraphQlObject.hasuraConnect
        .query(Querys.getUsuarioUID, variables: {'uid': uid}).then((value) {
      if (validarRespostaQuery(value, 'usuario', podeSerVazia: false)) {
        try {
          Map data = value['data']['usuario'][0];
          if (usuario == null) {
            usuario = UsuarioHasura();
          }
          //Caso o usuario não seja atendente, a linha abaixo falhará
          usuario.codAtendente = data['atendente']['id'];
          usuario.codPontoAtendimento =
              data['atendente']['ponto_atendimento_id'];
          usuario.codHasura = data['id'];
          usuario.nomePontoAtendimento =
              data["atendente"]["ponto_atendimento"]["nome"];
          completer.future.then((box) {
            box.put('usuario', usuario);
            onChanged(usuario);
          }).catchError((error, stackTrace) {
            UtilsSentry.reportError(error, stackTrace);
            onChanged(null);
          });
        } catch (error, stackTrace) {
          UtilsSentry.reportError(error, stackTrace);
          onChanged(null);
        }
      } else {
        onChanged(null);
      }
    });
  }

  // void obterDadosFirebase(String uid, onChanged) {
  //   var l = Firestore.instance.collection('Usuarios').document(uid).stream;
  //   l.listen((event) async {
  //     if (event != null) {
  //       if ((event.map?.containsKey('hasura_id') ?? false) &&
  //           (event.map?.containsKey('ponto_id') ?? false) &&
  //           (event.map?.containsKey('atendente_id') ?? false)) {
  //         if (usuario == null) {
  //           usuario = UsuarioHasura();
  //         }
  //         usuario.codHasura = event.map['hasura_id'];
  //         usuario.codAtendente = event.map['atendente_id'];
  //         usuario.codPontoAtendimento = event.map['ponto_id'];
  //         completer.future.then((box) {
  //           box.put('usuario', usuario);
  //           onChanged(usuario);
  //         }).catchError((error) {
  //           print(error);
  //           onChanged(null);
  //         });
  //       } else {
  //         onChanged(null);
  //       }
  //     } else {
  //       onChanged(null);
  //     }
  //   });
  // }
}
