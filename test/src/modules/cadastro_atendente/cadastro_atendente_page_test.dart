import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/cadastro_atendente/cadastro_atendente_page.dart';

main() {
  testWidgets('CadastroAtendentePage has title', (WidgetTester tester) async {
    await tester.pumpWidget(
        buildTestableWidget(CadastroAtendentePage(title: 'CadastroAtendente')));
    final titleFinder = find.text('CadastroAtendente');
    expect(titleFinder, findsOneWidget);
  });
}
