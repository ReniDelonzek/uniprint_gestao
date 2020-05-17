import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/lista_atendentes/lista_atendentes_page.dart';

main() {
  testWidgets('ListaAtendentesPage has title', (WidgetTester tester) async {
    await tester.pumpWidget(
        buildTestableWidget(ListaAtendentesPage(title: 'ListaAtendentes')));
    final titleFinder = find.text('ListaAtendentes');
    expect(titleFinder, findsOneWidget);
  });
}
