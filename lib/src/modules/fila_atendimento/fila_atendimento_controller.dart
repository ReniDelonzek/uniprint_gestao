import 'package:mobx/mobx.dart';

part 'fila_atendimento_controller.g.dart';

class FilaAtendimentoController = _FilaAtendimentoBase
    with _$FilaAtendimentoController;

abstract class _FilaAtendimentoBase with Store {
  @observable
  int paginaAtual = 0;
}
