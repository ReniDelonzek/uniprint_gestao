import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'selecionar_quantidade_controller.g.dart';

class SelecionarQuantidadeController = _SelecionarQuantidadeBase
    with _$SelecionarQuantidadeController;

abstract class _SelecionarQuantidadeBase with Store {
  @observable
  double quantidade;
  final cltQuantidade =TextEditingController();
}
