import 'package:mobx/mobx.dart';

part 'ler_qr_code_controller.g.dart';

class LerQrCodeController = _LerQrCodeBase with _$LerQrCodeController;

abstract class _LerQrCodeBase with Store {
  @observable
  String status = "";
}
