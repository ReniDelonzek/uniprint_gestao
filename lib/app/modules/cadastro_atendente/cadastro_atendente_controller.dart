import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:uniprintgestao/app/shared/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/app/shared/api/mutations.dart';
import 'package:uniprintgestao/app/shared/graph/ponto_atendimento.dart';
import 'package:uniprintgestao/app/shared/graph/usuario.dart';
import 'package:uniprintgestao/app/shared/utils/network/network.dart';
import 'package:uniprintgestao/app/shared/utils/utils_sentry.dart';

part 'cadastro_atendente_controller.g.dart';

class CadastroAtendenteController = _CadastroAtendenteBase
    with _$CadastroAtendenteController;

abstract class _CadastroAtendenteBase with Store {
  @observable
  Usuario user;
  @observable
  PontoAtendimento local;

  String verificarDados() {
    if (user == null) {
      return 'Você precisa selecionar o usuário';
    } else if (local == null) {
      return 'Você precisa selecionar o ponto de atendimento';
    }
    return null;
  }

  Future<bool> salvarDados() async {
    try {
      var res = await GraphQlObject.hasuraConnect.mutation(
          Mutations.cadastroAtendente,
          variables: {'ponto_atendimento_id': local.id, 'usuario_id': user.id});

      if (res != null) {
        var atendenteID = res['data']['insert_atendente']['returning'][0]['id'];
        var resFire = await Dio().post(
            'https://us-central1-uniprint-uv.cloudfunctions.net/criarAtendente',
            data: {
              'usuario_uid': user?.uid,
              'atendente_id': atendenteID,
              'ponto_id': local.id
            });
        return resFire.sucesso();
      }
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
    }
    return false;
  }
}
