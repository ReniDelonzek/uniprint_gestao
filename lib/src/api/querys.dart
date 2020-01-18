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
