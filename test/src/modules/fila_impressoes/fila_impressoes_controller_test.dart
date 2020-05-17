import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/fila_impressoes/fila_impressoes_controller.dart';
import 'package:uniprintgestao/src/modules/fila_impressoes/fila_impressoes_module.dart';

void main() {
  initModule(FilaImpressoesModule());
  FilaImpressoesController filaimpressoes;

  setUp(() {
    filaimpressoes = FilaImpressoesModule.to.bloc<FilaImpressoesController>();
  });

  group('FilaImpressoesController Test', () {
    test("First Test", () {
      expect(filaimpressoes, isInstanceOf<FilaImpressoesController>());
    });

    test("Set Value", () {
      expect(filaimpressoes.value, equals(0));
      filaimpressoes.increment();
      expect(filaimpressoes.value, equals(1));
    });
  });
}
