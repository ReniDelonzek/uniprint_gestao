import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/temas/Tema.dart';

import 'login/ScreenLogin.dart';
import 'mainpage.dart';

void main() => runApp(new SplashScreen());

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging _firebaseMessaging;
  int opacity = 0;
  var buildContext;
  double width = 0, height = 0;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        opacity = 1;
        width = 200;
        height = 200;
      });
    });
    Future.delayed(Duration(seconds: 3), () {
      verificarLogin(buildContext);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: Tema.getTema(context),
        home: Builder(builder: ((context) {
          buildContext = context;
          return new Scaffold(
            body: new Container(
              alignment: Alignment.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    width: width,
                    height: height,
                    child: AnimatedOpacity(
                      child: FlutterLogo(
                        size: 200.0,
                      ),
                      opacity: opacity.toDouble(),
                      duration: Duration(milliseconds: 1500),
                    ),
                  ),
                  /* new Image.asset(
                  'imagens/back_login.jpg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover, //logo do app
                ),*/
                ],
              ),
            ),
          );
        })));
  }

  void verificarLogin(context) {
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        if (user == null) {
          Route route = MaterialPageRoute(builder: (context) => ScreenLogin());
          Navigator.pushReplacement(context, route);
        } else {
          Route route = MaterialPageRoute(builder: (context) => MainPage());
          Navigator.pushReplacement(context, route);
        }
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print('token: ' + token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
