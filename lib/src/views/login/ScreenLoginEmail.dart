import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../mainpage.dart';

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
      body: new Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('imagens/back_login.jpg'), fit: BoxFit.cover),
        ),
        child: new SizedBox(
            height: 280,
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
                      decoration:
                          InputDecoration(labelText: 'Insira seu e-mail'),
                      controller: controllerEmail,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Escolha uma senha'),
                      controller: controllerSenha,
                    ),
                    new Padding(padding: EdgeInsets.all(15)),
                    new ButtonTheme(
                      minWidth: 150,
                      child: new RaisedButton(
                          onPressed: () {
                            if (verificarDados()) {
                              logar();
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
    );
  }

  bool validarEmail(String email) {
    String regex =
        "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:";
    RegExp regExp = new RegExp(regex);
    return regExp.hasMatch(email);
  }

  bool verificarDados() {
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

  Future logar() async {
    AuthResult user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: controllerEmail.text, password: controllerSenha.text));
    //user.additionalUserInfo.

    if (user == null) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Ops, houve uma falha ao realizar o login"),
      ));
    } else {
      FirebaseMessaging().subscribeToTopic('atendente');
      Route route = MaterialPageRoute(builder: (context) => MainPage());
      Navigator.pushReplacement(context, route);
    }
  }
}
