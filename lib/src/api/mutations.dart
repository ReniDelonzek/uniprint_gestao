class Mutations {
  static String cadastroAtendente = """
mutation cadastrarAtendente(\$ponto_atendimento_id: Int!, \$usuario_id: Int!) {
  insert_atendente(objects: {ponto_atendimento_id: \$ponto_atendimento_id, usuario_id: \$usuario_id}) {
    affected_rows
  }
}
""";

  static String cadastroMovimentacaoAtendimento = """
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

  static String cadastroMovimentacaoImpressao = """
mutation cadastroMovimentacaoImpressao(\$data: timestamptz!, \$tipo: Int!, \$usuario_id: Int!, \$impressao_id: Int!, \$status: Int!) {
  insert_movimentacao(objects: {data: \$data, tipo: \$tipo, usuario_id: \$usuario_id, movimentacao_impressaos: {data: {impressao_id: \$impressao_id}}}) {
    affected_rows
  }
  update_impressao(_set: {status: \$status}, where: {id: {_eq: \$impressao_id}}) {
    affected_rows
  }
}
""";
}
