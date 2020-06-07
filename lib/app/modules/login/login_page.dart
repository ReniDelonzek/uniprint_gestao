import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hive/hive.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/app/app_module.dart';
import 'package:uniprintgestao/app/modules/fila_atendimento/fila_atendimento_module.dart';
import 'package:uniprintgestao/app/shared/services/utils_hive_service.dart';
import 'package:uniprintgestao/app/shared/temas/tema.dart';
import 'package:uniprintgestao/app/shared/utils/auth/hasura_auth_service.dart';
import 'package:uniprintgestao/app/shared/utils/utils_sentry.dart';
import 'package:uniprintgestao/app/shared/widgets/widgets.dart';
import 'login_controller.dart';
import 'login_module.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginEmailPage();
  }
}

class LoginEmailPage extends State<LoginPage> {
  final _controller = LoginModule.to.bloc<LoginController>();

  @override
  void initState() {
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
            height: 340,
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
                      controller: _controller.controllerEmail,
                    ),
                    Observer(
                      builder: (_) => TextFormField(
                        obscureText: !_controller.exibirSenha,
                        decoration: InputDecoration(
                          labelText: 'Insira sua senha',
                          hintText: 'Insira sua senha',
                          suffixIcon: new GestureDetector(
                            onTap: () {
                              _controller.exibirSenha =
                                  !_controller.exibirSenha;
                            },
                            child: new Icon(
                              _controller.exibirSenha
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        controller: _controller.controllerSenha,
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 8)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        child: Text(
                          'Esqueci minha senha',
                          style: TextStyle(color: Colors.cyan),
                        ),
                        onTap: () {
                          if (validarEmail(
                              _controller.controllerEmail.text.trim())) {
                            _alterarSenha(context);
                          } else {
                            showSnack(context, 'Por favor, insira seu email');
                          }
                        },
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(8)),
                    new ButtonTheme(
                      minWidth: 150,
                      child: new RaisedButton(
                          onPressed: () async {
                            //if (await DataConnectionChecker().hasConnection) {
                            String msg = verificarDados();
                            if (msg == null) {
                              logar(context); //criarConta(context);
                            } else {
                              showSnack(context, msg);
                            }
                            // } else {
                            //   showSnack(context,
                            //       'Ops, parece que você está sem conexão!');
                            // }
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: getCorPadrao(),
                          child: new Text(
                            "Entrar",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: FlatButton(
                        child: Text('Criar Conta'),
                        onPressed: () {
                          String msg = verificarDados();
                          if (msg == null) {
                            criarConta(context);
                          } else {
                            showSnack(context, msg);
                          }
                        },
                      ),
                    ),
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

  String verificarDados() {
    if (!validarEmail(_controller.controllerEmail.text.trim())) {
      return "Por favor, insira um email válido";
    } else if (_controller.controllerSenha.text.trim().length < 6) {
      return "A senha deve ter no mínimo 6 caracteres";
    }
    return null;
  }

  Future<void> logar(BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context)
      ..style(message: 'Autenticando');
    await progressDialog.show();
    try {
      FirebaseAuth.instance
          .signIn(_controller.controllerEmail.text.trim(),
              _controller.controllerSenha.text.trim())
          .then((user) {
        FirebaseAuth.instance.getUser().then((user) {
          if (user == null) {
            progressDialog.dismiss();
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Ops, houve uma falha ao realizar o login"),
            ));
          } else {
            AppModule.to
                .getDependency<HasuraAuthService>()
                .obterDadosUsuario(user.id, (usuario) {
              progressDialog.dismiss();
              if (usuario != null) {
                Route route = MaterialPageRoute(
                    builder: (context) => FilaAtendimentoModule());
                Navigator?.pushReplacement(context, route);
              } else {
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Ops, houve uma falha ao realizar o login"),
                ));
              }
            });
            //Navigator.of(context).push(new MaterialPageRoute(
            //  builder: (BuildContext context) => new ListaFilaAtendimento()));
          }
        });
      }).catchError((error, stackTrace) {
        UtilsSentry.reportError(error, stackTrace);
        progressDialog.dismiss();
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
        } else {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("Ops, houve uma falha na tentativa de login"),
          ));
        }
      });
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Ops, houve uma falha na tentativa de login"),
      ));
    }
  }

  Future criarConta(BuildContext buildContext) async {
    ProgressDialog progressDialog = ProgressDialog(context)
      ..style(message: 'Criando Conta');
    await progressDialog.show();
    FirebaseAuth.instance
        .signUp(_controller.controllerEmail.text.trim(),
            _controller.controllerSenha.text.trim())
        .then((user) {
      if (user == null) {
        progressDialog.dismiss();
        Scaffold.of(buildContext).showSnackBar(new SnackBar(
          content:
              new Text("Ops, houve uma falha ao realizar ao criar a conta"),
        ));
      } else {
        AppModule.to
            .getDependency<HasuraAuthService>()
            .obterDadosUsuario(user.id, (value) async {
          if (value != null) {
            progressDialog.dismiss();
            await FirebaseAuth.instance.tokenProvider.refresh();
            Box box = await AppModule.to
                .getDependency<HiveService>()
                .getBox('utils_auth');
            await box.put('completar_dados', true);
            Navigator.of(context)?.pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new FilaAtendimentoModule()));
          }
        });
      }
    }).catchError((error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
      progressDialog.dismiss();
      showSnack(buildContext,
          'Ops, houve uma falha ao criar a conta, você já não tem uma conta com esse email?',
          duration: Duration(seconds: 5));
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

  _alterarSenha(BuildContext context) {
    FirebaseAuth.instance
        .resetPassword(_controller.controllerEmail.text.trim())
        .then((value) => {
              showSnack(context,
                  'Um email foi enviado para ${_controller.controllerEmail.text.trim()} com um link para redefinir a senha')
            })
        .catchError((onError) => {
              showSnack(
                  context, 'Ops, houve uma falha ao tentar alterar a senha')
            });
  }
}
