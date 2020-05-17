import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/lista_atendentes/lista_atendentes_controller.dart';
import 'package:uniprintgestao/src/modules/lista_atendentes/lista_atendentes_module.dart';

void main() {
  initModule(ListaAtendentesModule());
  ListaAtendentesController listaatendentes;

  setUp(() {
    listaatendentes =
        ListaAtendentesModule.to.bloc<ListaAtendentesController>();
  });

  group('ListaAtendentesController Test', () {
    test("First Test", () {
      expect(listaatendentes, isInstanceOf<ListaAtendentesController>());
    });

    test("Set Value", () {
      expect(listaatendentes.value, equals(0));
      listaatendentes.increment();
      expect(listaatendentes.value, equals(1));
    });
  });
}
