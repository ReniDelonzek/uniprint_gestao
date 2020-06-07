import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import 'tela_inicio_controller.dart';
import 'tela_inicio_page.dart';

class TelaInicioModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => TelaInicioController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => TelaInicioPage();

  static Inject get to => Inject<TelaInicioModule>.of();
}
