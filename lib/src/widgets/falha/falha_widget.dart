import 'package:flutter/material.dart';

class FalhaWidget extends StatelessWidget {
  final String mensagem;

  FalhaWidget(this.mensagem);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.vertical,
        spacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Image.asset(
            'imagens/icon_fail.png',
            width: 100,
            height: 100,
          ),
          Text('Opss!',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          Text(mensagem)
        ],
      ),
    );
  }
}
