import 'dart:convert';

class Periodo {
  String nome;
  Periodo({
    this.nome,
  });

  Periodo copyWith({
    String nome,
  }) {
    return Periodo(
      nome: nome ?? this.nome,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
    };
  }

  static Periodo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Periodo(
      nome: map['nome'],
    );
  }

  String toJson() => json.encode(toMap());

  static Periodo fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Periodo nome: $nome';
 
}
