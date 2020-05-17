// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastro_professor_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastroProfessorController on _CadastroProfessorBase, Store {
  final _$userAtom = Atom(name: '_CadastroProfessorBase.user');

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

  @override
  String toString() {
    final string = 'user: ${user.toString()}';
    return '{$string}';
  }
}
