import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:uniprintgestao/app/shared/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/app/shared/utils/constans.dart';
import 'package:uniprintgestao/app/shared/utils/utils_atendimento.dart';
import 'package:uniprintgestao/app/shared/widgets/widgets.dart';

import 'ler_qr_code_controller.dart';
import 'ler_qr_code_module.dart';

class LerQrCode extends StatefulWidget {
  LerQrCode();

  @override
  State<StatefulWidget> createState() {
    return new LerQrCodePageState();
  }
}

class LerQrCodePageState extends State<LerQrCode> {
  BuildContext buildContext;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return new Scaffold(
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
                FlatButton(
                  child: Text('Tentar Novamente'),
                  onPressed: () {
                    lerCodigo(context);
                  },
                )
              ],
            ),
          );
        }));
  }

  Future lerCodigo(BuildContext context) async {
    var _barcodeString = await new QRCodeReader()
        .setAutoFocusIntervalInMs(200)
        .setForceAutoFocus(true)
        .setTorchEnabled(true)
        .setHandlePermissions(true)
        .setExecuteAfterPermissionGranted(true)
        .scan();
    Navigator.pop(context, _barcodeString);
  }
}
