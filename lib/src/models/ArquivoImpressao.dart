import 'package:firedart/firedart.dart';

class ArquivoImpressao {
  String url;
  String nome;
  bool colorido;
  String codImpressao;
  int quantidade;
  String tipoFolha;
  String id;

  //ingorar
  String patch;

  static ArquivoImpressao fromDoc(Document document) {
    ArquivoImpressao arquivoImpressao = ArquivoImpressao();
    arquivoImpressao.nome = document.map['nome'];
    arquivoImpressao.url = document.map['url'];
    arquivoImpressao.colorido = document.map['colorido'];
    arquivoImpressao.quantidade = document.map['quantidade'];
    arquivoImpressao.tipoFolha = document.map['tipoFolha'];
    arquivoImpressao.id = document.id;
    return arquivoImpressao;
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'nome': nome,
        'colorido': colorido,
        'codImpressao': codImpressao,
        'quantidade': quantidade,
        'tipoFolha': tipoFolha,
      };
}
