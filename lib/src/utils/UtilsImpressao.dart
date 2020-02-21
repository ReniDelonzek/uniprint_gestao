import 'dart:io';

import 'package:uniprintgestao/src/app_module.dart';
import 'package:uniprintgestao/src/extensions/date.dart';
import 'package:uniprintgestao/src/api/UtilsDownload.dart';
import 'package:uniprintgestao/src/api/graphQlObjetct.dart';
import 'package:uniprintgestao/src/api/mutations.dart';
import 'package:uniprintgestao/src/models/graph/arquivo_impressao.dart';
import 'package:uniprintgestao/src/models/graph/impressao.dart';
import 'package:uniprintgestao/src/utils/Constans.dart';
import 'package:uniprintgestao/src/utils/auth/hasura_auth_service.dart';
import 'package:uniprintgestao/src/utils/utils_notificacao.dart';

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

  static Future<bool> gerarMovimentacao(
      int tipo, int status, Impressao impressao) async {
    try {
      int usuarioID =
          AppModule.to.getDependency<HasuraAuthService>().usuario.codHasura;
      var res = await GraphQlObject.hasuraConnect
          .mutation(Mutations.cadastroMovimentacaoImpressao, variables: {
        'data': DateTime.now().hasuraFormat(),
        'tipo': tipo,
        'impressao_id': impressao.id,
        'status': status,
        'usuario_id': usuarioID
        //AppModule.to.getDependency<HasuraAuthService>().usuario.codHasura
      });
      enviarNotificacaoImpressao(tipo, impressao);
      return res != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> autorizarImpressao(Impressao impressao) async {
    int tipo = Constants.MOV_IMPRESSAO_AUTORIZADO;
    int status = Constants.STATUS_IMPRESSAO_AUTORIZADO;
    int usuarioID =
        AppModule.to.getDependency<HasuraAuthService>().usuario.codHasura;
    try {
      var res = await GraphQlObject.hasuraConnect
          .mutation(Mutations.cadastroMovimentacaoImpressao, variables: {
        'data': DateTime.now().hasuraFormat(),
        'tipo': tipo,
        'impressao_id': impressao.id,
        'status': status,
        'usuario_id': usuarioID,
        'ponto_atendimento_id': impressao.ponto_atendimento.id
        //AppModule.to.getDependency<HasuraAuthService>().usuario.codHasura
      });
      enviarNotificacaoImpressao(tipo, impressao);
      return res != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static enviarNotificacaoImpressao(int tipo, Impressao impressao) {
    String title = "";
    String body = "";
    switch (tipo) {
      case Constants.MOV_IMPRESSAO_AUTORIZADO:
        {
          title = "Sua impressão foi autorizada!";
          body = "Logo ela será processada e disponível para retirar!";
        }
        break;
      case Constants.MOV_IMPRESSAO_AGUARDANDO_RETIRADA:
        {
          title = "Sua impressão está te aguardando!";
          body = "Estamos esperando você buscar";
        }
        break;
      case Constants.MOV_IMPRESSAO_NEGADA:
        {
          title = "Sua impressão foi negada!";
          body = "";
        }
        break;
      case Constants.MOV_IMPRESSAO_RETIRADA:
        {
          title = "Sua impressão foi marcada como retirada";
          body = "Muito obrigado!";
        }
        break;
    }
    UtilsNotificacao.enviarNotificacao(title, body, impressao.usuario.uid);
  }
}
