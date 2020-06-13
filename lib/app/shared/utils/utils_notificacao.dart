import 'package:uniprintgestao/app/shared/utils/utils_sentry.dart';

import 'network/network.dart';

class UtilsNotificacao {
  static Future<bool> enviarNotificacao(
      String title, String body, String usuarioUid) async {
    try {
      var res = await NetWork.post(
          'https://us-central1-uniprint-uv.cloudfunctions.net/enviarNotificacao',
          data: {
            'title': title
                .toString(), //usa .toString() para garantir que seja sempre string
            'body': body.toString(),
            'usuario_uid': usuarioUid.toString(),
            'action': "1".toString()
          });
      if (res != null && isSucesso(res.statusCode)) {
        print('Resposta: ${res.data.toString()}');
        return true;
      }
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
    }
    return false;
  }
}
