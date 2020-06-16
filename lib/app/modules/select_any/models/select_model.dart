import 'package:flutter/cupertino.dart';

import 'filtro.dart';

class SelectModel {
  int tipoSelecao; //0 selecao simples, 1 selecao multipla, 2 acao
  String titulo;
  String query;
  String url;
  String chaveLista; //grapql
  List<Linha> linhas;
  String id;
  List<Filtro> filtros;
  List<Acao> acoes;
  List<Acao> botoes;
  List<String> legendas;

  SelectModel(this.titulo, this.id, this.linhas, this.tipoSelecao,
      {this.query,
      this.url,
      this.filtros,
      this.acoes,
      this.botoes,
      this.chaveLista});
}

class Linha {
  String chave;
  Color color;
  String involucro;
  String valorPadrao;
  LinhaPersonalizada personalizacao;

  Linha(this.chave,
      {this.color, this.involucro, this.valorPadrao, this.personalizacao});
}

typedef LinhaPersonalizada = Widget Function(dynamic dados);

class Acao {
  Map<String, String>
      chaves; //keys das colunas a serem enviadas, e o nome como elas devem ir
  String descricao;
  WidgetBuilder route;
  bool edicao;

  Acao(this.descricao, this.route, {this.chaves, this.edicao});
}
