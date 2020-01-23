import 'dart:async';

import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniprintgestao/src/views/lista_fila_atendimento.dart';

class ScreenLoginEmail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginEmailPage();
  }
}

class LoginEmailPage extends State<ScreenLoginEmail> {
  final controllerEmail = TextEditingController();
  final controllerSenha = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    controllerEmail.addListener(() {});
    controllerSenha.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Builder(
      builder: (context) => new Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('imagens/back_login.jpg'), fit: BoxFit.cover),
        ),
        child: new SizedBox(
            height: 290,
            width: 300,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Insira seu e-mail',
                          labelText: 'Insira seu e-mail'),
                      controller: controllerEmail,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Escolha uma senha',
                          hintText: 'Escolha uma senha'),
                      controller: controllerSenha,
                    ),
                    new Padding(padding: EdgeInsets.all(15)),
                    new ButtonTheme(
                      minWidth: 150,
                      child: new RaisedButton(
                          onPressed: () {
                            if (verificarDados(context)) {
                              logar(context); //criarConta(context);
                            }
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.blue,
                          child: new Text(
                            "Entrar",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    new Padding(padding: EdgeInsets.all(5)),
                    new Text(
                      "Esqueceu a senha?",
                      style: new TextStyle(color: Colors.blue),
                    )
                  ],
                ),
              ),
            )),
      ),
    ));
  }

  bool validarEmail(String email) {
    String regex =
        "[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    RegExp regExp = new RegExp(regex);
    return regExp.hasMatch(email);
  }

  bool verificarDados(BuildContext context) {
    if (!validarEmail(controllerEmail.text)) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Por favor, insira um email válido"),
      ));
      return false;
    } else if (controllerSenha.text.length < 6) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("A senha deve ter no mínimo 6 caracteres"),
      ));
      return false;
    }
    return true;
  }

  void logar(BuildContext context) {
    try {
      FirebaseAuth.instance
          .signIn(controllerEmail.text, controllerSenha.text)
          .then((user) {
        FirebaseAuth.instance.getUser().then((user) {
          if (user == null) {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Ops, houve uma falha ao realizar o login"),
            ));
          } else {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new ListaFilaAtendimento()));
          }
        });
      }).catchError((error) {
        print(error);
        if (error is PlatformException) {
          if (error.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text(
                  "Ops, parece que você já acessou de alguma outra forma com esse e-mail"),
            ));
          } else if (error.code == "ERROR_WRONG_PASSWORD") {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Ops, parece que a sua senha está incorreta"),
            ));
          } else if (error.code == "ERROR_INVALID_EMAIL") {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Ops, o e-mail inserido é inválido"),
            ));
          } else if (error.code == "ERROR_USER_NOT_FOUND") {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Ops, houve uma falha na tentativa de login"),
            ));
          } else if (error.code == "ERROR_USER_DISABLED") {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Ops, parece que seu usuário foi desabilitado"),
            ));
          } else if (error.code == "ERROR_TOO_MANY_REQUESTS") {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text(
                  "Ops, parece que você já tentou entrar diversas vezes com essa conta com as credenciais inválidas"),
            ));
          } else if (error.code == "ERROR_OPERATION_NOT_ALLOWED") {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Ops, parece que sua conta não está ativa"),
            ));
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future criarConta(BuildContext buildContext) async {
    FirebaseAuth.instance
        .signUp(controllerEmail.text, controllerSenha.text)
        .then((user) {
      FirebaseAuth.instance.getUser().then((user) {
        if (user == null) {
          Scaffold.of(buildContext).showSnackBar(new SnackBar(
            content: new Text("Ops, houve uma falha ao realizar o login"),
          ));
        } else {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new ListaFilaAtendimento()));
        }
      });
    }).catchError((error) {
      print(error);
      /*if ((error as PlatformException).code == 'ERROR_WEAK_PASSWORD') {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, parece que a sua senha está incorreta"),
        ));
      } else if ((error as PlatformException).code == "ERROR_INVALID_EMAIL") {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, o e-mail inserido é inválido"),
        ));
      } else if ((error as PlatformException).code ==
          "ERROR_EMAIL_ALREADY_IN_USE") {
        logar(context);
        */ /*Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, o e-mail inserido já está em uso"),
        ));*/ /*
      } else {}*/
    });
  }
}
