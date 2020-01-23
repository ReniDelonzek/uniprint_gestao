import 'package:uniprintgestao/src/api/graphQlObjetct.dart';
import 'package:uniprintgestao/src/api/mutations.dart';
import 'package:uniprintgestao/src/extensions/date.dart';

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
        'usuario_id': 1
      });
      return res != null;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
