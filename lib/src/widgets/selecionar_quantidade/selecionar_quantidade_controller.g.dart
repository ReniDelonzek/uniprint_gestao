// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selecionar_quantidade_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SelecionarQuantidadeController on _SelecionarQuantidadeBase, Store {
  final _$quantidadeAtom = Atom(name: '_SelecionarQuantidadeBase.quantidade');

  @override
  double get quantidade {
    _$quantidadeAtom.context.enforceReadPolicy(_$quantidadeAtom);
    _$quantidadeAtom.reportObserved();
    return super.quantidade;
  }

  @override
  set quantidade(double value) {
    _$quantidadeAtom.context.conditionallyRunInAction(() {
      super.quantidade = value;
      _$quantidadeAtom.reportChanged();
    }, _$quantidadeAtom, name: '${_$quantidadeAtom.name}_set');
  }

  @override
  String toString() {
    final string = 'quantidade: ${quantidade.toString()}';
    return '{$string}';
  }
}