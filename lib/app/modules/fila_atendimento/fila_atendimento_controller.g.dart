// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fila_atendimento_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FilaAtendimentoController on _FilaAtendimentoBase, Store {
  final _$paginaAtualAtom = Atom(name: '_FilaAtendimentoBase.paginaAtual');

  @override
  int get paginaAtual {
    _$paginaAtualAtom.reportRead();
    return super.paginaAtual;
  }

  @override
  set paginaAtual(int value) {
    _$paginaAtualAtom.reportWrite(value, super.paginaAtual, () {
      super.paginaAtual = value;
    });
  }

  @override
  String toString() {
    return '''
paginaAtual: ${paginaAtual}
    ''';
  }
}
