import 'package:uniprintgestao/src/modules/fila_impressoes/fila_impressoes_controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/modules/fila_impressoes/fila_impressoes_page.dart';

class FilaImpressoesModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => FilaImpressoesController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => FilaImpressoesPage();

  static Inject get to => Inject<FilaImpressoesModule>.of();
}
