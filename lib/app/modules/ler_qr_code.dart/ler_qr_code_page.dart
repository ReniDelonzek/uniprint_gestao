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
  final int codAtendimento;

  LerQrCode(this.codAtendimento);

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

                // Padding(
                //   padding: const EdgeInsets.only(top: 15),
                //   child: Observer(
                //     builder: (_) => Text(
                //       _controller.status,
                //       style: TextStyle(fontSize: 16),
                //     ),
                //   ),
                // )
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
        //.setFrontCamera(false)
        .scan();
    if (_barcodeString == widget.codAtendimento.toString()) {
      atualizarStatus(_barcodeString);
    } else if (_barcodeString != null && _barcodeString.isNotEmpty) {
      Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text('Ops, não foi possível confirmar a senha'),
      ));
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> atualizarStatus(String barcodeString) async {
    ProgressDialog progressDialog = ProgressDialog(buildContext);
    progressDialog.style(message: 'Confirmando atendimento');
    await progressDialog.show();
    if (barcodeString == widget.codAtendimento.toString()) {
      bool result = await UtilsAtendimento.gerarMovimentacao(
          Constants.MOV_ATENDIMENTO_EM_ATENDIMENTO,
          Constants.STATUS_ATENDIMENTO_EM_ATENDIMENTO,
          widget.codAtendimento);
      progressDialog.dismiss();
      if (result) {
        showSnack(buildContext, 'Atendimento marcado como em atendimento',
            dismiss: true);
      } else {
        showSnack(
            buildContext, 'Ops, houve uma falha ao atualizar o atendimento');
      }
    } else if (barcodeString.isNotEmpty) {
      progressDialog.dismiss();
      showSnack(context, 'Ops, não foi possível confirmar a senha');
    } else {
      progressDialog.dismiss();
      Navigator.pop(context);
    }
  }
}
