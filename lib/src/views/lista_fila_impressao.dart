import 'dart:async';

import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uniprintgestao/src/models/Impressao.dart';
import 'package:uniprintgestao/src/temas/Tema.dart';
import 'package:uniprintgestao/src/utils/Constans.dart';
import 'package:uniprintgestao/src/utils/UtilsImpressao.dart';

class ListaFilaImpressao extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ListaFilaImpressaoPageState();
  }
}

class ListaFilaImpressaoPageState extends State<ListaFilaImpressao> {
  List<Impressao> listaImpressoes = List();
  Icon icon = Icon(Icons.done);
  var currentPageValue = 0.0;
  List<String> tamanhosFolha = List();
  Stream slides;
  PageController controller = PageController();
  BuildContext buildContext;

  @override
  void initState() {
    super.initState();
    _queryDbImpressoes();
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
                "Lista de Impressões",
                style: new TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: _getBodyImpressoes()));
  }

  Widget _getFragentImpressoes(BuildContext context, AsyncSnapshot snap) {
    var doc = snap.data as List<Document>;
    listaImpressoes.clear();
    for (var data in doc) {
      Impressao atendimento = Impressao.fromJson(data.map);
      atendimento.id = data.reference.id;
      listaImpressoes.add(atendimento);
    }
    if (listaImpressoes.isNotEmpty) {
      return new PageView.builder(
        controller: controller,
        itemCount: listaImpressoes.length,
        itemBuilder: (context, position) {
          return _buildStoryPageImpressoes(listaImpressoes[position],
              position == currentPageValue.floor(), position);
        },
      );
    } else {
      return Center(
        child: Text('Nenhuma impressão na fila'),
      );
    }
  }

  _buildStoryPageImpressoes(Impressao atendimento, bool active, int index) {
    // Animated Properties
    final double blur = active ? 30 : 30;
    final double offset = active ? 20 : 10;
    final double top = active ? 20 : 60;

    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 10, right: 5, left: 5),
      //color: Colors.cyan,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
          //    color: Colors.cyan,
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: blur,
                offset: Offset(offset, offset))
          ]),
      child: _getCardImpressoes(atendimento, index),
    );
  }

  Widget _getCardImpressoes(Impressao impressao, int index) {
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
                  /*CabecalhoDetalhesUsuario(atendimento.codSolicitante,
                      currentPageValue == currentPageValue.roundToDouble()),*/
                  InkWell(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Sobre o cliente',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 6),
                              child: Text(
                                  '-Usuário desde 09/09/2019\n-3 Impressões, 4 atendimentos\n-Confiável'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(15),
                            ),
                            Text(
                              'Sobre a impressão',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 6),
                              child: Text(impressao.descricao),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Text(
                                impressao.comentario,
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            )
                          ],
                        ),
                      )),
                  new Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new ButtonTheme(
                              height: 45,
                              minWidth: 150,
                              child: RaisedButton(
                                onPressed: () {
                                  Firestore.instance
                                      .collection('Empresas')
                                      .document('Uniguacu')
                                      .collection('Pontos')
                                      .document("1")
                                      .collection("Impressoes")
                                      .document(impressao.id)
                                      .update({
                                    "status": Constants.STATUS_IMPRESSAO_NEGADA,
                                    "dataAtendimento": DateTime.now()
                                  }).then((sucess) {
                                    Scaffold.of(buildContext)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Atendimento finalizado com sucesso'),
                                    ));
                                  }).catchError((error) {
                                    Scaffold.of(buildContext)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Ops, houve um erro ao finalizar o atendimento'),
                                    ));
                                  });
                                },
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                child: new Text(
                                  "REJEITAR",
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          new ButtonTheme(
                              height: 45,
                              minWidth: 150,
                              child: RaisedButton(
                                onPressed: () async {
                                  var files = await UtilsImpressao
                                      .baixarArquivosImpressao(impressao);
                                  print('Sucesso');
                                  bool sucess =
                                      UtilsImpressao.imprimirArquivos(files);
                                  print('Sucesso');
                                  /*Firestore.instance
                                      .collection('Empresas')
                                      .document('Uniguacu')
                                      .collection('Pontos')
                                      .document("1")
                                      .collection("Impressoes")
                                      .document(atendimento.id)
                                      .update({
                                    "status": 2,
                                    "dataAtendimento": DateTime.now()
                                  }).then((sucess) {
                                    Scaffold.of(buildContext)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Atendimento finalizado com sucesso'),
                                    ));
                                  }).catchError((error) {
                                    Scaffold.of(buildContext)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Ops, houve um erro ao finalizar o atendimento'),
                                    ));
                                  });*/
                                },
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                child: new Text(
                                  "AUTORIZAR",
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ],
                      )),
                ],
              ),
            ),
          )))),
    );
  }

  //banco
  _queryDbImpressoes() async {
    //Firestore.initialize('uniprint-uv');
    slides = Firestore.instance
        .collection("Empresas")
        .document("Uniguacu")
        .collection("Pontos")
        .document('1')
        .collection('Impressoes')
        .stream;
    /*
    Query query = Firestore.instance
        .collection("Empresas")
        .document("Uniguacu")
        .collection("Pontos")
        .document('1')
        .collection('Impressoes')
        .where('status', isEqualTo: 0)
        .orderBy("dataSolicitacao", descending: true);

    // Map the documents to the data payload
    slides =
        query.snapshots(includeMetadataChanges: true).map((a) => a.documents);*/
  }

  Widget _getBodyImpressoes() {
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
              return _getFragentImpressoes(context, snap);
          }
        });
  }
}
