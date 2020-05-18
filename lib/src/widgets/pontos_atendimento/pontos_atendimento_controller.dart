import 'package:mobx/mobx.dart';
import 'package:uniprintgestao/src/models/graph/ponto_atendimento.dart';

part 'pontos_atendimento_controller.g.dart';

class PontosAtendimentoController = _PontosAtendimentoBase
    with _$PontosAtendimentoController;

abstract class _PontosAtendimentoBase with Store {
  @observable
  PontoAtendimento pontoAtendimento;
  _PontosAtendimentoBase(this.pontoAtendimento);
}
