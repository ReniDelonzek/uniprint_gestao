import 'package:flutter/cupertino.dart';

import 'filtro.dart';

class SelectModel {
  int tipoSelecao; //0 selecao simples, 1 selecao multipla, 2 acao
  String titulo;
  String query;
  String url;
  List<Linha> linhas;
  String id;
  Map data = Map();
  WidgetBuilder route;
  List<Filtro> filtros;
  bool exibirLegendas;

  SelectModel(this.titulo, this.id, this.linhas, this.tipoSelecao,
      {this.query,
      this.url,
      this.data,
      this.route,
      this.filtros,
      this.exibirLegendas});
}

class Linha {
  String chave;
  Color color;

  Linha(this.chave, {this.color});
}
