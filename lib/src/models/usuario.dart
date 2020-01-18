class Usuario {
  int id;
  String nome;
  String email;

  static Usuario fromJson(Map<String, dynamic> map) {
    Usuario usuario = Usuario();
    usuario.nome = map['nome'];
    usuario.email = map['email'];
    return usuario;
  }
}
