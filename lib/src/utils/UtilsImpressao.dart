import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:uniprintgestao/src/api/UtilsDownload.dart';
import 'package:uniprintgestao/src/models/ArquivoImpressao.dart';
import 'package:uniprintgestao/src/models/Impressao.dart';

class UtilsImpressao {
  static Future<List<ArquivoImpressao>> obterArquivosImpressao(
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
  }

  static Future<List<File>> baixarArquivosImpressao(Impressao impressao) async {
    List<File> files = List();
    List<ArquivoImpressao> arquivos = await obterArquivosImpressao(impressao);
    for (ArquivoImpressao arquivo in arquivos) {
      files.add(await UtilsDownload.baixarArquivo(
          arquivo.url, 'Impressoes/${impressao.id}', '${arquivo.nome}'));
    }
    return files;
  }

  static bool imprimirArquivos(List<File> arquivos) {
    for (File file in arquivos) {
      String win7Path = Directory.current.path +
          "\\PDFtoPrinter"
              'C:\\Users\\Reni\\Downloads\\Programas\\pdf\\PDFtoPrinter';
      try {
        Process.run(win7Path, [file.absolute.path]);
      } catch (e) {
        print(e);
        return false;
      }
    }
    return true;
  }
}
