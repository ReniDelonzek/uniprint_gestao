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
  impressao(where: {_or: [{status: {_eq: 1}}, {status: {_eq: 2}}], ponto_atendimento_id: {_eq: \$ponto_atendimento_id}}) {
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
  usuario(where:  { _not: { atendentes: {}}}) {
    id
    uid
    email
    pessoa {
      nome
    }
    atendentes_aggregate {
      aggregate {
        count(columns: id)
      }
    }
  }
}
""";

  static const getUsuariosProf = """query {
  usuario(where:  { _not: { professors: {}}}) {
    id
    uid
    email
    pessoa {
      nome
    }
    professors_aggregate {
      aggregate {
        count(columns: id)
      }
    }
  }
}
""";

  static const String cadastroProfessor =
      """mutation MyMutation(\$instituicao_id: Int!, \$usuario_id: Int!) {
  __typename
  insert_professor(objects: {instituicao_id: \$instituicao_id, usuario_id: \$usuario_id}) {
    returning {
      id
    }
  }
}
""";
}
