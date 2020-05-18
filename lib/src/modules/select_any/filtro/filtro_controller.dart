import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'filtro_controller.g.dart';

class FiltroController = _FiltroBase with _$FiltroController;

abstract class _FiltroBase with Store {
  @observable
  Map<String, TextEditingController> controllers = Map();
}
