import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/tela_inicio/tela_inicio_controller.dart';
import 'package:uniprintgestao/src/modules/tela_inicio/tela_inicio_module.dart';

void main() {
  initModule(TelaInicioModule());
  TelaInicioController telainicio;

  setUp(() {
    telainicio = TelaInicioModule.to.bloc<TelaInicioController>();
  });

  group('TelaInicioController Test', () {
    test("First Test", () {
      expect(telainicio, isInstanceOf<TelaInicioController>());
    });

    test("Set Value", () {
      expect(telainicio.value, equals(0));
      telainicio.increment();
      expect(telainicio.value, equals(1));
    });
  });
}
