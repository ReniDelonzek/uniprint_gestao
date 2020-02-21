import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/cadastro_preco/cadastro_preco_controller.dart';
import 'package:uniprintgestao/src/modules/cadastro_preco/cadastro_preco_module.dart';

void main() {
  initModule(CadastroPrecoModule());
  CadastroPrecoController cadastropreco;

  setUp(() {
    cadastropreco = CadastroPrecoModule.to.bloc<CadastroPrecoController>();
  });

  group('CadastroPrecoController Test', () {
    test("First Test", () {
      expect(cadastropreco, isInstanceOf<CadastroPrecoController>());
    });

    test("Set Value", () {
      expect(cadastropreco.value, equals(0));
      cadastropreco.increment();
      expect(cadastropreco.value, equals(1));
    });
  });
}
