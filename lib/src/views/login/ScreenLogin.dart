import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uniprintgestao/src/utils/UtilsColors.dart';

import '../mainpage.dart';
import 'ScreenLoginEmail.dart';

class ScreenLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPage();
  }
}

class LoginPage extends State<ScreenLogin> {
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    googleSignIn.signOut();
    //initUser();
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
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new ButtonTheme(
                  height: 45,
                  minWidth: 250,
                  child: RaisedButton(
                    onPressed: () {
                      startingLoginFacebook();
                    },
                    color: Color(UtilsColors.hexToInt("FF2A5F8E")),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: new Text(
                      "FACEBOOK",
                      style: new TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
              new Padding(padding: EdgeInsets.all(8)),
              new ButtonTheme(
                  height: 45,
                  minWidth: 250,
                  child: RaisedButton(
                    onPressed: () {
                      signInWithGoogle();
                    },
                    color: Color(UtilsColors.hexToInt("FFDC4E41")),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: new Text(
                      "GOOGLE",
                      style: new TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
              new Padding(padding: EdgeInsets.all(8)),
              new ButtonTheme(
                  height: 45,
                  minWidth: 250,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new ScreenLoginEmail()));
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: new Text(
                      "EMAIL",
                      style: new TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          )),
    );
  }

  Future<Null> signInWithGoogle() async {
    if (googleAccount == null) {
      // Start the sign-in process:
      googleAccount = await googleSignIn.signIn();
      print(googleAccount.email);
    }
    FirebaseUser firebaseUser = await signIntoFirebase(googleAccount);
    if (firebaseUser != null) {
      FirebaseMessaging().subscribeToTopic('atendente');
      Route route = MaterialPageRoute(builder: (context) => MainPage());
      Navigator.pushReplacement(context, route);
    } else {
      Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text('Oops, não foi possível logar, tente novamente')));
    }
  }

  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);
    if (googleAccount == null) {
    } else {
      await signInWithGoogle();
    }
  }

  Future<GoogleSignInAccount> getSignedInAccount(
      GoogleSignIn googleSignIn) async {
    GoogleSignInAccount account = googleSignIn.currentUser;
    if (account == null) {
      account = await googleSignIn.signInSilently();
    }
    return account;
  }

  Future<FirebaseUser> signIntoFirebase(
      GoogleSignInAccount googleSignInAccount) async {
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;
    print(googleAuth.accessToken);
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    //AuthCredential credential = FirebaseAuth.instance.signInWithCredential(credential);
    var user = await FirebaseAuth.instance.signInWithCredential(credential);
    if (user != null) {
      return user.user;
    } else {
      print('Falha ao logar usuario');
    }
  }

  startingLoginFacebook() async {
    var facebookLogin = new FacebookLogin();
    var result = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        var user = await FirebaseAuth.instance.signInWithCredential(credential);
        if (user != null) {
          FirebaseMessaging().subscribeToTopic('atendente');
          Route route = MaterialPageRoute(builder: (context) => MainPage());
          Navigator.pushReplacement(context, route);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("O login foi cancelado");
        break;
      case FacebookLoginStatus.error:
        print("Houve um erro");
        break;
    }
  }

  bool verificarDados() {}

  _validateAndSubmit() async {
    setState(() {
      //_errorMessage = "";
      //_isLoading = true;
    });
    String userId = "";
    try {} catch (e) {
      print('Error: $e');
      setState(() {});
    }
  }
}
