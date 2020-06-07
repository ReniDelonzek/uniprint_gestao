// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastro_preco_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastroPrecoController on _CadastroPrecoBase, Store {
  final _$coloridoAtom = Atom(name: '_CadastroPrecoBase.colorido');

  @override
  bool get colorido {
    _$coloridoAtom.context.enforceReadPolicy(_$coloridoAtom);
    _$coloridoAtom.reportObserved();
    return super.colorido;
  }

  @override
  set colorido(bool value) {
    _$coloridoAtom.context.conditionallyRunInAction(() {
      super.colorido = value;
      _$coloridoAtom.reportChanged();
    }, _$coloridoAtom, name: '${_$coloridoAtom.name}_set');
  }

  @override
  String toString() {
    final string = 'colorido: ${colorido.toString()}';
    return '{$string}';
  }
}
