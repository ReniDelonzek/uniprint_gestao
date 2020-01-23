import 'dart:convert';

import 'package:uniprintgestao/src/models/graph/instituicao.dart';
import 'package:uniprintgestao/src/models/graph/usuario_g.dart';

class Professor {
  Usuario usuario;
  Instituicao instituicao;
  Professor({
    this.usuario,
    this.instituicao,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario.toMap(),
      'instituicao': instituicao.toMap(),
    };
  }

  static Professor fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Professor(
      usuario: Usuario.fromMap(map['usuario']),
      instituicao: Instituicao.fromMap(map['instituicao']),
    );
  }

  String toJson() => json.encode(toMap());

  static Professor fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Professor usuario: $usuario, instituicao: $instituicao';
}
