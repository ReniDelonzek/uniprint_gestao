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
  usuario {
    id, 
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
subscription getSubsAtendimentos {
  atendimento(where: {status: {_eq: 1}, ponto_atendimento_id: {_eq: 1}}) {
    data_solicitacao
    status
    id
    ponto_atendimento_id
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
  subscription getImpressoes { 
  impressao(where: {status: {_eq: 1}}) {
    comentario
    status
    movimentacao_impressaos {
      id
      movimentacao_id
      movimentacao {
        data
        tipo
        usuario {
          email
          url_foto
          pessoa {
            nome
          }
        }
      }
    }
  }
}""";
}
