import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/src/api/graphQlObjetct.dart';
import 'package:uniprintgestao/src/models/usuario.dart';
import 'package:uniprintgestao/src/temas/Tema.dart';
import 'package:uniprintgestao/src/views/select_any/select_any_module.dart';
import 'package:uniprintgestao/src/views/select_any/select_any_page.dart';
import 'package:uniprintgestao/src/widgets/select_widget.dart';

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
  Future<void> initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return GraphQLProvider(
        client: graphQlObject.client,
        child: new MaterialApp(
            theme: Tema.getTema(context),
            home: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text('Cadastrar professor'),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    /*var item =
                    await Navigator.of(buildContext).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new ListaTurnos(
                              tipoSelecao: 1,
                            )));
                setState(() {
                  list.add(item);
                });*/
                  },
                  tooltip: 'Adicionar disciplina',
                  child: Icon(Icons.add),
                ),
                body: Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: new Container(
                      child: Column(
                        children: <Widget>[
                          SelectWidget('Selecione o Usuário',
                              user?.nome ?? 'Clique para selecionar', () async {
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
                                user = Usuario.fromJson(res);
                              });
                            }
                          }),
                          Expanded(
                            child: ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (BuildContext ctxt, int index) =>
                                    _getItemList(list[index])),
                          ),
                          Mutation(
                              options:
                                  MutationOptions(document: cadastroProfessor),
                              builder: (
                                RunMutation runMutation,
                                QueryResult result,
                              ) {
                                if (result.loading) {
                                  return CircularProgressIndicator();
                                }
                                if (result.data != null) {
                                  Navigator.pop(buildContext);
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new ButtonTheme(
                                      height: 45,
                                      minWidth: 120,
                                      child: RaisedButton(
                                        onPressed: () async {
                                          runMutation({
                                            'instituicao_id': 1,
                                            'usuario_id': user?.id
                                          });
                                        },
                                        color: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.5),
                                        ),
                                        child: new Text(
                                          'SALVAR',
                                          style: new TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                );
                              }),
                        ],
                      ),
                    ),
                  );
                }))));
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

String getUsuarios = """query MyQuery {
  usuario {
    id, 
    email
    pessoa {
      nome
    }
  }
}
""";

String cadastroProfessor =
    """mutation MyMutation(\$instituicao_id: Int!, \$usuario_id: Int!) {
  __typename
  insert_professor(objects: {instituicao_id: \$instituicao_id, usuario_id: \$usuario_id}) {
    returning {
      id
    }
  }
}
""";
