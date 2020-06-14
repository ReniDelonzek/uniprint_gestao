// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selecionar_range_data_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SelecionarRangeDataController on _SelecionarRangeDataController, Store {
  Computed<String> _$dataComputed;

  @override
  String get data => (_$dataComputed ??= Computed<String>(() => super.data,
          name: '_SelecionarRangeDataController.data'))
      .value;

  final _$dataInicialAtom =
      Atom(name: '_SelecionarRangeDataController.dataInicial');

  @override
  DateTime get dataInicial {
    _$dataInicialAtom.reportRead();
    return super.dataInicial;
  }

  @override
  set dataInicial(DateTime value) {
    _$dataInicialAtom.reportWrite(value, super.dataInicial, () {
      super.dataInicial = value;
    });
  }

  final _$dataFinalAtom =
      Atom(name: '_SelecionarRangeDataController.dataFinal');

  @override
  DateTime get dataFinal {
    _$dataFinalAtom.reportRead();
    return super.dataFinal;
  }

  @override
  set dataFinal(DateTime value) {
    _$dataFinalAtom.reportWrite(value, super.dataFinal, () {
      super.dataFinal = value;
    });
  }

  @override
  String toString() {
    return '''
dataInicial: ${dataInicial},
dataFinal: ${dataFinal},
data: ${data}
    ''';
  }
}
