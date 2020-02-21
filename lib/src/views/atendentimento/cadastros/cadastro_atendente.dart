import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/src/api/graphQlObjetct.dart';
import 'package:uniprintgestao/src/api/mutations.dart';
import 'package:uniprintgestao/src/api/querys.dart';
import 'package:uniprintgestao/src/models/graph/ponto_atendimento.dart';
import 'package:uniprintgestao/src/models/graph/usuario_g.dart';
import 'package:uniprintgestao/src/temas/Tema.dart';
import 'package:uniprintgestao/src/views/select_any/models/select_model.dart';
import 'package:uniprintgestao/src/views/select_any/select_any_module.dart';
import 'package:uniprintgestao/src/views/select_any/select_any_page.dart';
import 'package:uniprintgestao/src/widgets/button.dart';
import 'package:uniprintgestao/src/widgets/select_widget.dart';
import 'package:uniprintgestao/src/widgets/widgets.dart';

import 'package:uniprintgestao/src/utils/network/network.dart';

class CadastroAtendente extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CadastroAtendentePageState();
  }
}

class CadastroAtendentePageState extends State<CadastroAtendente> {
  Usuario user;
  PontoAtendimento local;
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
          title: Text('Cadastro operador'),
        ),
        body: Builder(builder: (context) {
          return new Container(
            child: Column(
              children: <Widget>[
                SelectWidget('Selecione o usuário', user?.pessoa?.nome,
                    () async {
                  var res = await Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new SelectAnyModule(SelectModel(
                                  'Selecione o Usuário',
                                  'id',
                                  [Linha('pessoa/nome'), Linha('email')],
                                  SelectAnyPage.TIPO_SELECAO_SIMPLES,
                                  query: getUsuarios,
                                  chaveLista: 'usuario'))));
                  if (res != null) {
                    setState(() {
                      user = Usuario.fromMap(res);
                      print(user);
                    });
                  }
                }),
                LocaisAtendimento('Ponto de atendimento', (local) {
                  setState(() {
                    this.local = local;
                  });
                }, local: local),
                new Padding(padding: EdgeInsets.only(top: 25)),
                Button('Salvar', () async {
                  ProgressDialog progress = ProgressDialog(context)
                    ..style(message: 'Cadastrando atendente')
                    ..show();
                  try {
                    var res = await GraphQlObject.hasuraConnect
                        .mutation(Mutations.cadastroAtendente, variables: {
                      'ponto_atendimento_id': local.id,
                      'usuario_id': user.id
                    });

                    if (res != null) {
                      var atendenteID =
                          res['data']['insert_atendente']['returning'][0]['id'];
                      var resFire = await Dio().post(
                          'https://us-central1-uniprint-uv.cloudfunctions.net/criarAtendente',
                          data: {
                            'usuario_uid': user?.uid,
                            'atendente_id': atendenteID,
                            'ponto_id': local.id
                          });
                      progress.dismiss();
                      if (resFire.sucesso()) {
                        showSnack(context, 'Atendente cadastrado com sucesso',
                            dismiss: true);
                      } else {
                        showSnack(context,
                            'Ops, houve uma falha ao cadastrar o atendente');
                      }
                    } else {
                      progress.dismiss();
                      showSnack(context,
                          'Ops, houve uma falha ao cadastrar o atendente');
                    }
                  } catch (e) {
                    progress.dismiss();
                    showSnack(context,
                        'Ops, houve uma falha ao cadastrar o atendente');
                    print(e);
                  }
                })
              ],
            ),
          );
        }));
  }

  bool verificarDados(BuildContext context) {
    if (user == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Você precisa selecionar o usuário'),
          duration: Duration(seconds: 3)));
      return false;
    } else if (local == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Você precisa selecionar o usuário'),
        duration: Duration(seconds: 3),
      ));
      return false;
    } else
      return true;
  }
}
