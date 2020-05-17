import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';

import 'package:uniprintgestao/src/modules/ler_qr_code.dart/ler_qr_code.dart_controller.dart';
import 'package:uniprintgestao/src/modules/ler_qr_code.dart/ler_qr_code.dart_module.dart';

void main() {
  initModule(LerQrCodeModule.dart());
  LerQrCodeController lerqrcode;

  setUp(() {
    lerqrcode = LerQrCodeModule.dart.to.bloc<LerQrCodeController>();
  });

  group('LerQrCodeController Test', () {
    test("First Test", () {
      expect(lerqrcode, isInstanceOf<LerQrCodeController>());
    });

    test("Set Value", () {
      expect(lerqrcode.value, equals(0));
      lerqrcode.increment();
      expect(lerqrcode.value, equals(1));
    });
  });
}
