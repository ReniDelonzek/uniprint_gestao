class PosicaoAtendimento {
  Data data;

  PosicaoAtendimento({this.data});

  PosicaoAtendimento.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  AtendimentoAggregate atendimentoAggregate;

  Data({this.atendimentoAggregate});

  Data.fromJson(Map<String, dynamic> json) {
    atendimentoAggregate = json['atendimento_aggregate'] != null
        ? new AtendimentoAggregate.fromJson(json['atendimento_aggregate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.atendimentoAggregate != null) {
      data['atendimento_aggregate'] = this.atendimentoAggregate.toJson();
    }
    return data;
  }
}

class AtendimentoAggregate {
  Aggregate aggregate;

  AtendimentoAggregate({this.aggregate});

  AtendimentoAggregate.fromJson(Map<String, dynamic> json) {
    aggregate = json['aggregate'] != null
        ? new Aggregate.fromJson(json['aggregate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aggregate != null) {
      data['aggregate'] = this.aggregate.toJson();
    }
    return data;
  }
}

class Aggregate {
  int count;

  Aggregate({this.count});

  Aggregate.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}