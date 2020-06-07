import 'package:dio/dio.dart';
import '../preference_token.dart';
import 'intercept.dart';

class NetWork {
  static Future<Response> post(String url,
      {Map data, List<Map> dataList}) async {
    final Dio dio = Dio();
    var options = Options();
    dio.interceptors.add(CustomInterceptors());
    var a = await PreferencesStore.create();
    var token = "Bearer ${a?.refreshToken ?? ''}";
    options.headers = {"Authorization": 'Bearer $token'};

    Response response =
        await dio.post(url, data: data ?? dataList, options: options);
    return response;
  }
}

isSucesso(int code) {
  return code == 200 || code == 204;
}

extension Network on Response {
  bool sucesso() {
    return (this != null && isSucesso(this.statusCode) && this.data != null);
  }
}
