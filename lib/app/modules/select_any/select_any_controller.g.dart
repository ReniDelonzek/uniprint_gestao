// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_any_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SelectAnyController on _SelectAnyBase, Store {
  final _$searchIconAtom = Atom(name: '_SelectAnyBase.searchIcon');

  @override
  Icon get searchIcon {
    _$searchIconAtom.reportRead();
    return super.searchIcon;
  }

  @override
  set searchIcon(Icon value) {
    _$searchIconAtom.reportWrite(value, super.searchIcon, () {
      super.searchIcon = value;
    });
  }

  final _$appBarTitleAtom = Atom(name: '_SelectAnyBase.appBarTitle');

  @override
  Widget get appBarTitle {
    _$appBarTitleAtom.reportRead();
    return super.appBarTitle;
  }

  @override
  set appBarTitle(Widget value) {
    _$appBarTitleAtom.reportWrite(value, super.appBarTitle, () {
      super.appBarTitle = value;
    });
  }

  final _$listaExibidaAtom = Atom(name: '_SelectAnyBase.listaExibida');

  @override
  ObservableList<ItemSelect> get listaExibida {
    _$listaExibidaAtom.reportRead();
    return super.listaExibida;
  }

  @override
  set listaExibida(ObservableList<ItemSelect> value) {
    _$listaExibidaAtom.reportWrite(value, super.listaExibida, () {
      super.listaExibida = value;
    });
  }

  final _$_SelectAnyBaseActionController =
      ActionController(name: '_SelectAnyBase');

  @override
  void pesquisar() {
    final _$actionInfo = _$_SelectAnyBaseActionController.startAction(
        name: '_SelectAnyBase.pesquisar');
    try {
      return super.pesquisar();
    } finally {
      _$_SelectAnyBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearList() {
    final _$actionInfo = _$_SelectAnyBaseActionController.startAction(
        name: '_SelectAnyBase.clearList');
    try {
      return super.clearList();
    } finally {
      _$_SelectAnyBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setList(List<ItemSelect> list) {
    final _$actionInfo = _$_SelectAnyBaseActionController.startAction(
        name: '_SelectAnyBase.setList');
    try {
      return super.setList(list);
    } finally {
      _$_SelectAnyBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchIcon: ${searchIcon},
appBarTitle: ${appBarTitle},
listaExibida: ${listaExibida}
    ''';
  }
}
