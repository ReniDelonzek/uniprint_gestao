import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/cadastro_atendente/cadastro_atendente_controller.dart';
import 'package:uniprintgestao/src/modules/cadastro_atendente/cadastro_atendente_module.dart';

void main() {
  initModule(CadastroAtendenteModule());
  CadastroAtendenteController cadastroatendente;

  setUp(() {
    cadastroatendente =
        CadastroAtendenteModule.to.bloc<CadastroAtendenteController>();
  });

  group('CadastroAtendenteController Test', () {
    test("First Test", () {
      expect(cadastroatendente, isInstanceOf<CadastroAtendenteController>());
    });

    test("Set Value", () {
      expect(cadastroatendente.value, equals(0));
      cadastroatendente.increment();
      expect(cadastroatendente.value, equals(1));
    });
  });
}
