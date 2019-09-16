class ArquivoAtendimento {
  String url;
  String nome;
  bool colorido;
  String codImpressao;
  int quantidade;
  String tipoFolha;

  //ingorar
  String patch;

  Map<String, dynamic> toJson() => {
    'url': url,
    'nome': nome,
    'colorido': colorido,
    'codImpressao': codImpressao,
    'quantidade': quantidade,
    'tipoFolha': tipoFolha,
  };
}