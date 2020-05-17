import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/fila_atendimento/fila_atendimento_page.dart';

main() {
  testWidgets('FilaAtendimentoPage has title', (WidgetTester tester) async {
    await tester.pumpWidget(
        buildTestableWidget(FilaAtendimentoPage(title: 'FilaAtendimento')));
    final titleFinder = find.text('FilaAtendimento');
    expect(titleFinder, findsOneWidget);
  });
}
