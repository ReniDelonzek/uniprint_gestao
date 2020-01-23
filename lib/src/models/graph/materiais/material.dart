import 'dart:convert';

import '../ponto_atendimento.dart';
import '../professor_turma.dart';
import '../tipo_folha.dart';
import 'arquivo_material.dart';

class MaterialProf {
  DateTime data_publicacao;
  int tipo;
  String titulo;
  TipoFolha tipo_folha;
  bool colorido;
  PontoAtendimento ponto_atendimento;
  ProfessorTurma professor_turma;
  List<ArquivoMaterial> arquivos;
  MaterialProf({
    this.data_publicacao,
    this.tipo,
    this.titulo,
    this.tipo_folha,
    this.colorido,
    this.ponto_atendimento,
    this.professor_turma,
    this.arquivos,
  });

  MaterialProf copyWith({
    DateTime data_publicacao,
    int tipo,
    String titulo,
    TipoFolha tipo_folha,
    bool colorido,
    PontoAtendimento ponto_atendimento,
    ProfessorTurma professor_turma,
    List<ArquivoMaterial> arquivos,
  }) {
    return MaterialProf(
      data_publicacao: data_publicacao ?? this.data_publicacao,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      tipo_folha: tipo_folha ?? this.tipo_folha,
      colorido: colorido ?? this.colorido,
      ponto_atendimento: ponto_atendimento ?? this.ponto_atendimento,
      professor_turma: professor_turma ?? this.professor_turma,
      arquivos: arquivos ?? this.arquivos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data_publicacao': data_publicacao.millisecondsSinceEpoch,
      'tipo': tipo,
      'titulo': titulo,
      'tipo_folha': tipo_folha.toMap(),
      'colorido': colorido,
      'ponto_atendimento': ponto_atendimento.toMap(),
      'professor_turma': professor_turma.toMap(),
      'arquivos': List<dynamic>.from(arquivos.map((x) => x.toMap())),
    };
  }

  static MaterialProf fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MaterialProf(
      data_publicacao:
          DateTime.fromMillisecondsSinceEpoch(map['data_publicacao']),
      tipo: map['tipo'],
      titulo: map['titulo'],
      tipo_folha: TipoFolha.fromMap(map['tipo_folha']),
      colorido: map['colorido'],
      ponto_atendimento: PontoAtendimento.fromMap(map['ponto_atendimento']),
      professor_turma: ProfessorTurma.fromMap(map['professor_turma']),
      arquivos: List<ArquivoMaterial>.from(
          map['arquivos']?.map((x) => ArquivoMaterial.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static MaterialProf fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'MaterialProf data_publicacao: $data_publicacao, tipo: $tipo, titulo: $titulo, tipo_folha: $tipo_folha, colorido: $colorido, ponto_atendimento: $ponto_atendimento, professor_turma: $professor_turma, arquivos: $arquivos';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MaterialProf &&
        o.data_publicacao == data_publicacao &&
        o.tipo == tipo &&
        o.titulo == titulo &&
        o.tipo_folha == tipo_folha &&
        o.colorido == colorido &&
        o.ponto_atendimento == ponto_atendimento &&
        o.professor_turma == professor_turma &&
        o.arquivos == arquivos;
  }

  @override
  int get hashCode {
    return data_publicacao.hashCode ^
        tipo.hashCode ^
        titulo.hashCode ^
        tipo_folha.hashCode ^
        colorido.hashCode ^
        ponto_atendimento.hashCode ^
        professor_turma.hashCode ^
        arquivos.hashCode;
  }
}
