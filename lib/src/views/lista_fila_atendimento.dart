import 'dart:async';

import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:uniprintgestao/src/api/graphQlObjetct.dart';
import 'package:uniprintgestao/src/api/querys.dart';
import 'package:uniprintgestao/src/models/graph/atendimento_g.dart';
import 'package:uniprintgestao/src/utils/Constans.dart';
import 'package:uniprintgestao/src/utils/utils_atendimento.dart';
import 'package:uniprintgestao/src/views/atendentimento/cadastros/cadastro_atendente.dart';
import 'package:uniprintgestao/src/views/login/screen_login_email.dart';
import 'package:uniprintgestao/src/views/viewPage/ViewPageAux.dart';
import 'package:uniprintgestao/src/widgets/falha/falha_widget.dart';
import 'package:uniprintgestao/src/widgets/widgets.dart';
import 'atendentimento/cadastros/cadastro_professor.dart';
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
      builder: (context) {
        buildContext = context;
        return new Scaffold(
            appBar: new AppBar(
              title: new Text(
                "Fila de atendimentos",
                style: new TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            floatingActionButton: new FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new ListaFilaImpressao()));
              },
              heroTag: "impressoes",
              child: Icon(Icons.print),
            ),
            drawer: new Drawer(
                semanticLabel: 'Menu',
                child: Container(
                    color: Colors.white,
                    child: new Column(children: <Widget>[
                      new UserAccountsDrawerHeader(
                        accountName: new Text(
                          "",
                          style: new TextStyle(color: Colors.white),
                        ),
                        accountEmail: new Text("",
                            style: new TextStyle(color: Colors.white)),
                        currentAccountPicture: new GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new CadastroProfessor()));
                          },
                          child: Hero(
                            tag: "imagem_perfil",
                            child: new CircleAvatar(
                              backgroundImage: new NetworkImage(
                                  "https://www.pnglot.com/pngfile/detail/192-1925683_user-icon-png-small.png"),
                            ),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('imagens/back_drawer.jpg'))),
                      ),
                      new ListTile(
                          title: new Text("Cadastro professor"),
                          trailing: new Icon(Icons.school),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CadastroProfessor()));
                          }),
                      new ListTile(
                          title: new Text("Cadastro atendente"),
                          trailing: new Icon(Icons.work),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CadastroAtendente()));
                          }),
                      new ListTile(
                          title: new Text("Sair"),
                          trailing: new Icon(Icons.power_settings_new),
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScreenLoginEmail()));
                          }),
                    ]))),
            backgroundColor: Colors.white,
            body: _getBody(context));
      },
    );
  }

  Widget _getBody(BuildContext context) {
    return StreamBuilder(
      stream: GraphQlObject.hasuraConnect.subscription(Querys.getAtendimentos),
      builder: (_, snap) {
        return new RawKeyboardListener(
            focusNode: _focusNode,
            onKey: onKey,
            child: _getFragent(context, snap));
      },
    );
  }

  Widget _getFragent(BuildContext context, AsyncSnapshot snap) {
    atendimentos.clear();
    if (snap.hasError || !snap.hasData) {
      return FalhaWidget('Ops, houve uma falha ao recuperar os atendimentos');
    }
    if (snap.data['data']['atendimento'].isEmpty) {
      return Center(
        child: Text('Nenhum atendimento na fila'),
      );
    }
    for (var data in snap.data['data']['atendimento']) {
      Atendimento atendimento = Atendimento.fromMap(data);
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

  Widget _buildStoryPage(Atendimento atendimento, bool active, int index) {
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
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: (Container(
          height: height * 0.75,
          padding: EdgeInsets.all(15.0),
          child: new Card(
              child: new Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              height: height * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  CabecalhoDetalhesUsuario(atendimento.usuario,
                      currentPageValue == currentPageValue.roundToDouble()),
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
                            onPressed: () {},
                          ),
                          FloatingActionButton(
                            heroTag: 'finalizar_atendimento',
                            tooltip: 'Finalizar atendimento',
                            onPressed: () async {
                              bool result =
                                  await UtilsAtendimento.gerarMovimentacao(
                                      Constants.MOV_ATENDIMENTO_ATENDIDO,
                                      Constants.STATUS_ATENDIMENTO_ATENDIDO,
                                      atendimento.id);
                              if (result) {
                                showSnack(buildContext,
                                    'Atendimento confirmado com sucesso');
                              } else {
                                showSnack(buildContext,
                                    'Ops, houve uma falha ao confirmar o atendimento');
                              }
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
    String _barcodeString = await new QRCodeReader().scan();
    if (_barcodeString == atendimento.id.toString()) {
      bool result = await UtilsAtendimento.gerarMovimentacao(
          Constants.MOV_ATENDIMENTO_EM_ATENDIMENTO,
          Constants.STATUS_ATENDIMENTO_EM_ATENDIMENTO,
          atendimento.id);
      if (result) {
        showSnack(buildContext, 'Atendimento marcado como em atendimento');
      } else {
        showSnack(
            buildContext, 'Ops, houve uma falha ao atualizar o atendimento');
      }
    } else if (_barcodeString.isNotEmpty) {
      showSnack(context, 'Ops, não foi possível confirmar a senha');
    } else {
      Navigator.pop(context);
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
