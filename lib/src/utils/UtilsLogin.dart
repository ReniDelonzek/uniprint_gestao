import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/views/lista_fila_atendimento.dart';
import 'package:uniprintgestao/src/views/login/screen_login_email.dart';

import 'PreferenceToken.dart';

void verificarLogin(context) {
  PreferencesStore.create().then((t) {
    FirebaseAuth.initialize("AIzaSyDUG3j3b8mG2xdO9XknCL7jTB_MdD3xBa4", t);
    if (t.hasToken) {
      FirebaseAuth.instance.getUser().then((user) {
        if (user == null) {
          navegarLogin(context);
        } else {
          Route route =
              MaterialPageRoute(builder: (context) => ListaFilaAtendimento());
          Navigator.pushReplacement(context, route);
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
  Route route = MaterialPageRoute(builder: (context) => ScreenLoginEmail());
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