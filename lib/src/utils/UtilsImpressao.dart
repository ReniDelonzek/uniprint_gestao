import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/extensions/date.dart';
import 'package:uniprintgestao/src/api/UtilsDownload.dart';
import 'package:uniprintgestao/src/api/graphQlObjetct.dart';
import 'package:uniprintgestao/src/api/mutations.dart';
import 'package:uniprintgestao/src/models/graph/arquivo_impressao.dart';
import 'package:uniprintgestao/src/models/graph/impressao.dart';
import 'package:uniprintgestao/src/widgets/widgets.dart';

class UtilsImpressao {
  /*static Future<List<ArquivoImpressao>> obterArquivosImpressao(
      Impressao impressao) async {
    List<ArquivoImpressao> arquivos = List();
    var res = await Firestore.instance
        .collection('Empresas')
        .document('Uniguacu')
        .collection('Pontos')
        .document(impressao.codPonto)
        .collection('Impressoes')
        .document(impressao.id)
        .collection('Documentos')
        .get();
    if (res != null) {
      for (Document doc in res) {
        ArquivoImpressao arquivoImpressao = ArquivoImpressao.fromDoc(doc);
        arquivos.add(arquivoImpressao);
      }
    }
    return arquivos;
  }*/

  static Future<List<File>> baixarArquivosImpressao(Impressao impressao) async {
    List<File> files = List();
    List<ArquivoImpressao> arquivos =
        impressao.arquivo_impressaos; //await obterArquivosImpressao(impressao);
    for (ArquivoImpressao arquivo in arquivos) {
      files.add(await UtilsDownload.baixarArquivo(
          arquivo.url, 'Impressoes/${impressao.id}', '${arquivo.nome}'));
    }
    return files;
  }

  static bool imprimirArquivos(List<File> arquivos) {
    for (File file in arquivos) {
      String win7Path = Directory.current.path + "\\PDFtoPrinter";
      //'C:\\Users\\Reni\\Downloads\\Programas\\pdf\\PDFtoPrinter';
      try {
        Process.run(win7Path, [file.absolute.path]);
      } catch (e) {
        print(e);
        return false;
      }
    }
    return true;
  }

//\$data: timestamptz!, \$tipo: Int!, \$usuario_id: Int!, \$impressao_id: Int!, \$status: Int!
  static Future<bool> gerarMovimentacao(
      int tipo, int status, int impressaoId) async {
    try {
      var res = await GraphQlObject.hasuraConnect
          .mutation(Mutations.cadastroMovimentacaoImpressao, variables: {
        'data': DateTime.now().hasuraFormat(),
        'tipo': tipo,
        'impressao_id': impressaoId,
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
