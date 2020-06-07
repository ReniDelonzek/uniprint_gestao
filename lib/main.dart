import 'dart:async';

import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniprintgestao/app/app_module.dart';
import 'package:uniprintgestao/app/shared/utils/utils_sentry.dart';

//Nao é mais necessirio
// void _setTargetPlatformForDesktop() {
//   // No need to handle macOS, as it has now been added to TargetPlatform.
//   if (!Foundation.kIsWeb && (Platform.isLinux || Platform.isWindows)) {
//     debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
//   }
// }

void main() {
  Firestore.initialize('uniprint-uv');
  runZoned<Future<void>>(() async {
    runApp(AppModule());
    UtilsSentry.configureSentry();
  }, onError: UtilsSentry.reportError);
}
