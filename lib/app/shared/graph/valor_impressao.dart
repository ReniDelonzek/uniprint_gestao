import 'dart:convert';

import 'package:uniprintgestao/app/shared/extensions/date.dart';
import 'package:uniprintgestao/app/shared/extensions/string.dart';

class ValorImpressao {
  int id;
  bool colorido;
  DateTime dataFim;
  DateTime dataInicio;
  int tipoFolhaId;
  double valor;
  DateTime versao;
  ValorImpressao({
    this.id,
    this.colorido,
    this.dataFim,
    this.dataInicio,
    this.tipoFolhaId,
    this.valor,
    this.versao,
  });

  ValorImpressao copyWith({
    int id,
    bool colorido,
    DateTime dataFim,
    DateTime dataInicio,
    int tipoFolhaId,
    double valor,
    DateTime versao,
  }) {
    return ValorImpressao(
      id: id ?? this.id,
      colorido: colorido ?? this.colorido,
      dataFim: dataFim ?? this.dataFim,
      dataInicio: dataInicio ?? this.dataInicio,
      tipoFolhaId: tipoFolhaId ?? this.tipoFolhaId,
      valor: valor ?? this.valor,
      versao: versao ?? this.versao,
    );
  }

  Map<String, dynamic> toMap({bool edicao = false}) {
    return {
      'colorido': colorido,
      'data_fim': dataFim?.hasuraFormat(),
      'data_inicio': dataInicio?.hasuraFormat(),
      'tipo_folha_id': tipoFolhaId,
      'valor': valor,
    }..addAll(edicao ? {'id': id} : {});
  }

  static ValorImpressao fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ValorImpressao(
      id: map['id'],
      colorido: map['colorido'],
      dataFim: map['dataFim']?.toString()?.dateFromHasura(),
      dataInicio: map['dataInicio']?.toString()?.dateFromHasura(),
      tipoFolhaId: map['tipo_folha_id'],
      valor: map['valor'],
      versao: DateTime.fromMillisecondsSinceEpoch(map['versao']),
    );
  }

  String toJson() => json.encode(toMap());

  static ValorImpressao fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'ValorImpressao(id: $id, colorido: $colorido, dataFim: $dataFim, dataInicio: $dataInicio, tipoFolhaId: $tipoFolhaId, valor: $valor, versao: $versao)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ValorImpressao &&
        o.id == id &&
        o.colorido == colorido &&
        o.dataFim == dataFim &&
        o.dataInicio == dataInicio &&
        o.tipoFolhaId == tipoFolhaId &&
        o.valor == valor &&
        o.versao == versao;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        colorido.hashCode ^
        dataFim.hashCode ^
        dataInicio.hashCode ^
        tipoFolhaId.hashCode ^
        valor.hashCode ^
        versao.hashCode;
  }
}
