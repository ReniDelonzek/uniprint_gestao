import 'package:uniprintgestao/src/models/usuario.dart';

class GraphAtendimento {
  DateTime data_solicitacao;
  int status;
  Usuario usuario;

  static GraphAtendimento fromJson(Map<String, dynamic> map) {
    GraphAtendimento obj = GraphAtendimento();
    obj.data_solicitacao = map['data_solicitacao'];
    obj.status = map['status'];
    obj.usuario = map['usuario'];
    return obj;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['data_solicitacao'] = this.data_solicitacao;
    map['status'] = this.status;
    map['usuario'] = this.usuario;
    return map;
  }
}

class GraphUsuario {
  String email;
  String url_foto;

  static GraphUsuario fromJson(Map<String, dynamic> map) {
    GraphUsuario obj = GraphUsuario();
    obj.email = map['email'];
    obj.url_foto = map['url_foto'];
    return obj;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['email'] = this.email;
    map['url_foto'] = this.url_foto;
    return map;
  }
}

gerarToString(String nome, String a) {
  List<String> colunas = a.split(';');
  String s = "static $nome fromJson(Map<String, dynamic> map) {\n";
  s += "$nome obj = $nome();\n";
  for (String coluna in colunas) {
    coluna = coluna.split(' ').last;
    if (coluna.isNotEmpty) s += "obj.$coluna = map['$coluna'];\n";
  }
  s += "return obj;\n}\n";
  s += "Map<String, dynamic> toJson() {\nMap<String, dynamic> map = Map();\n";
  for (String coluna in colunas) {
    coluna = coluna.split(' ').last;
    if (coluna.isNotEmpty) s += "map['$coluna'] = this.$coluna;\n";
  }
  s += "return map;\n}\n";
  return s;
}
