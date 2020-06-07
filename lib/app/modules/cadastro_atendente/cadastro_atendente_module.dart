import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import 'cadastro_atendente_controller.dart';
import 'cadastro_atendente_page.dart';

class CadastroAtendenteModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => CadastroAtendenteController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => CadastroAtendentePage();

  static Inject get to => Inject<CadastroAtendenteModule>.of();
}
