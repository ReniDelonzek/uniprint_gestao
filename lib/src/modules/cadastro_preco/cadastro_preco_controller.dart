import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:uniprintgestao/src/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/src/api/mutations.dart';
import 'package:uniprintgestao/src/models/graph/tipo_folha.dart';
import 'package:uniprintgestao/src/models/graph/valor_impressao.dart';
import 'package:uniprintgestao/src/utils/utils_sentry.dart';
import 'package:uniprintgestao/src/widgets/selecionar_range_data/selecionar_range_data_controller.dart';
import 'package:uniprintgestao/src/widgets/select/select_controller.dart';
import 'package:uniprintgestao/src/extensions/string.dart';

part 'cadastro_preco_controller.g.dart';

class CadastroPrecoController = _CadastroPrecoBase
    with _$CadastroPrecoController;

abstract class _CadastroPrecoBase with Store {
  ValorImpressao valorImpressao;
  TipoFolha tipoFolha;
  final TextEditingController ctlValor = TextEditingController();
  final SelecionarRangeDataController ctlDatas =
      SelecionarRangeDataController(dataMin: DateTime.now());
  final SelectController ctlTipoFolha =
      SelectController(value: 'Clique para selecionar');
  @observable
  bool colorido = false;

  String verificarDados() {
    if (ctlDatas.dataInicial == null || ctlDatas.dataFinal == null) {
      return 'Você precisa selecionar a validade do preço';
    } else if (tipoFolha == null) {
      return 'Você precisa selecionar o tipo de folha';
    }
    return null;
  }

  Future<bool> salvarDados() async {
    try {
      if (valorImpressao == null) {
        valorImpressao = ValorImpressao();
      }
      valorImpressao.colorido = colorido;
      valorImpressao.valor = 3; //ctlValor.text.toDouble();
      valorImpressao.dataInicio = ctlDatas.dataInicial;
      valorImpressao.dataFim = ctlDatas.dataFinal;
      valorImpressao.tipoFolhaId = tipoFolha.id;
      var res = await GraphQlObject.hasuraConnect.mutation(
          Mutations.cadastroPrecoImpressao,
          variables: valorImpressao.toMap());
      return (sucessoMutationAffectRows(res, 'insert_valor_impressao'));
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
    }
    return false;
  }
}
