import 'dart:convert';

import 'package:intl/intl.dart';

import 'movimentacao_g.dart';
import 'ponto_atendimento.dart';
import 'usuario.dart';

class Atendimento {
  int id;
  int status;
  DateTime data_solicitacao;
  int ponto_atendimento_id;
  Usuario usuario;
  PontoAtendimento ponto_atendimento;
  List<MovimentacaoAtendimento> movimentacao_atendimentos;

  Atendimento(
      this.id,
      this.status,
      this.data_solicitacao,
      this.ponto_atendimento_id,
      this.usuario,
      this.movimentacao_atendimentos,
      this.ponto_atendimento);

  Atendimento copyWith({
    int id,
    int status,
    DateTime data_solicitacao,
    int ponto_atendimento_id,
    Usuario usuario,
    List<MovimentacaoAtendimento> movimentacao_atendimentos,
  }) {
    return Atendimento(
        id ?? this.id,
        status ?? this.status,
        data_solicitacao ?? this.data_solicitacao,
        ponto_atendimento_id ?? this.ponto_atendimento_id,
        usuario ?? this.usuario,
        movimentacao_atendimentos ?? this.movimentacao_atendimentos,
        ponto_atendimento ?? this.ponto_atendimento);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'data_solicitacao': data_solicitacao.millisecondsSinceEpoch,
      'ponto_atendimento_id': ponto_atendimento_id,
      'usuario': usuario.toMap(),
      'ponto_atendimento': ponto_atendimento.toMap(),
      'movimentacao_atendimentos':
          List<dynamic>.from(movimentacao_atendimentos.map((x) => x.toMap())),
    };
  }

  static Atendimento fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Atendimento(
      map['id'],
      map['status'],
      (map['data_solicitacao'] != null)
          ? DateFormat('yyyy-MM-ddTHH:mm:ss').parse(map['data_solicitacao'])
          : DateTime.now(),
      map['ponto_atendimento_id'],
      Usuario.fromMap(map['usuario']),
      List<MovimentacaoAtendimento>.from(map['movimentacao_atendimentos']
          ?.map((x) => MovimentacaoAtendimento.fromMap(x))),
      PontoAtendimento.fromMap(map['ponto_atendimento']),
    );
  }

  String toJson() => json.encode(toMap());

  static Atendimento fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Atendimento id: $id, status: $status, data_solicitacao: $data_solicitacao, ponto_atendimento_id: $ponto_atendimento_id, usuario: $usuario, movimentacao_atendimentos: $movimentacao_atendimentos';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Atendimento &&
        o.id == id &&
        o.status == status &&
        o.data_solicitacao == data_solicitacao &&
        o.ponto_atendimento_id == ponto_atendimento_id &&
        o.usuario == usuario &&
        o.movimentacao_atendimentos == movimentacao_atendimentos;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        status.hashCode ^
        data_solicitacao.hashCode ^
        ponto_atendimento_id.hashCode ^
        usuario.hashCode ^
        movimentacao_atendimentos.hashCode;
  }
}
