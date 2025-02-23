import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/app/modules/select_any/models/select_model.dart';
import 'package:uniprintgestao/app/modules/select_any/select_any_module.dart';
import 'package:uniprintgestao/app/modules/select_any/select_any_page.dart';
import 'package:uniprintgestao/app/shared/api/querys.dart';
import 'package:uniprintgestao/app/shared/graph/usuario.dart';
import 'package:uniprintgestao/app/shared/widgets/select_widget.dart';
import 'package:uniprintgestao/app/shared/widgets/widgets.dart';

import 'cadastro_professor_controller.dart';
import 'cadastro_professor_module.dart';

class CadastroProfessorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CadastroProfessorPageState();
  }
}

class CadastroProfessorPageState extends State<CadastroProfessorPage> {
  final CadastroProfessorController _controller =
      CadastroProfessorModule.to.bloc<CadastroProfessorController>();
  BuildContext context;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cadastrar professor'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _salvarDados();
          },
          tooltip: 'Adicionar disciplina',
          child: Icon(Icons.done),
        ),
        body: Builder(
          builder: (context) {
            this.context = context;
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: new Container(
                child: Column(
                  children: <Widget>[
                    Observer(
                      builder: (_) => SelectWidget(
                          'Selecione o Usuário',
                          _controller.usuario?.pessoa?.nome ??
                              _controller.usuario?.email ??
                              'Clique para selecionar', () async {
                        var res = await Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new SelectAnyModule(SelectModel(
                                        'Selecione o Usuário',
                                        'id',
                                        [
                                          Linha('pessoa/nome',
                                              valorPadrao: 'Nome não definido'),
                                          Linha('email')
                                        ],
                                        SelectAnyPage.TIPO_SELECAO_SIMPLES,
                                        query: Querys.getUsuariosProf,
                                        chaveLista: 'usuario'))));
                        if (res != null) {
                          _controller.usuario = Usuario.fromMap(res);
                        }
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  _salvarDados() async {
    String msg = _controller.verificarDados();
    if (msg == null) {
      ProgressDialog progressDialog = ProgressDialog(context)
        ..style(message: 'Cadastrando Professor')
        ..show();

      bool sucesso = await _controller.enviarDadosServidor();
      progressDialog.hide();
      if (sucesso) {
        showSnack(context, 'Professor cadastrado com sucesso', dismiss: true);
      } else {
        showSnack(context, 'Ops, houve uma falha ao cadastrar o professor');
      }
    } else {
      showSnack(context, msg);
    }
  }
}
