import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/cadastro_professor/cadastro_professor_controller.dart';
import 'package:uniprintgestao/src/modules/cadastro_professor/cadastro_professor_module.dart';

void main() {
  initModule(CadastroProfessorModule());
  CadastroProfessorController cadastroprofessor;

  setUp(() {
    cadastroprofessor =
        CadastroProfessorModule.to.bloc<CadastroProfessorController>();
  });

  group('CadastroProfessorController Test', () {
    test("First Test", () {
      expect(cadastroprofessor, isInstanceOf<CadastroProfessorController>());
    });

    test("Set Value", () {
      expect(cadastroprofessor.value, equals(0));
      cadastroprofessor.increment();
      expect(cadastroprofessor.value, equals(1));
    });
  });
}
