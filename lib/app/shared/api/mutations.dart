class Mutations {
  static const String cadastroAtendente = """
mutation cadastrarAtendente(\$ponto_atendimento_id: Int!, \$usuario_id: Int!) {
  insert_atendente(objects: {ponto_atendimento_id: \$ponto_atendimento_id, usuario_id: \$usuario_id}) {
    returning {
      id
    }
  }
}
""";

  static const String cadastroProfessor =
      """mutation cadastroProfessor(\$usuario_id: Int!) {
  update_usuario(where: {id: {_eq: \$usuario_id}}, _set: {tipo_usuario_id: 3}) {
    affected_rows
  }
}
""";

  static const String cadastroMovimentacaoAtendimento = """
mutation cadastroMovimentacaoAtendimento(\$data: timestamptz!, 
\$tipo: Int!, \$usuario_id: Int!, \$atendimento_id: Int!, \$status: Int!) {
  insert_movimentacao(objects: {data: \$data, 
    tipo: \$tipo, 
    usuario_id: \$usuario_id, 
    movimentacao_atendimentos: {data: {atendimento_id: \$atendimento_id}}}) {
    affected_rows
  }
  update_atendimento(_set: {status: \$status}, where: {id: {_eq: \$atendimento_id}}) {
    affected_rows
  }
}
""";

  static const String cadastroMovimentacaoImpressao = """
mutation cadastroMovimentacaoImpressao(\$data: timestamptz!, \$tipo: Int!, \$usuario_id: Int!, \$impressao_id: Int!, \$status: Int!) {
  insert_movimentacao(objects: {data: \$data, tipo: \$tipo, usuario_id: \$usuario_id, movimentacao_impressaos: {data: {impressao_id: \$impressao_id}}}) {
    affected_rows
  }
  update_impressao(_set: {status: \$status}, where: {id: {_eq: \$impressao_id}}) {
    affected_rows
  }
}
""";

  static const String autorizarImpressao = """
mutation cadastroMovimentacaoImpressao(\$data: timestamptz!, \$tipo: Int!, \$usuario_id: Int!, \$impressao_id: Int!, \$status: Int!, \$ponto_atendimento_id: Int!) {
  insert_movimentacao(objects: {data: \$data, tipo: \$tipo, usuario_id: \$usuario_id, movimentacao_impressaos: {data: {impressao_id: \$impressao_id}}}) {
    affected_rows
  }
  update_impressao(_set: {status: \$status, ponto_atendimento_id: \$ponto_atendimento_id}, where: {id: {_eq: \$impressao_id}}) {
    affected_rows
  }
}
""";

  static const String cadastroPrecoImpressao = """
mutation cadastroValorImpressao(\$colorido: Boolean, \$data_fim: timestamp, \$data_inicio: timestamp, \$tipo_folha_id: Int, \$valor: numeric) {
  insert_valor_impressao(objects: {colorido: \$colorido, data_fim: \$data_fim, data_inicio: \$data_inicio, tipo_folha_id: \$tipo_folha_id, valor: \$valor}) {
    affected_rows
  }
}
""";
}
