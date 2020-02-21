import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/cadastro_preco/cadastro_preco_page.dart';

main() {
  testWidgets('CadastroPrecoPage has title', (WidgetTester tester) async {
    await tester.pumpWidget(
        buildTestableWidget(CadastroPrecoPage(title: 'CadastroPreco')));
    final titleFinder = find.text('CadastroPreco');
    expect(titleFinder, findsOneWidget);
  });
}
