// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastro_atendente_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastroAtendenteController on _CadastroAtendenteBase, Store {
  final _$userAtom = Atom(name: '_CadastroAtendenteBase.user');

  @override
  Usuario get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(Usuario value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$localAtom = Atom(name: '_CadastroAtendenteBase.local');

  @override
  PontoAtendimento get local {
    _$localAtom.reportRead();
    return super.local;
  }

  @override
  set local(PontoAtendimento value) {
    _$localAtom.reportWrite(value, super.local, () {
      super.local = value;
    });
  }

  @override
  String toString() {
    return '''
user: ${user},
local: ${local}
    ''';
  }
}
