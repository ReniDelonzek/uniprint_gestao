import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/cadastro/professor/professor_bloc.dart';
import 'package:uniprintgestao/src/modules/cadastro/professor/professor_module.dart';

void main() {
  initModule(ProfessorModule());
  ProfessorBloc bloc;

  setUp(() {
    bloc = ProfessorModule.to.bloc<ProfessorBloc>();
  });

  group('ProfessorBloc Test', () {
    test("First Test", () {
      expect(bloc, isInstanceOf<ProfessorBloc>());
    });
  });
}
