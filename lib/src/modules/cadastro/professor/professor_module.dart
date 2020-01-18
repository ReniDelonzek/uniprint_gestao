import 'package:uniprintgestao/src/modules/cadastro/professor/professor_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class ProfessorModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ProfessorBloc()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => Container();

  static Inject get to => Inject<ProfessorModule>.of();
}