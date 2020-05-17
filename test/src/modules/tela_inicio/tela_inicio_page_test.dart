import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/tela_inicio/tela_inicio_page.dart';

main() {
  testWidgets('TelaInicioPage has title', (WidgetTester tester) async {
    await tester
        .pumpWidget(buildTestableWidget(TelaInicioPage(title: 'TelaInicio')));
    final titleFinder = find.text('TelaInicio');
    expect(titleFinder, findsOneWidget);
  });
}
