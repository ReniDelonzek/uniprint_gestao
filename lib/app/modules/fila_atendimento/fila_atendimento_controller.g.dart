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
    _$paginaAtualAtom.context.enforceReadPolicy(_$paginaAtualAtom);
    _$paginaAtualAtom.reportObserved();
    return super.paginaAtual;
  }

  @override
  set paginaAtual(int value) {
    _$paginaAtualAtom.context.conditionallyRunInAction(() {
      super.paginaAtual = value;
      _$paginaAtualAtom.reportChanged();
    }, _$paginaAtualAtom, name: '${_$paginaAtualAtom.name}_set');
  }

  @override
  String toString() {
    final string = 'paginaAtual: ${paginaAtual.toString()}';
    return '{$string}';
  }
}
