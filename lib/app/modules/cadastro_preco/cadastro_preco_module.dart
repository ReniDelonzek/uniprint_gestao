import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import 'cadastro_preco_controller.dart';
import 'cadastro_preco_page.dart';

class CadastroPrecoModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => CadastroPrecoController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => CadastroPrecoPage();

  static Inject get to => Inject<CadastroPrecoModule>.of();
}
