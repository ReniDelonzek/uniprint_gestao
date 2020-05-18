import 'dart:io' show File, Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/src/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/src/api/querys.dart';
import 'package:uniprintgestao/src/app_module.dart';
import 'package:uniprintgestao/src/extensions/date.dart';
import 'package:uniprintgestao/src/models/graph/impressao.dart';
import 'package:uniprintgestao/src/modules/fila_impressoes/fila_impressoes_controller.dart';
import 'package:uniprintgestao/src/modules/fila_impressoes/fila_impressoes_module.dart';
import 'package:uniprintgestao/src/utils/Constans.dart';
import 'package:uniprintgestao/src/utils/auth/hasura_auth_service.dart';
import 'package:uniprintgestao/src/utils/utils_impressao.dart';
import 'package:uniprintgestao/src/utils/utils_platform.dart';
import 'package:uniprintgestao/src/utils/view_page_aux.dart';
import 'package:uniprintgestao/src/widgets/button.dart';
import 'package:uniprintgestao/src/widgets/cabecalho_detalhes_usuario/cabecalho_detalhes_usuario.dart';
import 'package:uniprintgestao/src/widgets/falha/falha_widget.dart';
import 'package:uniprintgestao/src/widgets/lista_vazia/lista_vazia_widget.dart';
import 'package:uniprintgestao/src/widgets/widgets.dart';

class FilaImpressoesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FilaImpressoesPageState();
  }
}

class FilaImpressoesPageState extends State<FilaImpressoesPage> {
  final FilaImpressoesController _controller =
      FilaImpressoesModule.to.bloc<FilaImpressoesController>();

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

    return new Scaffold(
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
        body: Builder(builder: (BuildContext context) => _getBodyImpressoes()));
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
      //imprimirArquivos(impressao, buildContext);
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
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: SingleChildScrollView(
        child: Container(
          height: size.height * .80,
          width: size.width * .80,
          child: (new Card(
              child: new Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 25),
                  child: CabecalhoDetalhesUsuario(impressao.usuario,
                      currentPageValue == currentPageValue.roundToDouble()),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre o cliente',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          children: <Widget>[
                            Text(
                                '-Usuário desde ${impressao.usuario?.data_criacao?.string('dd/MM/yyyy') ?? ''}\n'
                                '-${impressao.usuario?.impressaos_aggregate?.aggregate?.count} Impressões, '
                                '${impressao.usuario?.atendimentos_aggregate?.aggregate?.count} Atendimentos\n'
                                '-Pontuação ${impressao.usuario?.nivel_usuarios?.isNotEmpty == true ? impressao.usuario?.nivel_usuarios?.first?.pontuacao : '0'}')
                          ],
                        )),
                  ],
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Text(
                      'Sobre a impressão',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: impressao.arquivo_impressaos.map((e) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                    '-${e.quantidade} cópia${e.quantidade > 1 ? 's' : ''} ${e.tipofolha?.nome}'),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: InkWell(
                                      onTap: () {},
                                      child: Text(
                                        e.nome,
                                      )),
                                )
                              ],
                            );
                          }).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            ' ${impressao.comentario.isNotEmpty ? 'Comentário: ${impressao.comentario}' : ''}',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _getButtons(impressao)
                ]),
              ],
            ),
          ))),
        ),
      ),
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

  abrirArquivosExplorador(Impressao impressao) async {
    UtilsImpressao.abrirArquivosExplorador(impressao);
  }

  Future<void> imprimirArquivos(
      Impressao impressao, BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.style(message: 'Baixando e imprimindo arquivos');
    progressDialog.show();
    try {
      List<File> files = await _controller.baixarArquivos(impressao);
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
    // } else {
    //   Scaffold.of(buildContext).showSnackBar(SnackBar(
    //     content: Text(
    //         'Infelizmente as impressões são suportadas somente no windows'),
    //   ));
    // }
  }

  _getButtons(Impressao impressao) {
    if (impressao.status == Constants.STATUS_IMPRESSAO_SOLICITADO) {
      return new Container(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
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
                child: Text('REJEITAR'),
              ),
              Button('AUTORIZAR', () async {
                imprimirArquivos(impressao, context);
                if (Platform.isWindows) {
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
        child: Button(
          "Marcar como entregue",
          () async {
            ProgressDialog progressDialog = ProgressDialog(context);
            progressDialog.style(message: 'Marcando como concluída');
            progressDialog.show();
            bool result = await UtilsImpressao.gerarMovimentacao(
                Constants.MOV_IMPRESSAO_RETIRADA,
                Constants.STATUS_IMPRESSAO_RETIRADA,
                impressao);
            progressDialog.dismiss();
            if (result) {
              showSnack(
                  buildContext, 'Impressão marcada como entregue com sucesso!');
            } else {
              showSnack(buildContext,
                  'Ops, houve uma falha ao atualizar a impressão');
            }
          },
        ),
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
