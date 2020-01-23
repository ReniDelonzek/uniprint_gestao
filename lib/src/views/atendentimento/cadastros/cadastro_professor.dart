import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/src/api/graphQlObjetct.dart';
import 'package:uniprintgestao/src/api/querys.dart';
import 'package:uniprintgestao/src/models/graph/usuario_g.dart';
import 'package:uniprintgestao/src/temas/Tema.dart';
import 'package:uniprintgestao/src/views/select_any/select_any_module.dart';
import 'package:uniprintgestao/src/views/select_any/select_any_page.dart';
import 'package:uniprintgestao/src/widgets/button.dart';
import 'package:uniprintgestao/src/widgets/select_widget.dart';
import 'package:uniprintgestao/src/widgets/widgets.dart';

class CadastroProfessor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CadastroProfessorPageState();
  }
}

class CadastroProfessorPageState extends State<CadastroProfessor> {
  Usuario user;
  ProgressDialog dialog;
  List<Map> list = List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Builder(builder: (context) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Cadastrar professor'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              ProgressDialog progressDialog = ProgressDialog(context)
                ..style(message: 'Cadastrando Professor')
                ..show();
              try {
                var res = await GraphQlObject.hasuraConnect.mutation(
                    cadastroProfessor,
                    variables: {'instituicao_id': 1, 'usuario_id': user?.id});
                if (res != null) {
                  showSnack(context, 'Professor cadastrado com sucesso',
                      dismiss: true);
                } else {
                  showSnack(
                      context, 'Ops, houve uma falha ao cadastrar o professor');
                }
              } catch (e) {
                progressDialog.dismiss();
                showSnack(
                    context, 'Ops, houve uma falha ao cadastrar o professor');
                print(e);
              }
            },
            tooltip: 'Adicionar disciplina',
            child: Icon(Icons.done),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: new Container(
              child: Column(
                children: <Widget>[
                  SelectWidget('Selecione o Usuário',
                      user?.pessoa?.nome ?? 'Clique para selecionar', () async {
                    var res = await Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new SelectAnyModule(
                                  'Selecione o Usuário',
                                  SelectAnyPage.TIPO_SELECAO_SIMPLES,
                                  ['nome'],
                                  'id',
                                  query: getUsuarios,
                                )));
                    if (res != null) {
                      setState(() {
                        user = Usuario.fromMap(res);
                        print(user);
                      });
                    }
                  }),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (BuildContext ctxt, int index) =>
                            _getItemList(list[index])),
                  ),
                ],
              ),
            ),
          ));
    });
  }

  Widget _getItemList(Map map) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Turno: ${map['nomeTurno']}'),
            Text('Disciplina: ${map['nomeDisciplina']}'),
            Text('Periodo: ${map['nomePeriodo']}'),
          ],
        ),
      ),
    );
  }

  bool verificarDados(BuildContext context) {
    if (user == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Você precisa selecionar o usuário'),
          duration: Duration(seconds: 3)));
      return false;
    } else
      return true;
  }
}
