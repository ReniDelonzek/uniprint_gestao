import 'package:mobx/mobx.dart';

part 'chip_button_controller.g.dart';

class ChipButtonController = _ChipButtonBase with _$ChipButtonController;

abstract class _ChipButtonBase with Store {
  @observable
  bool isSelected = false;

  _ChipButtonBase(this.isSelected);
}
