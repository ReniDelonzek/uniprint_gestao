import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:uniprintgestao/src/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/src/api/querys.dart';
import 'package:uniprintgestao/src/app_module.dart';
import 'package:uniprintgestao/src/models/graph/atendimento_g.dart';
import 'package:uniprintgestao/src/modules/cadastro_atendente/cadastro_atendente_module.dart';
import 'package:uniprintgestao/src/modules/cadastro_preco/cadastro_preco_module.dart';
import 'package:uniprintgestao/src/modules/cadastro_professor/cadastro_professor_module.dart';
import 'package:uniprintgestao/src/modules/fila_impressoes/fila_impressoes_module.dart';
import 'package:uniprintgestao/src/modules/ler_qr_code.dart/ler_qr_code_module.dart';
import 'package:uniprintgestao/src/modules/login/login_page.dart';
import 'package:uniprintgestao/src/modules/select_any/models/select_model.dart';
import 'package:uniprintgestao/src/modules/select_any/select_any_module.dart';
import 'package:uniprintgestao/src/modules/select_any/select_any_page.dart';
import 'package:uniprintgestao/src/utils/Constans.dart';
import 'package:uniprintgestao/src/utils/auth/hasura_auth_service.dart';
import 'package:uniprintgestao/src/utils/utils_atendimento.dart';
import 'package:uniprintgestao/src/utils/utils_notificacao.dart';
import 'package:uniprintgestao/src/utils/utils_platform.dart';
import 'package:uniprintgestao/src/utils/view_page_aux.dart';
import 'package:uniprintgestao/src/widgets/falha/falha_widget.dart';
import 'package:uniprintgestao/src/widgets/lista_vazia/lista_vazia_widget.dart';
import 'package:uniprintgestao/src/widgets/widgets.dart';

class FilaAtendimentoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FilaAtendimentoPageState();
  }
}

class FilaAtendimentoPageState extends State<FilaAtendimentoPage> {
  List<Atendimento> atendimentos = List();
  double currentPageValue = 0.0;
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
          title: new Text(
            "Fila de atendimentos",
            style: new TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new FilaImpressoesModule()));
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
                      "Uniguaçu",
                      style: new TextStyle(color: Colors.white),
                    ),
                    accountEmail:
                        new Text("", style: new TextStyle(color: Colors.white)),
                    currentAccountPicture: new GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new CadastroProfessorModule()));
                      },
                      child: Hero(
                        tag: "imagem_perfil",
                        child: new CircleAvatar(
                          backgroundImage:
                              new AssetImage('imagens/uniguacu_icon.png'),
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
                                builder: (context) =>
                                    CadastroProfessorModule()));
                      }),
                  new ListTile(
                      title: new Text("Cadastro atendente"),
                      trailing: new Icon(Icons.work),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CadastroAtendenteModule()));
                      }),
                  new ListTile(
                      title: new Text("Cadastro preços"),
                      trailing: new Icon(Icons.work),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CadastroPrecoModule()));
                      }),
                  new ListTile(
                      title: new Text("Soma atendimentos"),
                      trailing: new Icon(Icons.work),
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new SelectAnyModule(SelectModel(
                                    'Contagem de atendimentos',
                                    'id',
                                    [
                                      Linha(
                                          'atendimentos_aggregate/aggregate/count',
                                          involucro: '??? Atendimentos'),
                                      Linha('nome')
                                    ],
                                    SelectAnyPage.TIPO_SELECAO_ACAO,
                                    query: Querys.somaAtendimentosDia,
                                    chaveLista: 'ponto_atendimento'))));
                      }),
                  new ListTile(
                      title: new Text("Sair"),
                      trailing: new Icon(Icons.power_settings_new),
                      onTap: () async {
                        await AppModule.to
                            .getDependency<HasuraAuthService>()
                            .logOut();
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      }),
                ]))),
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          buildContext = context;
          return _getBody(context);
        }));
  }

  Widget _getBody(BuildContext context) {
    return StreamBuilder(
      stream: GraphQlObject.hasuraConnect
          .subscription(Querys.getAtendimentos, variables: {
        'ponto_atendimento_id': AppModule.to
            .getDependency<HasuraAuthService>()
            .usuario
            .codPontoAtendimento
      }),
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
          child: ListaVaziaWidget(
              'Nenhuma atendimento na fila',
              'Fila de atendimentos são mostrados aqui',
              'imagens/reception.png') //Text('Nenhuma impressão na fila'),
          //Text('Nenhum atendimento na fila'),
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
                  CabecalhoDetalhesUsuario(atendimento.usuario,
                      currentPageValue == currentPageValue.roundToDouble()),
                  InkWell(
                    onTap: () {
                      if (UtilsPlatform.isMobile()) {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new LerQrCodeModule(atendimento.id)));
                      } else {
                        showSnack(
                            buildContext, 'Não é possível ler o qr por aqui');
                      }
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
                            onPressed: () async {
                              if (await UtilsAtendimento.gerarChamada(
                                  atendimento)) {
                                showSnack(buildContext,
                                    '${atendimento.usuario.pessoa.nome.split(' ').first} foi notificado(a) com sucesso');
                              }
                            },
                          ),
                          FloatingActionButton(
                            heroTag: 'finalizar_atendimento',
                            tooltip: 'Finalizar atendimento',
                            onPressed: () async {
                              List<Atendimento> atendimentosCopia =
                                  List.of(atendimentos); //faz uma copia dos
                              //atendimentos pra nao rolar um erro quando a lista atualizar
                              bool result =
                                  await UtilsAtendimento.gerarMovimentacao(
                                      Constants.MOV_ATENDIMENTO_ATENDIDO,
                                      Constants.STATUS_ATENDIMENTO_ATENDIDO,
                                      atendimento.id);
                              if (result) {
                                showSnack(buildContext,
                                    'Atendimento confirmado com sucesso');

                                int pos = 0;
                                for (int i = 0;
                                    i <
                                        (atendimentosCopia.length > 3
                                            ? 3
                                            : atendimentosCopia.length);
                                    i++) {
                                  if (atendimento.id !=
                                      atendimentosCopia[i].id) {
                                    if (pos == 0) {
                                      //proximo da fila
                                      UtilsNotificacao.enviarNotificacao(
                                          'Ei, chegou sua vez de ser atendido',
                                          'Estamos esperando você agora no ${atendimentosCopia[i].ponto_atendimento?.nome}',
                                          atendimentosCopia[i].usuario.uid);
                                    } else {
                                      UtilsNotificacao.enviarNotificacao(
                                          'Só tem mais $pos pessoa${pos > 1 ? 's' : ''} na sua frente',
                                          'Fique nas proximidades do ${atendimentosCopia[i].ponto_atendimento?.nome}',
                                          atendimentosCopia[i].usuario.uid);
                                    }
                                    pos++;
                                  }
                                }
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
