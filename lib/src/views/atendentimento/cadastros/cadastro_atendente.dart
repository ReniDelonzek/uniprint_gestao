import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/src/models/LocalAtendimento.dart';
import 'package:uniprintgestao/src/models/usuario.dart';
import 'package:uniprintgestao/src/temas/Tema.dart';
import 'package:uniprintgestao/src/widgets/widgets.dart';

class CadastroAtendente extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CadastroAtendentePageState();
  }
}

class CadastroAtendentePageState extends State<CadastroAtendente> {
  Usuario user;
  LocalAtendimento local;
  ProgressDialog dialog;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        color: Colors.white,
        theme: Tema.getTema(context),
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Cadastro operador'),
            ),
            body: Builder(builder: (context) {
              return new Container(
                child: Column(
                  children: <Widget>[
                    InkWell(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                  user?.nome ??
                                      user?.email ??
                                      'Selecione o funcionário',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                      onTap: () async {
                        /*Usuario user = await Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new SelecionarUsuario()));
                        if (user != null) {
                          setState(() {
                            this.user = user;
                          });
                        }*/
                      },
                    ),
                    LocaisAtendimento('Ponto de atendimento', (local) {
                      setState(() {
                        this.local = local;
                      });
                    }, local: local),
                    new Padding(padding: EdgeInsets.only(top: 25)),
                    new ButtonTheme(
                        height: 45,
                        minWidth: 220,
                        child: RaisedButton(
                          onPressed: () {
                            if (verificarDados(context)) {
                              dialog = ProgressDialog(context,
                                  type: ProgressDialogType.Normal,
                                  isDismissible: false,
                                  showLogs: true);
                              /*Firestore.instance
                                  .collection('Atendentes')
                                  .document(user.id)
                                  .set({
                                'codUsu': user.id,
                                'nome': user.nome,
                                'dataAdicao': DateTime.now(),
                                'codPonto': local.id
                              }).then((res) {
                                dialog.dismiss();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Cadastrado com sucesso'),
                                  duration: Duration(seconds: 3),
                                ));
                              }).catchError((error) {
                                dialog.dismiss();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Cadastrado com sucesso'),
                                  duration: Duration(seconds: 3),
                                ));
                              });*/
                            }
                          },
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.5),
                          ),
                          child: new Text(
                            'SALVAR',
                            style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
              );
            })));
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
