import 'network/network.dart';

class UtilsNotificacao {
  static Future<bool> enviarNotificacao(
      String title, String body, String usuario_uid) async {
    try {
      var res = await NetWork.post(
          'https://us-central1-uniprint-uv.cloudfunctions.net/enviarNotificacao',
          data: {
            'title': title
                .toString(), //usa .toString() para garantir que seja sempre string
            'body': body.toString(),
            'usuario_uid': usuario_uid.toString(),
            'action': "1".toString()
          });
      if (res != null && isSucesso(res.statusCode)) {
        print('Resposta: ${res.data.toString()}');
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
