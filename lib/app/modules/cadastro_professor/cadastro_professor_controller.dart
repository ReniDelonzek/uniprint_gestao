import 'package:mobx/mobx.dart';
import 'package:uniprintgestao/app/shared/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/app/shared/api/mutations.dart';
import 'package:uniprintgestao/app/shared/api/querys.dart';
import 'package:uniprintgestao/app/shared/graph/usuario.dart';
import 'package:uniprintgestao/app/shared/utils/utils_sentry.dart';

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
          Mutations.cadastroProfessor,
          variables: {'usuario_id': usuario?.id});

      return (sucessoMutationAffectRows(res, 'update_usuario'));
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
    }
    return false;
  }
}
