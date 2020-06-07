import 'dart:convert';

class Instituicao {
  String nome;
  String cnpj;
  Instituicao({
    this.nome,
    this.cnpj,
  });
 

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cnpj': cnpj,
    };
  }

  static Instituicao fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Instituicao(
      nome: map['nome'],
      cnpj: map['cnpj'],
    );
  }

  String toJson() => json.encode(toMap());

  static Instituicao fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Instituicao nome: $nome, cnpj: $cnpj';

}
