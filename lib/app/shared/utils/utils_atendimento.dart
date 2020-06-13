import 'package:uniprintgestao/app/app_module.dart';
import 'package:uniprintgestao/app/shared/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/app/shared/api/mutations.dart';
import 'package:uniprintgestao/app/shared/graph/atendimento.dart';
import 'package:uniprintgestao/app/shared/utils/auth/hasura_auth_service.dart';
import 'package:uniprintgestao/app/shared/utils/utils_notificacao.dart';

import 'package:uniprintgestao/app/shared/extensions/date.dart';
import 'package:uniprintgestao/app/shared/utils/utils_sentry.dart';

class UtilsAtendimento {
  static Future<bool> gerarMovimentacao(
      int tipo, int status, int atendimentoId) async {
    try {
      var res = await GraphQlObject.hasuraConnect
          .mutation(Mutations.cadastroMovimentacaoAtendimento, variables: {
        'data': DateTime.now().hasuraFormat(),
        'tipo': tipo,
        'atendimento_id': atendimentoId,
        'status': status,
        'usuario_id':
            AppModule.to.getDependency<HasuraAuthService>().usuario?.codHasura
        //AppModule.to.getDependency<HasuraAuthService>().usuario?.id
      });
      return res != null;
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);

      return false;
    }
  }

  static Future<bool> gerarChamada(Atendimento atendimento) async {
    String title =
        "Hey, estamos esperando você no ${atendimento.ponto_atendimento?.nome}";
    String body = "Vem logo!";
    return await UtilsNotificacao.enviarNotificacao(
        title, body, atendimento.usuario.uid);
  }
}
