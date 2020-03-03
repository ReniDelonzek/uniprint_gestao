import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/services/utils_hive_service.dart';
import 'package:uniprintgestao/src/utils/auth/hasura_auth_service.dart';

import 'app_controller.dart';
import 'app_widget.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => AppController()),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => HiveService()),
        Dependency((i) => HasuraAuthService()),
      ];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
