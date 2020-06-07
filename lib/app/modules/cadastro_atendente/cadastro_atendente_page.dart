import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/app/modules/select_any/models/select_model.dart';
import 'package:uniprintgestao/app/modules/select_any/select_any_module.dart';
import 'package:uniprintgestao/app/modules/select_any/select_any_page.dart';
import 'package:uniprintgestao/app/shared/api/querys.dart';
import 'package:uniprintgestao/app/shared/graph/usuario.dart';
import 'package:uniprintgestao/app/shared/widgets/button.dart';
import 'package:uniprintgestao/app/shared/widgets/pontos_atendimento/pontos_atendimento_controller.dart';
import 'package:uniprintgestao/app/shared/widgets/pontos_atendimento/pontos_atendimento_widget.dart';
import 'package:uniprintgestao/app/shared/widgets/select_widget.dart';
import 'package:uniprintgestao/app/shared/widgets/widgets.dart';

import 'cadastro_atendente_controller.dart';
import 'cadastro_atendente_module.dart';

class CadastroAtendentePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CadastroAtendentePageState();
  }
}

class CadastroAtendentePageState extends State<CadastroAtendentePage> {
  final CadastroAtendenteController _controller =
      CadastroAtendenteModule.to.bloc<CadastroAtendenteController>();

  ProgressDialog dialog;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Cadastro Atendente'),
        ),
        body: Builder(builder: (context) {
          return new Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Observer(
                    builder: (_) => SelectWidget(
                        'Selecione o usuário', _controller.user?.pessoa?.nome,
                        () async {
                      var res = await Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new SelectAnyModule(SelectModel(
                                      'Selecione o Usuário',
                                      'id',
                                      [Linha('pessoa/nome'), Linha('email')],
                                      SelectAnyPage.TIPO_SELECAO_SIMPLES,
                                      query: Querys.getUsuariosAtend,
                                      chaveLista: 'usuario'))));
                      if (res != null) {
                        _controller.user = Usuario.fromMap(res);
                      }
                    }),
                  ),
                ),
                PontosAtendimentoWidget('Ponto de atendimento', (local) {
                  _controller.local = local;
                }, PontosAtendimentoController(_controller.local)),
                new Padding(padding: EdgeInsets.only(top: 25)),
                Button('Salvar', () async {
                  String msg = _controller.verificarDados();
                  if (msg == null) {
                    ProgressDialog progress = ProgressDialog(context)
                      ..style(message: 'Cadastrando atendente');
                    await progress.show();
                    bool sucesso = await _controller.salvarDados();
                    progress.dismiss();
                    if (sucesso) {
                      showSnack(context, 'Atendente cadastrado com sucesso',
                          dismiss: true);
                    } else {
                      showSnack(context,
                          'Ops, houve uma falha ao cadastrar o atendente');
                    }
                  } else {
                    showSnack(context, msg);
                  }
                })
              ],
            ),
          );
        }));
  }

  bool verificarDados(BuildContext context) {
    if (_controller.user == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Você precisa selecionar o usuário'),
          duration: Duration(seconds: 3)));
      return false;
    } else if (_controller.local == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Você precisa selecionar o usuário'),
        duration: Duration(seconds: 3),
      ));
      return false;
    } else
      return true;
  }
}
