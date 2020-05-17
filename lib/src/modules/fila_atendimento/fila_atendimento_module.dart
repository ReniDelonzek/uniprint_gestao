import 'package:uniprintgestao/src/modules/fila_atendimento/fila_atendimento_controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/modules/fila_atendimento/fila_atendimento_page.dart';

class FilaAtendimentoModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => FilaAtendimentoController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => FilaAtendimentoPage();

  static Inject get to => Inject<FilaAtendimentoModule>.of();
}
