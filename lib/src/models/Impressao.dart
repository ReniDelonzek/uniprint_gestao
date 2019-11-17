import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Impressao {
  String id;
  String codSolicitante;
  DateTime dataSolicitacao;
  String codPonto;
  int status;
  String codAprovador;
  String comentario;
  int satisfacao;
  DateTime dataImpressao;
  DateTime dataEntrega;
  String descricao; //usado para evitar fazer multiplas querys
  double valorTotal; //usado para evitar fazer multiplas querys

  Map<String, dynamic> toJson() => {
        'codSolicitante': codSolicitante,
        'dataSolicitacao': dataSolicitacao,
        'codPonto': codPonto,
        'status': status,
        'codAprovador': codAprovador,
        'comentario': comentario,
        'satisfacao': satisfacao,
        'dataImpressao': dataImpressao,
        'descricao': descricao,
        'valorTotal': valorTotal,
        'dataEntrega': dataEntrega,
        'dataSolicitacao': dataSolicitacao
      };

  static Impressao fromJson(Map<String, dynamic> map) {
    Impressao atendimento = Impressao();
    atendimento.codSolicitante = map['codSolicitante'];

    //atendimento.dataSolicitacao =
    //  (map['dataSolicitacao'] as Timestamp)?.toDate() ?? DateTime.now();
    atendimento.codPonto = map['codPonto'];
    atendimento.status = map['status'];
    atendimento.comentario = map['comentario'];
    atendimento.satisfacao = map['satisfacao'];
    //atendimento.dataImpressao =
    //  (map['dataImpressao'] as Timestamp)?.toDate() ?? DateTime.now();
    //atendimento.dataEntrega =
    //  (map['dataEntrega'] as Timestamp)?.toDate() ?? DateTime.now();
    atendimento.descricao = map['descricao'];
    atendimento.valorTotal = map['valorTotal'];
    return atendimento;
  }
}
