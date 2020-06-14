import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String title;

  const TextTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 16, left: 15, right: 16),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 18),
        ));
  }
}

Future<bool> showSnack(BuildContext context, String text,
    {bool dismiss, dynamic data, Duration duration}) async {
  try {
    FocusScope.of(context).requestFocus(FocusNode());
    if (text != null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(text),
        duration: duration ?? Duration(seconds: 2),
      ));
    }
    await Future.delayed(duration ?? Duration(seconds: 2));
    if (dismiss != null && dismiss) {
      NavigatorState nav = Navigator.of(context);
      if (nav != null && nav.canPop()) {
        nav?.pop(data);
      }
    }
    return true;
  } catch (error) {
    //UtilsSentry.reportError(error,stackTrace,);
    return false;
  }
}
