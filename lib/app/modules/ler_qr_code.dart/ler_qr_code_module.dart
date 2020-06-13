import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import 'ler_qr_code_controller.dart';
import 'ler_qr_code_page.dart';

class LerQrCodeModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => LerQrCodeController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => LerQrCode();

  static Inject get to => Inject<LerQrCodeModule>.of();
}
