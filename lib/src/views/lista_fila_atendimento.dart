import 'dart:async';

import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:uniprintgestao/src/models/Atendimento.dart';
import 'package:uniprintgestao/src/temas/Tema.dart';

import 'lista_fila_impressao.dart';

class ListaFilaAtendimento extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ListaFilaAtendimentoPageState();
  }
}

class ListaFilaAtendimentoPageState extends State<ListaFilaAtendimento> {
  List<Atendimento> atendimentos = List();
  Icon icon = Icon(Icons.done);
  double currentPageValue = 0.0;
  List<String> tamanhosFolha = List();
  Stream slides;
  PageController controller = PageController();
  BuildContext buildContext;
  ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    _queryDb();
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page;
      });
    });

    return new MaterialApp(
        theme: Tema.getTema(context),
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text(
                "Fila de atendimentos",
                style: new TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            floatingActionButton: new FloatingActionButton(
              onPressed: () {
                Navigator.of(buildContext).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new ListaFilaImpressao()));
              },
              heroTag: "impressoes",
              child: Icon(Icons.print),
            ),
            backgroundColor: Colors.white,
            body: _getBodyAtendimento()));
  }

  Widget _getFragent(BuildContext context, AsyncSnapshot snap) {
    var doc = snap.data as List<Document>;

    atendimentos.clear();

    for (var data in doc) {
      Atendimento atendimento = Atendimento.fromJson(data.map);
      //atendimento.id = data.documentID;
      atendimentos.add(atendimento);
    }
    if (atendimentos.isNotEmpty) {
      return new PageView.builder(
        controller: controller,
        itemCount: atendimentos.length,
        itemBuilder: (context, position) {
          return _buildStoryPage(atendimentos[position],
              position == currentPageValue.floor(), position);
        },
      );
    } else
      return Center(
        child: Text('Nenhum atendimento na fila'),
      );
  }

  _buildStoryPage(Atendimento atendimento, bool active, int index) {
    // Animated Properties
    final double blur = active ? 30 : 30;
    final double offset = active ? 20 : 10;
    final double top = active ? 20 : 60;

    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 10, right: 5, left: 5),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
            color: Colors.black26,
            blurRadius: blur,
            offset: Offset(offset, offset))
      ]),
      child: _getCard(atendimento, index),
    );
  }

  Widget _getCard(Atendimento atendimento, int index) {
    return SingleChildScrollView(
      child: (Container(
          height: 500,
          padding: EdgeInsets.all(15.0),
          child: new Card(
              child: new Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  //CabecalhoDetalhesUsuario(atendimento.codSolicitante),
                  InkWell(
                    onTap: () {
                      //Navigator.of(context).push(new MaterialPageRoute(
                      //  builder: (BuildContext context) => new Test()));
                    },
                    child: new Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'imagens/qr_code.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  new Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: 'chamar_novamente',
                            tooltip: 'Chamar novamente',
                            child: Image.asset(
                              'imagens/chamar_icone.png',
                              width: 20,
                              height: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              /*Firestore.instance
                                  .collection('Empresas')
                                  .document('Uniguacu')
                                  .collection('Pontos')
                                  .document('1')
                                  .collection('Atendimentos')
                                  .document(atendimento.id)
                                  .collection('Chamadas')
                                  .add({
                                'data': DateTime.now().millisecondsSinceEpoch
                              }).then((value) {
                                Scaffold.of(buildContext).showSnackBar(
                                    new SnackBar(
                                        content:
                                            Text('Notificado com sucesso')));
                              }).catchError((error) {
                                Scaffold.of(buildContext).showSnackBar(new SnackBar(
                                    content: Text(
                                        'Ops, houve uma falha ao notificar o usuário')));
                              });*/
                            },
                          ),
                          FloatingActionButton(
                            heroTag: 'finalizar_atendimento',
                            tooltip: 'Finalizar atendimento',
                            onPressed: () {
                              Firestore.instance
                                  .collection('Empresas')
                                  .document('Uniguacu')
                                  .collection('Pontos')
                                  .document("1")
                                  .collection("Atendimentos")
                                  .document(atendimento.id)
                                  .update({
                                "status": 2,
                                "dataAtendimento":
                                DateTime.now().millisecondsSinceEpoch
                              }).then((sucess) {
                                Scaffold.of(buildContext).showSnackBar(SnackBar(
                                  content: Text(
                                      'Atendimento finalizado com sucesso'),
                                ));
                              }).catchError((error) {
                                Scaffold.of(buildContext).showSnackBar(SnackBar(
                                  content: Text(
                                      'Ops, houve um erro ao finalizar o atendimento'),
                                ));
                              });
                            },
                            child: Icon(Icons.done),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          )))),
    );
  }

  Future lerCodigo(BuildContext context, Atendimento atendimento) async {
    var _barcodeString = await new QRCodeReader()
        .setAutoFocusIntervalInMs(200)
        .setForceAutoFocus(true)
        .setTorchEnabled(true)
        .setHandlePermissions(true)
        .setExecuteAfterPermissionGranted(true)
        //.setFrontCamera(false)
        .scan();
    print(_barcodeString);
    if (_barcodeString == atendimento.id) {
      atualizarStatus(atendimento);
    } else if (_barcodeString.isNotEmpty) {
      Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text('Ops, não foi possível confirmar a senha'),
      ));
    } else {
      Navigator.pop(context);
    }
  }

  void atualizarStatus(Atendimento atendimento) {
    progressDialog = ProgressDialog(buildContext);
    progressDialog.style(
      message: 'Confirmando atendimento',
      progressWidget: SpinKitThreeBounce(
        color: Colors.blue,
      ),
    );
    progressDialog.show();

    /*Firestore.instance
        .collection('Empresas')
        .document('Uniguacu')
        .collection('Pontos')
        .document(atendimento.codPonto.toString())
        .collection("Atendimentos")
        .document(atendimento.id)
        .updateData({"status": 2, "dataAtendimento": DateTime.now()}).then(
            (sucess) {
      progressDialog.dismiss();
      Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text('Atendimento confirmado com sucesso'),
      ));
    }).catchError((error) {
      progressDialog.dismiss();
      print(error);
      Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text('Ops, houve um erro ao finalizar o atendimento'),
      ));
    });*/
  }

  _queryDb() async {
    /*Query query = Firestore.instance
        .collection("Empresas")
        .document("Uniguacu")
        .collection("Pontos")
        .document('1')
        .collection('Atendimentos');*/
    //.where('status', isEqualTo: 0)
    //.orderBy("dataSolicitacao", descending: true);

    // Map the documents to the data payload
    Firestore.initialize('uniprint-uv');
    slides = Firestore.instance
        .collection("Empresas")
        .document("Uniguacu")
        .collection("Pontos")
        .document('1')
        .collection('Atendimentos')
        .stream;
    //.where((List<Document> documents) => documents.);
    //    .map((a) => a[0].reference);*/
    //slides = res;
  }

  Widget _getBodyAtendimento() {
    return StreamBuilder(
        stream: slides,
        initialData: [],
        builder: (context, AsyncSnapshot snap) {
          buildContext = context;
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return new Center(child: new RefreshProgressIndicator());
            case ConnectionState.none:
              return new Center(child: new RefreshProgressIndicator());

            default:
              return _getFragent(context, snap);
          }
        });
  }
}
