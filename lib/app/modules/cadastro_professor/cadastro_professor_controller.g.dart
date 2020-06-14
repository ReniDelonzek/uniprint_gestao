// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastro_professor_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastroProfessorController on _CadastroProfessorBase, Store {
  final _$usuarioAtom = Atom(name: '_CadastroProfessorBase.usuario');

  @override
  Usuario get usuario {
    _$usuarioAtom.reportRead();
    return super.usuario;
  }

  @override
  set usuario(Usuario value) {
    _$usuarioAtom.reportWrite(value, super.usuario, () {
      super.usuario = value;
    });
  }

  @override
  String toString() {
    return '''
usuario: ${usuario}
    ''';
  }
}
