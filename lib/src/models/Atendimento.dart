class Atendimento {
  String id;
  String codSolicitante;
  DateTime dataSolicitacao;
  String codPonto;
  int status;
  int satisfacao;
  DateTime dataAtendimento;

  Map<String, dynamic> toJson() => {
    'codSolicitante': codSolicitante,
        'dataSolicitacao': dataSolicitacao,
        'codPonto': codPonto,
        'status': status,
        'satisfacao': satisfacao,
      };

  static Atendimento fromJson(Map<String, dynamic> map) {
    Atendimento atendimento = Atendimento();
    atendimento.codSolicitante = map['codSolicitante'];
    atendimento.dataSolicitacao = map['dataSolicitacao'] ?? DateTime.now();
    atendimento.codPonto = map['codPonto'];
    atendimento.status = map['status'];
    atendimento.satisfacao = map['satisfacao'];
    atendimento.dataAtendimento = map['dataAtendimento'] ?? DateTime.now();
    return atendimento;
  }
}
