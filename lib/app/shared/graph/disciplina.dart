import 'dart:convert';

class Disciplina {
  String nome;
  Disciplina({
    this.nome,
  });
 
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
    };
  }

  static Disciplina fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Disciplina(
      nome: map['nome'],
    );
  }

  String toJson() => json.encode(toMap());

  static Disciplina fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Disciplina nome: $nome';
 
}
