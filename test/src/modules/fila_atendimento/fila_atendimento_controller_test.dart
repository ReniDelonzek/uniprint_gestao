import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/fila_atendimento/fila_atendimento_controller.dart';
import 'package:uniprintgestao/src/modules/fila_atendimento/fila_atendimento_module.dart';

void main() {
  initModule(FilaAtendimentoModule());
  FilaAtendimentoController filaatendimento;

  setUp(() {
    filaatendimento =
        FilaAtendimentoModule.to.bloc<FilaAtendimentoController>();
  });

  group('FilaAtendimentoController Test', () {
    test("First Test", () {
      expect(filaatendimento, isInstanceOf<FilaAtendimentoController>());
    });

    test("Set Value", () {
      expect(filaatendimento.value, equals(0));
      filaatendimento.increment();
      expect(filaatendimento.value, equals(1));
    });
  });
}
