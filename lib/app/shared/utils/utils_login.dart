import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:uniprintgestao/app/shared/utils/utils_sentry.dart';

import 'preference_token.dart';

Future<User> verificarLogin(context) async {
  try {
    PreferencesStore preferencesStore = await PreferencesStore.create();
    FirebaseAuth.initialize(
        "AIzaSyDUG3j3b8mG2xdO9XknCL7jTB_MdD3xBa4", preferencesStore);
    if (preferencesStore.hasToken) {
      return await FirebaseAuth.instance.getUser();
    }
  } catch (error, stackTrace) {
    UtilsSentry.reportError(error, stackTrace,
        data: 'Pode ter sido erro quando o usuario não está logado');
  }
  return null;
}
