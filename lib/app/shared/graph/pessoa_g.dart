import 'dart:convert';

class Pessoa {
  String nome;
  int id;
  Pessoa({
    this.nome,
    this.id,
  });
 

  Pessoa copyWith({
    String nome,
    int id,
  }) {
    return Pessoa(
      nome: nome ?? this.nome,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'id': id,
    };
  }

  static Pessoa fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Pessoa(
      nome: map['nome'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  static Pessoa fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Pessoa nome: $nome, id: $id';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Pessoa &&
      o.nome == nome &&
      o.id == id;
  }

  @override
  int get hashCode => nome.hashCode ^ id.hashCode;
}
