import 'dart:async';
import 'dart:io';

import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

import 'src/app_module.dart';
import 'src/utils/utils_sentry.dart';

void _setTargetPlatformForDesktop() {
  // No need to handle macOS, as it has now been added to TargetPlatform.
  if (!Foundation.kIsWeb && (Platform.isLinux || Platform.isWindows)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _setTargetPlatformForDesktop();

  Firestore.initialize('uniprint-uv');
  runZoned<Future<void>>(() async {
    runApp(AppModule());
    UtilsSentry.configureSentry();
  }, onError: UtilsSentry.reportError);
}
