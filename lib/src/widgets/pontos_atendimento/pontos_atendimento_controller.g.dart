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
    _$pontoAtendimentoAtom.context.enforceReadPolicy(_$pontoAtendimentoAtom);
    _$pontoAtendimentoAtom.reportObserved();
    return super.pontoAtendimento;
  }

  @override
  set pontoAtendimento(PontoAtendimento value) {
    _$pontoAtendimentoAtom.context.conditionallyRunInAction(() {
      super.pontoAtendimento = value;
      _$pontoAtendimentoAtom.reportChanged();
    }, _$pontoAtendimentoAtom, name: '${_$pontoAtendimentoAtom.name}_set');
  }
}
