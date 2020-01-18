import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/cadastro/professor/professor_page.dart';

main() {
  testWidgets('ProfessorPage has title', (WidgetTester tester) async {
    await tester
        .pumpWidget(buildTestableWidget(ProfessorPage(title: 'Professor')));
    final titleFinder = find.text('Professor');
    expect(titleFinder, findsOneWidget);
  });
}
