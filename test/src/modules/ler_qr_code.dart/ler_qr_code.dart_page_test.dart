import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/ler_qr_code.dart/ler_qr_code.dart_page.dart';

main() {
  testWidgets('LerQrCodePage has title', (WidgetTester tester) async {
    await tester
        .pumpWidget(buildTestableWidget(LerQrCodePage(title: 'LerQrCode')));
    final titleFinder = find.text('LerQrCode');
    expect(titleFinder, findsOneWidget);
  });
}
