import 'package:mobx/mobx.dart';
import 'package:uniprintgestao/src/models/graph/ponto_atendimento.dart';
import 'package:uniprintgestao/src/models/graph/usuario_g.dart';

part 'cadastro_atendente_controller.g.dart';

class CadastroAtendenteController = _CadastroAtendenteBase
    with _$CadastroAtendenteController;

abstract class _CadastroAtendenteBase with Store {
  @observable
  Usuario user;
  @observable
  PontoAtendimento local;
}
