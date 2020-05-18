import 'package:mobx/mobx.dart';

part 'item_select.g.dart';

class ItemSelect extends _ItemSelect with _$ItemSelect {
  static ItemSelect init(int id, dynamic object, Map<String, dynamic> strings,
      bool isSelected, bool deletado) {
    ItemSelect item = ItemSelect();
    item.deletado = deletado;
    item.id = id;
    item.object = object;
    item.strings = strings;
    item.isSelected = isSelected;
    return item;
  }
}

abstract class _ItemSelect with Store {
  _ItemSelect();
  int id;
  dynamic object;
  Map<String, dynamic> strings = Map();

  @observable
  bool isSelected;
  @observable
  bool deletado = false;
}
