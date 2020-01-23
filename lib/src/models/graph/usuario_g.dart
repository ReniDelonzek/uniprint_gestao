import 'dart:convert';

import 'pessoa_g.dart';

class Usuario {
  int id;
  String email;
  String uid;
  String url_foto;

  Pessoa pessoa;
  Usuario({
    this.id,
    this.email,
    this.uid,
    this.url_foto,
    this.pessoa,
  });

  Usuario copyWith({
    int id,
    String email,
    String uid,
    String url_foto,
    Pessoa pessoa,
  }) {
    return Usuario(
      id: id ?? this.id,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      url_foto: url_foto ?? this.url_foto,
      pessoa: pessoa ?? this.pessoa,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'uid': uid,
      'url_foto': url_foto,
      'pessoa': pessoa.toMap(),
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
    );
  }

  String toJson() => json.encode(toMap());

  static Usuario fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Usuario id: $id, email: $email, uid: $uid, url_foto: $url_foto, pessoa: $pessoa';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Usuario &&
        o.id == id &&
        o.email == email &&
        o.uid == uid &&
        o.url_foto == url_foto &&
        o.pessoa == pessoa;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        uid.hashCode ^
        url_foto.hashCode ^
        pessoa.hashCode;
  }
}
