import 'dart:convert';

import 'material.dart';

class ArquivoMaterial {
  MaterialProf material;
  String url;
  String nome;
  ArquivoMaterial({
    this.material,
    this.url,
    this.nome,
  });

  Map<String, dynamic> toMap() {
    return {
      'material': material.toMap(),
      'url': url,
      'nome': nome,
    };
  }

  static ArquivoMaterial fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ArquivoMaterial(
      material: MaterialProf.fromMap(map['material']),
      url: map['url'],
      nome: map['nome'],
    );
  }

  String toJson() => json.encode(toMap());

  static ArquivoMaterial fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'ArquivoMaterial material: $material, url: $url, nome: $nome';
}
