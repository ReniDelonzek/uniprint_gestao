import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/widgets.dart';

import 'filtro/filtro_controller.dart';
import 'models/select_model.dart';
import 'select_any_controller.dart';
import 'select_any_page.dart';

class SelectAnyModule extends ModuleWidget {
  final Map data;
  final SelectModel model;

  SelectAnyModule(this.model, {this.data});

  @override
  List<Bloc> get blocs => [
        Bloc((i) => FiltroController()),
        Bloc((i) => SelectAnyController(model.titulo)),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => SelectAnyPage(this.model, data: this.data);

  static Inject get to => Inject<SelectAnyModule>.of();
}
