import 'package:uniprintgestao/src/api/graphQlObjetct.dart';
import 'package:uniprintgestao/src/api/mutations.dart';
import 'package:uniprintgestao/src/app_module.dart';
import 'package:uniprintgestao/src/extensions/date.dart';
import 'package:uniprintgestao/src/models/graph/atendimento_g.dart';
import 'package:uniprintgestao/src/utils/auth/hasura_auth_service.dart';
import 'package:uniprintgestao/src/utils/network/network.dart';
import 'package:uniprintgestao/src/utils/utils_notificacao.dart';

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
        'usuario_id': 9
        //AppModule.to.getDependency<HasuraAuthService>().usuario?.id
      });
      return res != null;
    } catch (e) {
      print(e);
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
