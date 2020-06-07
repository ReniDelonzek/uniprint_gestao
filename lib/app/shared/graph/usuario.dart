import 'dart:convert';

import 'nivel_usuario.dart';
import 'pessoa_g.dart';
import 'package:uniprintgestao/app/shared/extensions/map.dart';

class Usuario {
  int id;
  String email;
  String uid;
  String url_foto;
  Pessoa pessoa;
  OsAggregate impressaos_aggregate;
  OsAggregate atendimentos_aggregate;
  DateTime data_criacao;
  List<NivelUsuario> nivel_usuarios;
  Usuario({
    this.id,
    this.email,
    this.uid,
    this.url_foto,
    this.pessoa,
    this.impressaos_aggregate,
    this.atendimentos_aggregate,
    this.data_criacao,
    this.nivel_usuarios,
  });

  Usuario copyWith({
    int id,
    String email,
    String uid,
    String url_foto,
    Pessoa pessoa,
    OsAggregate impressaos_aggregate,
    OsAggregate atendimentos_aggregate,
    DateTime data_criacao,
    List<NivelUsuario> nivel_usuarios,
  }) {
    return Usuario(
      id: id ?? this.id,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      url_foto: url_foto ?? this.url_foto,
      pessoa: pessoa ?? this.pessoa,
      impressaos_aggregate: impressaos_aggregate ?? this.impressaos_aggregate,
      atendimentos_aggregate:
          atendimentos_aggregate ?? this.atendimentos_aggregate,
      data_criacao: data_criacao ?? this.data_criacao,
      nivel_usuarios: nivel_usuarios ?? this.nivel_usuarios,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'uid': uid,
      'url_foto': url_foto,
      'pessoa': pessoa.toMap(),
      'impressaos_aggregate': impressaos_aggregate.toMap(),
      'atendimentos_aggregate': atendimentos_aggregate.toMap(),
      'data_criacao': data_criacao.millisecondsSinceEpoch,
      'nivel_usuarios':
          List<dynamic>.from(nivel_usuarios.map((x) => x.toMap())),
    };
  }

  static Usuario fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Usuario(
      id: map['id'],
      email: map['email'],
      uid: map['uid'],
      url_foto: map['url_foto'],
      pessoa: Pessoa.fromMap(map['pessoa']),
      impressaos_aggregate: OsAggregate.fromMap(map['impressaos_aggregate']),
      atendimentos_aggregate:
          OsAggregate.fromMap(map['atendimentos_aggregate']),
      data_criacao: map.toHasuraDate('data_criacao'),
      nivel_usuarios: map.containsKey('nivel_usuarios')
          ? List<NivelUsuario>.from(
              map['nivel_usuarios']?.map((x) => NivelUsuario.fromMap(x)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  static Usuario fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Usuario(id: $id, email: $email, uid: $uid, url_foto: $url_foto, pessoa: $pessoa, impressaos_aggregate: $impressaos_aggregate, atendimentos_aggregate: $atendimentos_aggregate, data_criacao: $data_criacao, nivel_usuarios: $nivel_usuarios)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Usuario &&
        o.id == id &&
        o.email == email &&
        o.uid == uid &&
        o.url_foto == url_foto &&
        o.pessoa == pessoa &&
        o.impressaos_aggregate == impressaos_aggregate &&
        o.atendimentos_aggregate == atendimentos_aggregate &&
        o.data_criacao == data_criacao &&
        o.nivel_usuarios == nivel_usuarios;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        uid.hashCode ^
        url_foto.hashCode ^
        pessoa.hashCode ^
        impressaos_aggregate.hashCode ^
        atendimentos_aggregate.hashCode ^
        data_criacao.hashCode ^
        nivel_usuarios.hashCode;
  }
}

class OsAggregate {
  Aggregate aggregate;

  OsAggregate({
    this.aggregate,
  });

  Map<String, dynamic> toMap() {
    return {
      'aggregate': aggregate.toMap(),
    };
  }

  static OsAggregate fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OsAggregate(
      aggregate: Aggregate.fromMap(map['aggregate']),
    );
  }

  String toJson() => json.encode(toMap());

  static OsAggregate fromJson(String source) => fromMap(json.decode(source));
}

class Aggregate {
  int count;

  Aggregate({
    this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'count': count,
    };
  }

  static Aggregate fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Aggregate(
      count: map['count'],
    );
  }

  String toJson() => json.encode(toMap());

  static Aggregate fromJson(String source) => fromMap(json.decode(source));
}
