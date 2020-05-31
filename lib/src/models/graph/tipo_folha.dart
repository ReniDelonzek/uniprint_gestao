import 'dart:convert';

class TipoFolha {
  int id;
  String nome;
  TipoFolha({
    this.id,
    this.nome,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
    };
  }

  static TipoFolha fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TipoFolha(
      id: map['id'],
      nome: map['nome'],
    );
  }

  String toJson() => json.encode(toMap());

  static TipoFolha fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'TipoFolha nome: $nome';
}
