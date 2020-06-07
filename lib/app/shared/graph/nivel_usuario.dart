import 'dart:convert';

class NivelUsuario {
  int nivelId;
  int pontuacao;

  NivelUsuario({
    this.nivelId,
    this.pontuacao,
  });

  NivelUsuario copyWith({
    int nivelId,
    int pontuacao,
  }) {
    return NivelUsuario(
      nivelId: nivelId ?? this.nivelId,
      pontuacao: pontuacao ?? this.pontuacao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nivelId': nivelId,
      'pontuacao': pontuacao,
    };
  }

  static NivelUsuario fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return NivelUsuario(
      nivelId: map['nivelId'],
      pontuacao: map['pontuacao'],
    );
  }

  String toJson() => json.encode(toMap());

  static NivelUsuario fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'NivelUsuario(nivelId: $nivelId, pontuacao: $pontuacao)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is NivelUsuario &&
        o.nivelId == nivelId &&
        o.pontuacao == pontuacao;
  }

  @override
  int get hashCode => nivelId.hashCode ^ pontuacao.hashCode;
}
