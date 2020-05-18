import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/utils/utils_login.dart';
import 'package:uniprintgestao/src/utils/utils_notification.dart';

class TelaInicioPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TelaInicioPageState();
  }
}

class TelaInicioPageState extends State<TelaInicioPage> {
  int opacity = 0;
  var buildContext;
  double width = 0, height = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        opacity = 1;
        width = 200;
        height = 200;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () async {
      verificarLogin(context);
    });
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
  }

  /*void _firebaseCloudMessagingListeners() {
    if (Platform.isIOS) _iOSPermission();

    String action;

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        action = getAction(message);
        shoNotification(message['notification']['title'],
            message['notification']['body'], action, context);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        action = getAction(message);
        shoNotification(message['notification']['title'],
            message['notification']['body'], action, context);
      },
      onResume: (Map<String, dynamic> message) async {
        action = getAction(message);
        shoNotification(message['notification']['title'],
            message['notification']['body'], action, context);
      },
    );
  }*/
/*
  void _iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}*/

  String getAction(Map message) {
    if (message.containsKey('data')) {
      return message['data']['action'];
    }
    return '';
  }

// ignore: missing_return
  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    String action = getAction(message);
    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic not = message['notification'];
      shoNotification(not['title'], not['body'], action, context);
    }
  }
}
