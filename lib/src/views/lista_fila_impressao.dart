import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/src/api/graphQlObjetct.dart';
import 'package:uniprintgestao/src/api/querys.dart';
import 'package:uniprintgestao/src/models/graph/impressao.dart';
import 'package:uniprintgestao/src/utils/Constans.dart';
import 'package:uniprintgestao/src/utils/UtilsImpressao.dart';
import 'package:uniprintgestao/src/views/viewPage/ViewPageAux.dart';
import 'package:uniprintgestao/src/widgets/falha/falha_widget.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page;
      });
    });

    return Builder(
        builder: (context) => new Scaffold(
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
    listaImpressoes.clear();

    if (snap.hasError || !snap.hasData) {
      return FalhaWidget('Ops, houve uma falha ao recuperar as impressões');
    }
    if (snap.data['data']['impressao'].isEmpty) {
      return Center(
        child: Text('Nenhuma impressão na fila'),
      );
    }
    for (var data in snap.data['data']['impressao']) {
      Impressao atendimento = Impressao.fromJson(data.map);
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
                  CabecalhoDetalhesUsuario(impressao.usuario,
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

  Widget _getBodyImpressoes() {
    return StreamBuilder(
        stream: GraphQlObject.hasuraConnect.subscription(Querys.getImpressoes),
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
      bool result = await UtilsImpressao.gerarMovimentacao(
          Constants.MOV_IMPRESSAO_AGUARDANDO_RETIRADA,
          Constants.STATUS_IMPRESSAO_AGUARDANDO_RETIRADA,
          impressao.id);
      if (result) {
        showSnack(buildContext, 'Impressão negada com sucesso');
      } else {
        showSnack(buildContext, 'Ops, houve uma falha ao rejeitar a impressão');
      }
      //atualizarStatusImpressao(
      //  impressao, Constants.STATUS_IMPRESSAO_AGUARDANDO_RETIRADA);
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
                    onPressed: () async {
                      bool result = await UtilsImpressao.gerarMovimentacao(
                          Constants.MOV_IMPRESSAO_NEGADA,
                          Constants.STATUS_IMPRESSAO_NEGADA,
                          impressao.id);
                      if (result) {
                        showSnack(buildContext, 'Impressão negada com sucesso');
                      } else {
                        showSnack(buildContext,
                            'Ops, houve uma falha ao rejeitar a impressão');
                      }
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
                        bool result = await UtilsImpressao.gerarMovimentacao(
                            Constants.MOV_IMPRESSAO_NEGADA,
                            Constants.STATUS_IMPRESSAO_NEGADA,
                            impressao.id);
                        if (result) {
                          showSnack(
                              buildContext, 'Impressão negada com sucesso');
                        } else {
                          showSnack(buildContext,
                              'Ops, houve uma falha ao rejeitar a impressão');
                        }
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
                bool result = await UtilsImpressao.gerarMovimentacao(
                    Constants.MOV_IMPRESSAO_RETIRADA,
                    Constants.STATUS_IMPRESSAO_RETIRADA,
                    impressao.id);
                if (result) {
                  showSnack(buildContext,
                      'Impressão marcada como entregue com sucesso!');
                } else {
                  showSnack(buildContext,
                      'Ops, houve uma falha ao atualizar a impressão');
                }
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
}
