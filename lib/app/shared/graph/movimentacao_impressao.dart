import 'dart:convert';

import 'movimentacao_g.dart';

class MovimentacaoImpressao {
  Movimentacao movimentacao;
  MovimentacaoImpressao({
    this.movimentacao,
  });

  MovimentacaoImpressao copyWith({
    Movimentacao movimentacao,
  }) {
    return MovimentacaoImpressao(
      movimentacao: movimentacao ?? this.movimentacao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movimentacao': movimentacao.toMap(),
    };
  }

  static MovimentacaoImpressao fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MovimentacaoImpressao(
      movimentacao: Movimentacao.fromMap(map['movimentacao']),
    );
  }

  String toJson() => json.encode(toMap());

  static MovimentacaoImpressao fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() => 'MovimentacaoImpressao movimentacao: $movimentacao';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MovimentacaoImpressao && o.movimentacao == movimentacao;
  }

  @override
  int get hashCode => movimentacao.hashCode;
}
