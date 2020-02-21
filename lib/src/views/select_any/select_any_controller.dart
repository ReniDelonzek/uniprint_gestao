import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'models/item_select.dart';

part 'select_any_controller.g.dart';

class SelectAnyController = _SelectAnyBase with _$SelectAnyController;

abstract class _SelectAnyBase with Store {
  final TextEditingController filter = new TextEditingController();
  String searchText = "";
  String title;
  _SelectAnyBase(this.title) {
    appBarTitle = Text(title);
  }

  @observable
  Icon searchIcon = new Icon(Icons.search);
  @observable
  Widget appBarTitle;
  ObservableList<ItemSelect> listaOriginal = new ObservableList();
  @observable
  ObservableList<ItemSelect> listaExibida = new ObservableList();

  @action
  void pesquisar() {}

  @action
  void clearList() {
    this.listaExibida.clear();
  }

  @action
  void setList(List<ItemSelect> list) {
    this.listaExibida.addAll(list);
  }

  @override
  void dispose() {
    listaOriginal.clear();
    listaExibida.clear();
    filter.clear();
  }
}
