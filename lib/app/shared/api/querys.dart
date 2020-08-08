import 'package:uniprintgestao/app/shared/utils/constans.dart';

class Querys {
  static const String getAtendimentos = """
subscription getSubsAtendimentos(\$ponto_atendimento_id: Int!) {
  atendimento(where: {_or: [{status: {_eq: 1}}, {status: {_eq: 2}}], ponto_atendimento_id: {_eq: \$ponto_atendimento_id}}, order_by: {id: asc}) {
    data_solicitacao
    status
    id
    ponto_atendimento_id
    ponto_atendimento {
      nome
    }
    usuario {
      email
      pessoa {
        nome
      }
      uid
      url_foto
      id
    }
    movimentacao_atendimentos {
      movimentacao {
        data
        tipo
        usuario {
          id
          pessoa {
            nome
          }
        }
      }
    }
  }
}

""";

  static const String getImpressoes = """
  subscription getImpressoes(\$ponto_atendimento_id: Int!) { 
  impressao(where: {_or: [{status: {_eq: 1}}, {status: {_eq: 2}}, {status: {_eq: 3}}], ponto_atendimento_id: {_eq: \$ponto_atendimento_id}}, order_by: {data_criacao: asc}) {
    id
    comentario
    status
    usuario {
          uid
          email
          url_foto
          pessoa {
            nome
          }
          impressaos_aggregate(where: {status: {_eq: ${Constants.STATUS_IMPRESSAO_RETIRADA}}}) {
            aggregate {
              count(columns: id)
            }
          }
          atendimentos_aggregate(where: {status: {_eq: ${Constants.STATUS_ATENDIMENTO_ATENDIDO}}}) {
            aggregate {
              count(columns: id)
            }
          }
          nivel_usuarios {
            nivel_id
            pontuacao
          }
        }
    arquivo_impressaos {
      colorido
      nome
      quantidade
      url
      tipo_folha {
        nome
        id
      }
    }
    movimentacao_impressaos {
      id
      movimentacao_id
      movimentacao {
        data
        tipo
        usuario {
          pessoa {
            nome
          }
        }
      }
    }
  }
}""";

  static const String somaAtendimentosDia = """
query somaAtendimentos {
  ponto_atendimento {
    atendimentos_aggregate(where: {status: {_eq: 3}}) {
      aggregate {
        count(distinct: true, columns: id)
      }
    }
    nome
  }
}

""";

  static const String pontosAtendimento = """
{
  ponto_atendimento(where: {instituicao: {id: {_eq: 1}}}) {
    nome
    id
  }
}
""";

  static const String tiposFolha = """
  {
  tipo_folha {
    id
    nome
  }
}
""";

  static const queryAtendimentos = '''subscription atendimentos { 
  atendimento {
    id
    data_solicitacao
    status
    usuario {
      email
      id
      pessoa {
        nome
      }
    }
  }
}
''';

  static const getUsuariosAtend = """query {
  usuario(where:  { _not: { atendente: {}}}) {
    id
    uid
    email
    pessoa {
      nome
    }
    
  }
}
""";

  static const getUsuariosProf = """query getUsuariosNaoProfessores {
  usuario(where: {tipo_usuario_id: {_neq: 3}}) {
    id
    uid
    email
    pessoa {
      nome
    }
  }
}
""";

  static const String getSincronizacao = """
  query valoresImpressao {
  tipo_folha {
    id
    nome 
  }
}
""";

  static const String getListaPrecos = """
  query getListaPrecos {
  valor_impressao {
		valor
    data_inicio
    data_fim
    colorido
    tipo_folha {
      nome
    }
  }
}
  """;

  static const String getUsuarioUID = """
query getUsuarioUid(\$uid: String!) {
  usuario(where: {uid: {_eq: \$uid}, atendente: {}}) {
    id
    atendente {
      id
      ponto_atendimento_id
    }
  }
}

""";
}
