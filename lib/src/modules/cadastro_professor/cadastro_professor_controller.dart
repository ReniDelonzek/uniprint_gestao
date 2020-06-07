import 'package:mobx/mobx.dart';
import 'package:uniprintgestao/src/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/src/api/querys.dart';
import 'package:uniprintgestao/src/models/graph/usuario_g.dart';
import 'package:uniprintgestao/src/utils/utils_sentry.dart';

part 'cadastro_professor_controller.g.dart';

class CadastroProfessorController = _CadastroProfessorBase
    with _$CadastroProfessorController;

abstract class _CadastroProfessorBase with Store {
  @observable
  Usuario usuario;

  String verificarDados() {
    if (usuario == null) {
      return 'Você precisa selecionar o usuário';
    }
    return null;
  }

  Future<bool> enviarDadosServidor() async {
    try {
      var res = await GraphQlObject.hasuraConnect.mutation(
          Querys.cadastroProfessor,
          variables: {'usuario_id': usuario?.id});

      return (sucessoMutationAffectRows(res, 'update_usuario'));
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
    }
    return false;
  }
}
