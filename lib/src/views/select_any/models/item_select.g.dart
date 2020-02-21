// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_select.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ItemSelect on _ItemSelect, Store {
  final _$isSelectedAtom = Atom(name: '_ItemSelect.isSelected');

  @override
  bool get isSelected {
    _$isSelectedAtom.context.enforceReadPolicy(_$isSelectedAtom);
    _$isSelectedAtom.reportObserved();
    return super.isSelected;
  }

  @override
  set isSelected(bool value) {
    _$isSelectedAtom.context.conditionallyRunInAction(() {
      super.isSelected = value;
      _$isSelectedAtom.reportChanged();
    }, _$isSelectedAtom, name: '${_$isSelectedAtom.name}_set');
  }

  final _$deletadoAtom = Atom(name: '_ItemSelect.deletado');

  @override
  bool get deletado {
    _$deletadoAtom.context.enforceReadPolicy(_$deletadoAtom);
    _$deletadoAtom.reportObserved();
    return super.deletado;
  }

  @override
  set deletado(bool value) {
    _$deletadoAtom.context.conditionallyRunInAction(() {
      super.deletado = value;
      _$deletadoAtom.reportChanged();
    }, _$deletadoAtom, name: '${_$deletadoAtom.name}_set');
  }

  @override
  String toString() {
    final string =
        'isSelected: ${isSelected.toString()},deletado: ${deletado.toString()}';
    return '{$string}';
  }
}
