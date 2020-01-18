import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/widgets.dart';
import 'package:uniprintgestao/src/views/select_any/select_any_controller.dart';
import 'package:uniprintgestao/src/views/select_any/select_any_page.dart';

import 'filtro/filtro_controller.dart';
import 'models/filtro.dart';

class SelectAnyModule extends ModuleWidget {
  final int tipoSelecao; //0 selecao simples, 1 selecao multipla, 2 acao
  final String titulo;
  final String query;
  final String url;
  final List<String> chaves;
  final String id;
  final Map data;
  WidgetBuilder route;
  List<Filtro> filtros;
  bool showLabels;

  SelectAnyModule(this.titulo, this.tipoSelecao, this.chaves, this.id,
      {this.query,
      this.url,
      this.data,
      this.route,
      this.filtros,
      this.showLabels});

  @override
  List<Bloc> get blocs => [
        Bloc((i) => FiltroController()),
        Bloc((i) => SelectAnyController(titulo)),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => SelectAnyPage(
        titulo,
        tipoSelecao,
        chaves,
        id,
        query: query,
        url: url,
        data: data,
        route: route,
        filtros: filtros,
        showLabels: showLabels,
      );

  static Inject get to => Inject<SelectAnyModule>.of();
}
