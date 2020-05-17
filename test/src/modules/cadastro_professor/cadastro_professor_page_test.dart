import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/cadastro_professor/cadastro_professor_page.dart';

main() {
  testWidgets('CadastroProfessorPage has title', (WidgetTester tester) async {
    await tester.pumpWidget(
        buildTestableWidget(CadastroProfessorPage(title: 'CadastroProfessor')));
    final titleFinder = find.text('CadastroProfessor');
    expect(titleFinder, findsOneWidget);
  });
}
