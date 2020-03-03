import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Constans.dart';

BuildContext context;

void shoNotification(
    String title, String body, String payload, BuildContext buildContext) {
  context = buildContext;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = new IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1', 'CHANNEL', 'Teste',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics,
      payload: payload);
}

Future onSelectNotification(String payload) async {
  if (payload == Constants.NOFITICACAO_CHAMADA_ATENDIMENTO.toString()) {
    //verificarLogin(context);
  }
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  //verificarLogin(context);
  // display a dialog with the notification details, tap ok to go to another page
  /*showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Route route =
                  MaterialPageRoute(builder: (context) => MainPrinter());
              Navigator.pushReplacement(context, route);
            },
          )
        ],
      ),
    );*/
}
