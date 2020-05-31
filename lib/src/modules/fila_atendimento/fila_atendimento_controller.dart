import 'package:hasura_connect/hasura_connect.dart';
import 'package:mobx/mobx.dart';
import 'package:uniprintgestao/src/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/src/api/querys.dart';
import 'package:uniprintgestao/src/app_module.dart';
import 'package:uniprintgestao/src/utils/auth/hasura_auth_service.dart';

part 'fila_atendimento_controller.g.dart';

class FilaAtendimentoController = _FilaAtendimentoBase
    with _$FilaAtendimentoController;

abstract class _FilaAtendimentoBase with Store {
  @observable
  int paginaAtual = 0;
  Snapshot snapshot;

  Snapshot getAtendimentos() {
    return GraphQlObject.hasuraConnect
        .subscription(Querys.getAtendimentos, variables: {
      'ponto_atendimento_id': AppModule.to
          .getDependency<HasuraAuthService>()
          .usuario
          .codPontoAtendimento
    });
  }
}
