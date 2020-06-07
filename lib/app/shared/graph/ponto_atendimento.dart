import 'dart:convert';

import 'instituicao.dart';

class PontoAtendimento {
  int id;
  String nome;
  Instituicao instituicao;
  PontoAtendimento({
    this.id,
    this.nome,
    this.instituicao,
  });

  PontoAtendimento copyWith({
    int id,
    String nome,
    Instituicao instituicao,
  }) {
    return PontoAtendimento(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      instituicao: instituicao ?? this.instituicao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'instituicao': instituicao.toMap(),
    };
  }

  static PontoAtendimento fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PontoAtendimento(
      id: map['id'],
      nome: map['nome'],
      instituicao: Instituicao.fromMap(map['instituicao']),
    );
  }

  String toJson() => json.encode(toMap());

  static PontoAtendimento fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'PontoAtendimento id: $id, nome: $nome, instituicao: $instituicao';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PontoAtendimento &&
        o.id == id &&
        o.nome == nome &&
        o.instituicao == instituicao;
  }

  @override
  int get hashCode => id.hashCode ^ nome.hashCode ^ instituicao.hashCode;
}
