import 'package:firedart/auth/firebase_auth.dart';
import 'package:uniprintgestao/app/app_module.dart';
import 'package:uniprintgestao/app/shared/db/usuario.dart';
import 'package:uniprintgestao/app/shared/services/utils_hive_service.dart';
import 'package:uniprintgestao/app/shared/utils/utils_sentry.dart';

class LoginService {
  UsuarioHasura usuario;

  String nomeBox = 'hasura_user';

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
