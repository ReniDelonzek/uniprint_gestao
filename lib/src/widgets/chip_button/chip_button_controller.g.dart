// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chip_button_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChipButtonController on _ChipButtonBase, Store {
  final _$isSelectedAtom = Atom(name: '_ChipButtonBase.isSelected');

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

  @override
  String toString() {
    final string = 'isSelected: ${isSelected.toString()}';
    return '{$string}';
  }
}
