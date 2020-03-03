import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

int getBotaoPressionado(RawKeyEvent event) {
  bool isKeyDown;
  switch (event.runtimeType) {
    case RawKeyDownEvent:
      isKeyDown = true;
      break;
    case RawKeyUpEvent:
      isKeyDown = false;
      break;
    default:
      throw new Exception('Unexpected runtimeType of RawKeyEvent');
  }

  int keyCode;
  switch (event.data.runtimeType) {
    case RawKeyEventDataMacOs:
      final RawKeyEventDataMacOs data = event.data;
      keyCode = data.keyCode;
      break;
    // TODO(https://github.com/flutter/flutter/issues/37830): The Windows and Linux shells share a
    // GLFW implementation. Update once RawKeyEventDataWindows is implemented.
    case RawKeyEventDataLinux:
      final RawKeyEventDataLinux data = event.data;
      keyCode = data.keyCode;
      break;
    default:
    //throw new Exception('Unsupported platform ${event.data.runtimeType}');
  }
  if (!isKeyDown) {
    return keyCode;
  } else
    return -1;
}
