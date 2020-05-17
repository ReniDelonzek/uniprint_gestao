import 'package:uniprintgestao/src/modules/cadastro_professor/cadastro_professor_controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/modules/cadastro_professor/cadastro_professor_page.dart';

class CadastroProfessorModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => CadastroProfessorController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => CadastroProfessorPage();

  static Inject get to => Inject<CadastroProfessorModule>.of();
}
