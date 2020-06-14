import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

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
