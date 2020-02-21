import 'dart:async';

import 'package:firedart/firedart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/app_module.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  Firestore.initialize('uniprint-uv');
  runApp(new AppModule());
}
