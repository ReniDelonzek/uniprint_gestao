import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/modules/tela_inicio/tela_inicio_module.dart';
import 'package:uniprintgestao/src/temas/tema.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniPrint ADMIN',
      theme: Tema.getTema(context),
      darkTheme: Tema.getTema(context, darkMode: true),
      //themeMode: ThemeMode.dark,
      home: TelaInicioModule(),
    );
  }
}
