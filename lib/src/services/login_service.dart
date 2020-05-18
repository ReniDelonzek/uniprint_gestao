import 'package:firedart/auth/firebase_auth.dart';
import 'package:uniprintgestao/src/app_module.dart';
import 'package:uniprintgestao/src/db/usuario.dart';
import 'package:uniprintgestao/src/interfaces/login_interface.dart';
import 'package:uniprintgestao/src/services/utils_hive_service.dart';
import 'package:uniprintgestao/src/utils/utils_sentry.dart';

class LoginService implements LoginInterface {
  @override
  UsuarioHasura usuario;

  String nomeBox = 'hasura_user';

  @override
  Future<bool> logOut() async {
    try {
      usuario = null;
      FirebaseAuth.instance.signOut();
      await (await AppModule.to.getDependency<HiveService>().getBox(nomeBox))
          .clear();
      return true;
    } catch (e, stackTrace) {
      UtilsSentry.reportError(e, stackTrace);
      return false;
    }
  }
}
