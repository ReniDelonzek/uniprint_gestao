import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/modules/fila_atendimento/fila_atendimento_module.dart';
import 'package:uniprintgestao/src/modules/login/login_module.dart';

import '../app_module.dart';
import 'auth/hasura_auth_service.dart';
import 'preference_token.dart';

void verificarLogin(context) {
  PreferencesStore.create().then((t) {
    FirebaseAuth.initialize("AIzaSyDUG3j3b8mG2xdO9XknCL7jTB_MdD3xBa4", t);
    if (t.hasToken) {
      FirebaseAuth.instance.getUser().then((user) {
        if (user == null) {
          navegarLogin(context);
        } else {
          AppModule.to
              .getDependency<HasuraAuthService>()
              .obterDadosUsuario(user.id, (value) {
            if (value != null) {
              Route route = MaterialPageRoute(
                  builder: (context) => FilaAtendimentoModule());
              Navigator.pushReplacement(context, route);
            } else {
              navegarLogin(context);
            }
          });
        }
        //});
      }).catchError((onError) {
        print(onError);
        navegarLogin(context);
      });
    } else {
      navegarLogin(context);
    }
  }).catchError((error) {
    print(error);
  });
}

navegarLogin(var context) {
  Route route = MaterialPageRoute(builder: (context) => LoginModule());
  Navigator.pushReplacement(context, route);
}
/*
void posLogin(AuthResult user, BuildContext context) {
  if (user != null) {
    SharedPreferences.getInstance().then((shared) {
      Firestore.instance
          .collection('Usuarios')
          .document(user.user.uid)
          .collection('tokens')
          .add({'messaging_token': shared.getString('messaging_token')});
      //FirebaseMessaging().subscribeToTopic('teste');
      Route route = MaterialPageRoute(builder: (context) => MainPrinter());
      Navigator.pushReplacement(context, route);
    }).catchError((error) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Ops, houve uma falha na tentativa de login"),
      ));
    });
  } else {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Ops, houve uma falha na tentativa de login"),
    ));
  }
}*/
