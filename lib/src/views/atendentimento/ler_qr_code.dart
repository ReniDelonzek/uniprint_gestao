import 'dart:async';

import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:uniprintgestao/src/temas/Tema.dart';

class LerQrCode extends StatefulWidget {
  String atendimentoID;

  LerQrCode(this.atendimentoID);

  @override
  State<StatefulWidget> createState() {
    return new LerQrCodePageState(atendimentoID);
  }
}

class LerQrCodePageState extends State<LerQrCode> {
  BuildContext buildContext;
  String atendimentoID;
  ProgressDialog progressDialog;
  String status = "";

  LerQrCodePageState(this.atendimentoID);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return new MaterialApp(
        theme: Tema.getTema(context),
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text("Ler QRCode"),
            ),
            body: Builder(builder: (context) {
              lerCodigo(buildContext);
              this.buildContext = context;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: () {
                        lerCodigo(context);
                      },
                      color: Colors.blue,
                      child: Text(
                        'Tentar novamente',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        status,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              );
            })));
  }

  Future lerCodigo(BuildContext context) async {
    var _barcodeString = await new QRCodeReader()
        .setAutoFocusIntervalInMs(200)
        .setForceAutoFocus(true)
        .setTorchEnabled(true)
        .setHandlePermissions(true)
        .setExecuteAfterPermissionGranted(true)
        //.setFrontCamera(false)
        .scan();
    print(_barcodeString);
    if (_barcodeString == atendimentoID) {
      atualizarStatus(_barcodeString);
    } else if (_barcodeString != null && _barcodeString.isNotEmpty) {
      Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text('Ops, não foi possível confirmar a senha'),
      ));
    } else {
      Navigator.pop(context);
    }
  }

  void atualizarStatus(String barcodeString) {
    progressDialog = ProgressDialog(buildContext);
    progressDialog.style(message: 'Confirmando atendimento');
    progressDialog.show();

    Firestore.instance
        .collection('Empresas')
        .document('Uniguacu')
        .collection('Pontos')
        .document("1")
        .collection("Atendimentos")
        .document(barcodeString)
        .update({"status": 2, "dataAtendimento": DateTime.now()}).then(
            (sucess) {
      progressDialog.dismiss();
      setState(() {
        status = "Atendimento confirmado com sucesso";
      });
      /*Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text(status),
      ));*/
      Future.delayed(Duration(milliseconds: 1500), () {
        Navigator.pop(context);
      });
    }).catchError((error) {
      progressDialog.dismiss();
      print(error);
      setState(() {
        status = "Ops, houve um erro ao finalizar o atendimento";
      });
      /*Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text('Ops, houve um erro ao finalizar o atendimento'),
      ));*/
    });
  }
}
