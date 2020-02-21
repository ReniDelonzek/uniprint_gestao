String queryAtendimentos = '''subscription atendimentos { 
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

String getUsuarios = """query MyQuery {
  usuario(order_by: {pessoa: {nome: asc}}) {
    id 
    uid
    email
    pessoa {
      nome
    }
  }
}
""";

String cadastroProfessor =
    """mutation MyMutation(\$instituicao_id: Int!, \$usuario_id: Int!) {
  __typename
  insert_professor(objects: {instituicao_id: \$instituicao_id, usuario_id: \$usuario_id}) {
    returning {
      id
    }
  }
}
""";

class Querys {
  static String getAtendimentos = """
subscription getSubsAtendimentos(\$ponto_atendimento_id: Int!) {
  atendimento(where: {status: {_eq: 1}, ponto_atendimento_id: {_eq: \$ponto_atendimento_id}}) {
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

  static String getImpressoes = """
  subscription getImpressoes(\$ponto_atendimento_id: Int!) { 
  impressao(where: {status: {_eq: 1}, ponto_atendimento_id: {_eq: \$ponto_atendimento_id}}) {
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
        }
    arquivo_impressaos {
      colorido
      nome
      quantidade
      url
      tipofolha {
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

  static String somaAtendimentosDia = """
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
}
