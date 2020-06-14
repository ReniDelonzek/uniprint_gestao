// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pontos_atendimento_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PontosAtendimentoController on _PontosAtendimentoBase, Store {
  final _$pontoAtendimentoAtom =
      Atom(name: '_PontosAtendimentoBase.pontoAtendimento');

  @override
  PontoAtendimento get pontoAtendimento {
    _$pontoAtendimentoAtom.reportRead();
    return super.pontoAtendimento;
  }

  @override
  set pontoAtendimento(PontoAtendimento value) {
    _$pontoAtendimentoAtom.reportWrite(value, super.pontoAtendimento, () {
      super.pontoAtendimento = value;
    });
  }

  @override
  String toString() {
    return '''
pontoAtendimento: ${pontoAtendimento}
    ''';
  }
}
