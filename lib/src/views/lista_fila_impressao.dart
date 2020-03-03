import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/src/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/src/api/querys.dart';
import 'package:uniprintgestao/src/models/graph/impressao.dart';
import 'package:uniprintgestao/src/utils/Constans.dart';
import 'package:uniprintgestao/src/utils/auth/hasura_auth_service.dart';
import 'package:uniprintgestao/src/utils/utils_impressao.dart';
import 'package:uniprintgestao/src/widgets/button.dart';
import 'package:uniprintgestao/src/widgets/falha/falha_widget.dart';
import 'package:uniprintgestao/src/widgets/lista_vazia/lista_vazia_widget.dart';
import 'package:uniprintgestao/src/widgets/widgets.dart';

import '../app_module.dart';
import 'viewPage/view_page_aux.dart';

class ListaFilaImpressao extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ListaFilaImpressaoPageState();
  }
}

class ListaFilaImpressaoPageState extends State<ListaFilaImpressao> {
  List<Impressao> listaImpressoes = List();
  var currentPageValue = 0.0;
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
          child: ListaVaziaWidget(
              'Nenhuma impressão na fila',
              'Impressões aparecem aqui',
              'imagens/printer_icon.png') //Text('Nenhuma impressão na fila'),
          );
    }
    for (var data in snap.data['data']['impressao']) {
      Impressao atendimento = Impressao.fromMap(data);
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
      imprimirArquivos(impressao, buildContext);
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
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: (Container(
          height: size.height * 0.75,
          padding: EdgeInsets.all(15.0),
          child: new Card(
              child: new Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              height: size.height * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: CabecalhoDetalhesUsuario(impressao.usuario,
                        currentPageValue == currentPageValue.roundToDouble()),
                  ),
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
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          child: Text(
                            'Sobre a impressão',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            children: <Widget>[
                              Text(impressao.arquivo_impressaos
                                  .map((e) =>
                                      '${e.tipo_folha?.nome} ${e.quantidade} cópias')
                                  .toList()
                                  .toString()
                                  .replaceAll('[', '')
                                  .replaceAll(']', '')),
                              Text(
                                'Comentário: ${impressao.comentario}',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
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
        stream: GraphQlObject.hasuraConnect
            .subscription(Querys.getImpressoes, variables: {
          'ponto_atendimento_id': AppModule.to
              .getDependency<HasuraAuthService>()
              .usuario
              .codPontoAtendimento
        }),
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

  Future<void> imprimirArquivos(
      Impressao impressao, BuildContext context) async {
    //if (UtilsPlatform.isWindows()) {
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.style(message: 'Baixando e imprimindo arquivos');
    progressDialog.show();
    try {
      var files = await UtilsImpressao.baixarArquivosImpressao(impressao);
      bool sucess = await UtilsImpressao.imprimirArquivos(files);
      if (progressDialog.isShowing()) {
        progressDialog?.dismiss();
      }
      if (sucess) {
        showSnack(buildContext, 'Impresso com sucesso');
      } else {
        Scaffold.of(buildContext).showSnackBar(SnackBar(
          content: Text('Ops, houve uma falha ao tentar imprimir os arquivos'),
        ));
      }
    } catch (e) {
      if (progressDialog.isShowing()) {
        progressDialog?.dismiss();
      }
      Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text('Ops, houve uma falha ao tentar imprimir os arquivos'),
      ));
    }
    /*} else {
      Scaffold.of(buildContext).showSnackBar(SnackBar(
        content: Text(
            'Infelizmente as impressões são suportadas somente no windows'),
      ));
    }*/
  }

  _getButtons(Impressao impressao) {
    if (impressao.status == Constants.STATUS_IMPRESSAO_SOLICITADO) {
      return new Container(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Button(
                'REJEITAR',
                () async {
                  bool result = await UtilsImpressao.gerarMovimentacao(
                      Constants.MOV_IMPRESSAO_NEGADA,
                      Constants.STATUS_IMPRESSAO_NEGADA,
                      impressao);
                  if (result) {
                    showSnack(buildContext, 'Impressão negada com sucesso');
                  } else {
                    showSnack(buildContext,
                        'Ops, houve uma falha ao rejeitar a impressão');
                  }
                },
                color: Colors.red,
              ),
              Button('AUTORIZAR', () async {
                if (Platform.isWindows) {
                  imprimirArquivos(impressao, context);
                } else {
                  bool result = await UtilsImpressao.gerarMovimentacao(
                      Constants.MOV_IMPRESSAO_AUTORIZADO,
                      Constants.STATUS_IMPRESSAO_AUTORIZADO,
                      impressao);
                  if (result) {
                    showSnack(buildContext, 'Impressão autorizada com sucesso');
                  } else {
                    showSnack(buildContext,
                        'Ops, houve uma falha ao autorizar a impressão');
                  }
                }
              })
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
                    impressao);
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
      return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Button('Imprimir', () {
          imprimirArquivos(impressao, context);
        }),
        Button('Marcar como impresso', () async {
          marcarComoImpresso(impressao, context);
        })
      ]);
    } else if (impressao.status == Constants.STATUS_IMPRESSAO_RETIRADA) {
      return Center(child: Text('Impressão finalizada'));
    } else if (impressao.status == Constants.STATUS_IMPRESSAO_CANCELADO) {
      return Center(child: Text('Impressão cancelada pelo cliente'));
    } else if (impressao.status == Constants.STATUS_IMPRESSAO_NEGADA) {
      return Center(child: Text('Impressão rejeitada'));
    } else
      return Spacer();
  }

  Future<void> marcarComoImpresso(
      Impressao impressao, BuildContext context) async {
    bool result = await UtilsImpressao.gerarMovimentacao(
        Constants.MOV_IMPRESSAO_AGUARDANDO_RETIRADA,
        Constants.STATUS_IMPRESSAO_AGUARDANDO_RETIRADA,
        impressao);
    if (result) {
      showSnack(buildContext, 'Impressão autorizada com sucesso');
    } else {
      showSnack(buildContext, 'Ops, houve uma falha ao autorizada a impressão');
    }
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
