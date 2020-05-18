import 'package:mobx/mobx.dart';
import 'package:uniprintgestao/src/models/graph/tipo_folha.dart';
import 'package:uniprintgestao/src/widgets/selecionar_range_data/selecionar_range_data_controller.dart';
import 'package:uniprintgestao/src/widgets/select/select_controller.dart';

part 'cadastro_preco_controller.g.dart';

class CadastroPrecoController = _CadastroPrecoBase
    with _$CadastroPrecoController;

abstract class _CadastroPrecoBase with Store {
  SelecionarRangeDataController ctlDatas =
      SelecionarRangeDataController(dataMin: DateTime.now());

  SelectController ctlTipoFolha =
      SelectController(value: 'Clique para selecionar');
}
