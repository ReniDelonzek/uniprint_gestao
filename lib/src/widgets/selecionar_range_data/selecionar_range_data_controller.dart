import 'package:mobx/mobx.dart';
import '../../extensions/date.dart';

part 'selecionar_range_data_controller.g.dart';

class SelecionarRangeDataController = _SelecionarRangeDataController
    with _$SelecionarRangeDataController;

abstract class _SelecionarRangeDataController with Store {
  @observable
  DateTime dataInicial = DateTime.now();
  @observable
  DateTime dataFinal = (new DateTime.now()).add(new Duration(days: 7));

  DateTime dataMin = (new DateTime.now()).subtract(new Duration(days: 60));
  DateTime dataMax = (new DateTime.now()).add(new Duration(days: 365));

  @computed
  String get data =>
      '${dataInicial?.string('dd/MM/yyyy')} - ${dataFinal?.string('dd/MM/yyyy') ?? ''}';

  _SelecionarRangeDataController(
      {this.dataInicial, this.dataFinal, this.dataMin, this.dataMax}) {
    if (this.dataFinal == null) {
      dataFinal = (new DateTime.now()).add(new Duration(days: 7));
    }
    if (dataInicial == null) {
      dataInicial = DateTime.now();
    }
  }
}
