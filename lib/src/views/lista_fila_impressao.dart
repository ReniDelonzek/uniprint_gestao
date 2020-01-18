import 'dart:async';
import 'dart:io' show Platform;

import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/src/models/Impressao.dart';
import 'package:uniprintgestao/src/temas/Tema.dart';
import 'package:uniprintgestao/src/utils/Constans.dart';
import 'package:uniprintgestao/src/utils/UtilsImpressao.dart';
import 'package:uniprintgestao/src/views/viewPage/ViewPageAux.dart';
import 'package:uniprintgestao/src/widgets/widgets.dart';

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
  final FocusNode _focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).requestFocus(_focusNode);
  }

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
        debugShowCheckedModeBanner: false,
        theme: Tema.getTema(context),
        home: new Scaffold(
            appBar: new AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: new Text(
                "Lista de Impressões",
                style: new TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                /*Navigator.of(buildContext).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new Test()));*/
              },
            ),
            backgroundColor: Colors.white,
            body: Builder(
                builder: (BuildContext context) => _getBodyImpressoes())));
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

  _buildStoryPageImpressoes(Impressao impressao, bool active, int index) {
    if (Platform.isWindows &&
        impressao.status == Constants.STATUS_IMPRESSAO_AUTORIZADO) {
      impressaoAutorizada(impressao, buildContext);
    }
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
      child: _getCardImpressoes(impressao, index),
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
                  CabecalhoDetalhesUsuario(impressao.codSolicitante,
                      currentPageValue == currentPageValue.roundToDouble()),
                  Container(
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
                  ),
                  _getButtons(impressao)
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
              return new RawKeyboardListener(
                  focusNode: _focusNode,
                  onKey: onKey,
                  child: _getFragentImpressoes(context, snap));
          }
        });
  }

  Future<void> impressaoAutorizada(
      Impressao impressao, BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.style(message: 'Baixando e imprimindo arquivos');
    progressDialog.show();
    var files = await UtilsImpressao.baixarArquivosImpressao(impressao);
    bool sucess = UtilsImpressao.imprimirArquivos(files);
    if (sucess) {
      atualizarStatusImpressao(
          impressao, Constants.STATUS_IMPRESSAO_AGUARDANDO_RETIRADA);
    } else {
      if (progressDialog.isShowing()) {
        progressDialog?.dismiss();
      }
      Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text('Ops, houve uma falha ao tentar imprimir os arquivos'),
      ));
    }
  }

  _getButtons(Impressao impressao) {
    if (impressao.status == Constants.STATUS_IMPRESSAO_SOLICITADO) {
      return new Container(
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
                        "dataImpressao": DateTime.now()
                      }).then((sucess) {
                        Scaffold.of(buildContext).showSnackBar(SnackBar(
                          content: Text('Atendimento finalizado com sucesso'),
                        ));
                      }).catchError((error) {
                        Scaffold.of(buildContext).showSnackBar(SnackBar(
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
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
              new ButtonTheme(
                  height: 45,
                  minWidth: 150,
                  child: RaisedButton(
                    onPressed: () async {
                      if (Platform.isWindows) {
                        impressaoAutorizada(impressao, context);
                      } else {
                        atualizarStatusImpressao(
                            impressao, Constants.STATUS_IMPRESSAO_AUTORIZADO);
                      }
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: new Text(
                      "AUTORIZAR",
                      style: new TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ));
    } else if (impressao.status ==
        Constants.STATUS_IMPRESSAO_AGUARDANDO_RETIRADA) {
      return Container(
        alignment: Alignment.center,
        child: new ButtonTheme(
            height: 45,
            minWidth: 150,
            child: RaisedButton(
              onPressed: () async {
                ProgressDialog progressDialog = ProgressDialog(context);
                progressDialog.style(message: 'Marcando como concluída');
                progressDialog.show();
                Firestore.instance
                    .collection('Empresas')
                    .document('Uniguacu')
                    .collection('Pontos')
                    .document(impressao.codPonto)
                    .collection("Impressoes")
                    .document(impressao.id)
                    .update({
                  "status": Constants.STATUS_IMPRESSAO_RETIRADA,
                  "dataAtendimento": DateTime.now()
                }).then((sucess) {
                  if (progressDialog.isShowing()) {
                    progressDialog?.dismiss();
                  }
                  Scaffold.of(buildContext).showSnackBar(SnackBar(
                    content:
                        Text('Impressão marcada como entregue com sucesso'),
                  ));
                }).catchError((error) {
                  if (progressDialog.isShowing()) {
                    progressDialog?.dismiss();
                  }
                  Scaffold.of(buildContext).showSnackBar(SnackBar(
                    content: Text(
                        'Ops, houve uma falha a atualizar o status da impressão'),
                  ));
                });
              },
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.0),
              ),
              child: new Text(
                "Marcar como entregue",
                style: new TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )),
      );
    } else if (impressao.status == Constants.STATUS_IMPRESSAO_AUTORIZADO) {
      return Center(child: Text('Impressão autorizada, aguardando impressão'));
    } else if (impressao.status == Constants.STATUS_IMPRESSAO_RETIRADA) {
      return Center(child: Text('Impressão finalizada'));
    } else if (impressao.status == Constants.STATUS_IMPRESSAO_CANCELADO) {
      return Center(child: Text('Impressão cancelada pelo cliente'));
    } else if (impressao.status == Constants.STATUS_IMPRESSAO_NEGADA) {
      return Center(child: Text('Impressão rejeitada'));
    } else
      return Spacer();
  }

  void onKey(RawKeyEvent event) {
    int keyCode = getBotaoPressionado(event);
    switch (keyCode) {
      case 124: //left
        setState(() {
          controller.nextPage(
              duration: Duration(milliseconds: 600), curve: Curves.ease);
        });

        break;
      case 123:
        setState(() {
          controller.previousPage(
              duration: Duration(milliseconds: 600), curve: Curves.ease);
        });

        break;
    }
  }

  void atualizarStatusImpressao(Impressao impressao, int status) {
    Firestore.instance
        .collection('Empresas')
        .document('Uniguacu')
        .collection('Pontos')
        .document(impressao.codPonto)
        .collection("Impressoes")
        .document(impressao.id)
        .update({"status": status, "dataAtendimento": DateTime.now()}).then(
            (sucess) {
      Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text('Arquivos impressos com sucesso'),
      ));
    }).catchError((error) {
      Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text('Ops, houve uma falha a atualizar o status da impressão'),
      ));
    });
  }
}
