import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/fila_impressoes/fila_impressoes_page.dart';

main() {
  testWidgets('FilaImpressoesPage has title', (WidgetTester tester) async {
    await tester.pumpWidget(
        buildTestableWidget(FilaImpressoesPage(title: 'FilaImpressoes')));
    final titleFinder = find.text('FilaImpressoes');
    expect(titleFinder, findsOneWidget);
  });
}
