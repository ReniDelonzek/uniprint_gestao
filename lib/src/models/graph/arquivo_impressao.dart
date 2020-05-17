import 'dart:convert';

import 'package:uniprintgestao/src/models/graph/tipo_folha.dart';

class ArquivoImpressao {
  String url;
  String nome;
  bool colorido;
  int quantidade;
  String tipo_folha_id;
  TipoFolha tipofolha;

  String path;
  ArquivoImpressao({
    this.url,
    this.nome,
    this.colorido,
    this.quantidade,
    this.tipo_folha_id,
    this.tipofolha,
  });

  ArquivoImpressao copyWith({
    String url,
    String nome,
    bool colorido,
    int quantidade,
    String tipo_folha_id,
    TipoFolha tipo_folha,
  }) {
    return ArquivoImpressao(
      url: url ?? this.url,
      nome: nome ?? this.nome,
      colorido: colorido ?? this.colorido,
      quantidade: quantidade ?? this.quantidade,
      tipo_folha_id: tipo_folha_id ?? this.tipo_folha_id,
      tipofolha: tipo_folha ?? this.tipofolha,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'nome': nome,
      'colorido': colorido,
      'quantidade': quantidade,
      'tipo_folha_id': tipo_folha_id,
      'tipofolha': tipofolha.toMap(),
    };
  }

  static ArquivoImpressao fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ArquivoImpressao(
      url: map['url'],
      nome: map['nome'],
      colorido: map['colorido'],
      quantidade: map['quantidade'],
      tipo_folha_id: map['tipo_folha_id'],
      tipofolha: TipoFolha.fromMap(map['tipofolha']),
    );
  }

  String toJson() => json.encode(toMap());

  static ArquivoImpressao fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() {
    return 'ArquivoImpressao url: $url, nome: $nome, colorido: $colorido, quantidade: $quantidade, tipo_folha_id: $tipo_folha_id, tipo_folha: $tipofolha';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ArquivoImpressao &&
        o.url == url &&
        o.nome == nome &&
        o.colorido == colorido &&
        o.quantidade == quantidade &&
        o.tipo_folha_id == tipo_folha_id &&
        o.tipofolha == tipofolha;
  }

  @override
  int get hashCode {
    return url.hashCode ^
        nome.hashCode ^
        colorido.hashCode ^
        quantidade.hashCode ^
        tipo_folha_id.hashCode ^
        tipofolha.hashCode;
  }
}
