import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uniprintgestao/app/app_module.dart';
import 'package:uniprintgestao/app/shared/db/usuario.dart';
import 'package:uniprintgestao/app/shared/services/utils_hive_service.dart';

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
          obterDadosFirebase(uid, onChanged);
        }
      } else {
        obterDadosFirebase(uid, onChanged);
      }
    } else {
      onChanged(usuario);
    }
  }

  @override
  void dispose() {}

  void obterDadosFirebase(String uid, onChanged) {
    var l = Firestore.instance.collection('Usuarios').document(uid).stream;
    l.listen((event) async {
      if (event != null) {
        if ((event.map?.containsKey('hasura_id') ?? false) &&
            (event.map?.containsKey('ponto_id') ?? false) &&
            (event.map?.containsKey('atendente_id') ?? false)) {
          if (usuario == null) {
            usuario = UsuarioHasura();
          }
          usuario.codHasura = event.map['hasura_id'];
          usuario.codAtendente = event.map['atendente_id'];
          usuario.codPontoAtendimento = event.map['ponto_id'];
          completer.future.then((box) {
            box.put('usuario', usuario);
            onChanged(usuario);
          }).catchError((error) {
            print(error);
            onChanged(null);
          });
        } else {
          onChanged(null);
        }
      } else {
        onChanged(null);
      }
    });
  }
}
