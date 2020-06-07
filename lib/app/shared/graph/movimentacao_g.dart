import 'dart:convert';

import 'package:intl/intl.dart';

class Movimentacao {
  DateTime data;
  int tipo;
  Movimentacao({
    this.data,
    this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': data.millisecondsSinceEpoch,
      'tipo': tipo,
    };
  }

  static Movimentacao fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Movimentacao(
      data: DateFormat('yyyy-MM-ddTHH:mm:ss')
          .parse(map['data']), //DateTime.fromMillisecondsSinceEpoch(),
      tipo: map['tipo'],
    );
  }

  String toJson() => json.encode(toMap());

  static Movimentacao fromJson(String source) => fromMap(json.decode(source));
}

class MovimentacaoAtendimento {
  Movimentacao movimentacao;
  MovimentacaoAtendimento({
    this.movimentacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'movimentacao': movimentacao.toMap(),
    };
  }

  static MovimentacaoAtendimento fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MovimentacaoAtendimento(
      movimentacao: Movimentacao.fromMap(map['movimentacao']),
    );
  }

  String toJson() => json.encode(toMap());

  static MovimentacaoAtendimento fromJson(String source) =>
      fromMap(json.decode(source));
}
