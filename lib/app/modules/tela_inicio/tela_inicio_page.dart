import 'package:firedart/auth/user_gateway.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:uniprintgestao/app/app_module.dart';
import 'package:uniprintgestao/app/modules/fila_atendimento/fila_atendimento_module.dart';
import 'package:uniprintgestao/app/modules/login/login_module.dart';
import 'package:uniprintgestao/app/shared/utils/auth/hasura_auth_service.dart';
import 'package:uniprintgestao/app/shared/utils/utils_login.dart';
import 'package:uniprintgestao/app/shared/utils/utils_notification.dart';

class TelaInicioPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TelaInicioPageState();
  }
}

class TelaInicioPageState extends State<TelaInicioPage>
    with AfterLayoutMixin<TelaInicioPage> {
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
  Widget build(BuildContext context) {
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

  myBackgroundMessageHandler(Map<String, dynamic> message) {
    String action = getAction(message);
    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic not = message['notification'];
      shoNotification(not['title'], not['body'], action, context);
    }
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    Future.delayed(Duration(seconds: 3), () async {
      User user = await verificarLogin(context);
      if (user != null) {
        AppModule.to
            .getDependency<HasuraAuthService>()
            .obterDadosUsuario(user.id, (value) {
          if (value != null) {
            Route route = MaterialPageRoute(
                builder: (context) => FilaAtendimentoModule());
            Navigator.pushReplacement(context, route);
          } else {
            Route route =
                MaterialPageRoute(builder: (context) => LoginModule());
            Navigator.pushReplacement(context, route);
          }
        });
      }
    });
  }
}
