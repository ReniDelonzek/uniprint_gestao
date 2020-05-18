import 'package:uniprintgestao/src/db/usuario.dart';

abstract class LoginInterface {
  UsuarioHasura usuario;
  Future<bool> logOut();
}
