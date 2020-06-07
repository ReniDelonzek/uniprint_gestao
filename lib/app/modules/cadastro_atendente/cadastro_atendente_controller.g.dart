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
    _$userAtom.context.enforceReadPolicy(_$userAtom);
    _$userAtom.reportObserved();
    return super.user;
  }

  @override
  set user(Usuario value) {
    _$userAtom.context.conditionallyRunInAction(() {
      super.user = value;
      _$userAtom.reportChanged();
    }, _$userAtom, name: '${_$userAtom.name}_set');
  }

  final _$localAtom = Atom(name: '_CadastroAtendenteBase.local');

  @override
  PontoAtendimento get local {
    _$localAtom.context.enforceReadPolicy(_$localAtom);
    _$localAtom.reportObserved();
    return super.local;
  }

  @override
  set local(PontoAtendimento value) {
    _$localAtom.context.conditionallyRunInAction(() {
      super.local = value;
      _$localAtom.reportChanged();
    }, _$localAtom, name: '${_$localAtom.name}_set');
  }

  @override
  String toString() {
    final string = 'user: ${user.toString()},local: ${local.toString()}';
    return '{$string}';
  }
}
