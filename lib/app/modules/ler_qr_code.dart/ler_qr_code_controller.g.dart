// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ler_qr_code_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LerQrCodeController on _LerQrCodeBase, Store {
  final _$statusAtom = Atom(name: '_LerQrCodeBase.status');

  @override
  String get status {
    _$statusAtom.context.enforceReadPolicy(_$statusAtom);
    _$statusAtom.reportObserved();
    return super.status;
  }

  @override
  set status(String value) {
    _$statusAtom.context.conditionallyRunInAction(() {
      super.status = value;
      _$statusAtom.reportChanged();
    }, _$statusAtom, name: '${_$statusAtom.name}_set');
  }

  @override
  String toString() {
    final string = 'status: ${status.toString()}';
    return '{$string}';
  }
}
