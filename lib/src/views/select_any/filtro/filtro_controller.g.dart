// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtro_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FiltroController on _FiltroBase, Store {
  final _$controllersAtom = Atom(name: '_FiltroBase.controllers');

  @override
  Map<String, TextEditingController> get controllers {
    _$controllersAtom.context.enforceReadPolicy(_$controllersAtom);
    _$controllersAtom.reportObserved();
    return super.controllers;
  }

  @override
  set controllers(Map<String, TextEditingController> value) {
    _$controllersAtom.context.conditionallyRunInAction(() {
      super.controllers = value;
      _$controllersAtom.reportChanged();
    }, _$controllersAtom, name: '${_$controllersAtom.name}_set');
  }

  @override
  String toString() {
    final string = 'controllers: ${controllers.toString()}';
    return '{$string}';
  }
}
