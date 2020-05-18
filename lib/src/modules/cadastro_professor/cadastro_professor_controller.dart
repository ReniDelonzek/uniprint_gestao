import 'package:mobx/mobx.dart';
import 'package:uniprintgestao/src/models/graph/usuario_g.dart';

part 'cadastro_professor_controller.g.dart';

class CadastroProfessorController = _CadastroProfessorBase
    with _$CadastroProfessorController;

abstract class _CadastroProfessorBase with Store {
  @observable
  Usuario user;
}
