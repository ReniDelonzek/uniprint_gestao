import 'dart:convert';

import 'package:hive/hive.dart';

part 'usuario.g.dart';

@HiveType(typeId: 2)
class UsuarioHasura extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String nome;
  @HiveField(2)
  int codHasura;
  @HiveField(3)
  int codProfessor;
  @HiveField(4)
  int codAtendente;
  @HiveField(5)
  int codPontoAtendimento;

  @HiveField(6)
  String nomePontoAtendimento;

  UsuarioHasura(
      {this.id,
      this.nome,
      this.codHasura,
      this.codProfessor,
      this.codAtendente,
      this.codPontoAtendimento,
      this.nomePontoAtendimento});

  UsuarioHasura copyWith({
    int id,
    String nome,
    int codHasura,
    int codProfessor,
    int codPonto,
    int codPontoAtendimento,
  }) {
    return UsuarioHasura(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      codHasura: codHasura ?? this.codHasura,
      codProfessor: codProfessor ?? this.codProfessor,
      codAtendente: codAtendente ?? this.codAtendente,
      codPontoAtendimento: codPontoAtendimento ?? this.codPontoAtendimento,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'codHasura': codHasura,
      'codProfessor': codProfessor,
      'codAtendente': codAtendente,
      'codPontoAtendimento': codPontoAtendimento,
      'nomePontoAtendimento': nomePontoAtendimento
    };
  }

  static UsuarioHasura fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UsuarioHasura(
        id: map['id'],
        nome: map['nome'],
        codHasura: map['codHasura'],
        codProfessor: map['codProfessor'],
        codAtendente: map['codAtendente'],
        codPontoAtendimento: map['codPontoAtendimento'],
        nomePontoAtendimento: map['nomePontoAtendimento']);
  }

  String toJson() => json.encode(toMap());

  static UsuarioHasura fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'UsuarioHasura id: $id, nome: $nome, codHasura: $codHasura, codProfessor: $codProfessor, codAtendente: $codAtendente, codPontoAtendimento: $codPontoAtendimento';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UsuarioHasura &&
        o.id == id &&
        o.nome == nome &&
        o.codHasura == codHasura &&
        o.codProfessor == codProfessor &&
        o.codAtendente == codAtendente &&
        o.codPontoAtendimento == codPontoAtendimento;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        codHasura.hashCode ^
        codProfessor.hashCode ^
        codAtendente.hashCode ^
        codPontoAtendimento.hashCode;
  }
}
