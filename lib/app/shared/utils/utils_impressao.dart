import 'dart:io';

import 'package:flutter_pdf_printer/flutter_pdf_printer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uniprintgestao/app/app_module.dart';
import 'package:uniprintgestao/app/shared/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/app/shared/api/mutations.dart';
import 'package:uniprintgestao/app/shared/graph/arquivo_impressao.dart';
import 'package:uniprintgestao/app/shared/graph/impressao.dart';
import 'package:uniprintgestao/app/shared/utils/auth/hasura_auth_service.dart';
import 'package:uniprintgestao/app/shared/utils/constans.dart';
import 'package:uniprintgestao/app/shared/utils/utils_notificacao.dart';
import 'package:uniprintgestao/app/shared/utils/utils_platform.dart';

import 'package:uniprintgestao/app/shared/extensions/date.dart';
import 'package:uniprintgestao/app/shared/utils/utils_sentry.dart';

import 'utils_download.dart';

class UtilsImpressao {
  static Future<List<File>> baixarArquivosImpressao(Impressao impressao) async {
    List<File> files = List();
    List<ArquivoImpressao> arquivos = impressao.arquivo_impressaos;
    String dir = '';
    if (UtilsPlatform.isDesktop()) {
      dir = '${Directory.current.path}\\Impressoes\\${impressao.id}';
    } else {
      dir = (await getExternalStorageDirectory()).absolute.path +
          '/${impressao.id}';
    }

    for (ArquivoImpressao arquivo in arquivos) {
      files.add(await UtilsDownload.baixarArquivo(
          arquivo.url, dir, '${arquivo.nome}'));
    }
    return files;
  }

  static Future<bool> imprimirArquivos(List<File> arquivos) async {
    if (UtilsPlatform.isWindows()) {
      for (File file in arquivos) {
        String path = Directory.current.path + "\\PDFtoPrinter";
        try {
          await Process.run(path, [file.absolute.path]);
        } catch (error, stackTrace) {
          UtilsSentry.reportError(error, stackTrace);
          return false;
        }
      }
    } else if (UtilsPlatform.isMobile()) {
      for (File file in arquivos) {
        await FlutterPdfPrinter.printFile(file.path);
      }
    }
    return true;
  }

  static Future<bool> abrirArquivosExplorador(Impressao impressao) async {
    List<File> _ = await baixarArquivosImpressao(impressao);
    try {
      Process.run("start %windir%\\explorer.exe",
          ["${Directory.current.path}\\Impressoes\\${impressao.id}"],
          runInShell: true);
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
      return false;
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
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
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
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
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
