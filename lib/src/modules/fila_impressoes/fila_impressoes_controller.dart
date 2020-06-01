import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:uniprintgestao/src/models/graph/impressao.dart';
import 'package:uniprintgestao/src/utils/utils_impressao.dart';

part 'fila_impressoes_controller.g.dart';

class FilaImpressoesController = _FilaImpressoesBase
    with _$FilaImpressoesController;

abstract class _FilaImpressoesBase with Store {
  Future<List<File>> baixarArquivos(Impressao impressao) async {
    return await UtilsImpressao.baixarArquivosImpressao(impressao);
  }
}