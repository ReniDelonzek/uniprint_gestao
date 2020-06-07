import 'package:uniprintgestao/app/shared/db/usuario.dart';

abstract class LoginInterface {
  UsuarioHasura usuario;
  Future<bool> logOut();
}
