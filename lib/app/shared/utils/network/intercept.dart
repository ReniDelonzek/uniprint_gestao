import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    debugPrint("REQUEST[${options?.method}] => PATH: ${options?.path}");
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    debugPrint(
        "RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    //print("ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
    debugPrint("JSON: ${json.encode(err.request.data)}");
    debugPrint("RETURN:: ${err.response?.data}");
    return super.onError(err);
  }
}
