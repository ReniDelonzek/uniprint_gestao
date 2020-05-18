import 'package:uniprintgestao/src/modules/cadastro_atendente/cadastro_atendente_controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/modules/cadastro_atendente/cadastro_atendente_page.dart';

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
