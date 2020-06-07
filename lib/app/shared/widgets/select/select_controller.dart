import 'package:mobx/mobx.dart';

part 'select_controller.g.dart';

class SelectController = _SelectController with _$SelectController;

abstract class _SelectController with Store {
  @observable
  String value;

  _SelectController({this.value});
}
