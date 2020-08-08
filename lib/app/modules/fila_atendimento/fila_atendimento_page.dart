import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/app/app_module.dart';
import 'package:uniprintgestao/app/modules/cadastro_atendente/cadastro_atendente_module.dart';
import 'package:uniprintgestao/app/modules/cadastro_preco/cadastro_preco_module.dart';
import 'package:uniprintgestao/app/modules/cadastro_professor/cadastro_professor_module.dart';
import 'package:uniprintgestao/app/modules/fila_impressoes/fila_impressoes_module.dart';
import 'package:uniprintgestao/app/modules/ler_qr_code.dart/ler_qr_code_module.dart';
import 'package:uniprintgestao/app/modules/login/login_module.dart';
import 'package:uniprintgestao/app/modules/select_any/models/select_model.dart';
import 'package:uniprintgestao/app/modules/select_any/select_any_module.dart';
import 'package:uniprintgestao/app/modules/select_any/select_any_page.dart';
import 'package:uniprintgestao/app/shared/api/querys.dart';
import 'package:uniprintgestao/app/shared/extensions/date.dart';
import 'package:uniprintgestao/app/shared/extensions/string.dart';
import 'package:uniprintgestao/app/shared/graph/atendimento.dart';
import 'package:uniprintgestao/app/shared/temas/tema.dart';
import 'package:uniprintgestao/app/shared/utils/auth/hasura_auth_service.dart';
import 'package:uniprintgestao/app/shared/utils/constans.dart';
import 'package:uniprintgestao/app/shared/utils/utils_atendimento.dart';
import 'package:uniprintgestao/app/shared/utils/utils_notificacao.dart';
import 'package:uniprintgestao/app/shared/utils/utils_platform.dart';
import 'package:uniprintgestao/app/shared/utils/view_page_aux.dart';
import 'package:uniprintgestao/app/shared/widgets/cabecalho_detalhes_usuario/cabecalho_detalhes_usuario.dart';
import 'package:uniprintgestao/app/shared/widgets/falha/falha_widget.dart';
import 'package:uniprintgestao/app/shared/widgets/lista_vazia/lista_vazia_widget.dart';
import 'package:uniprintgestao/app/shared/widgets/widgets.dart';

import 'fila_atendimento_controller.dart';
import 'fila_atendimento_module.dart';

class FilaAtendimentoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FilaAtendimentoPageState();
  }
}

class FilaAtendimentoPageState extends State<FilaAtendimentoPage>
    with AfterLayoutMixin<FilaAtendimentoPage> {
  final FilaAtendimentoController _controller =
      FilaAtendimentoModule.to.bloc<FilaAtendimentoController>();
  List<Atendimento> atendimentos = List();
  PageController _pagecontroller = PageController();
  BuildContext buildContext;
  final FocusNode _focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //if (UtilsPlatform.isDesktop()) {
    //TODO Isso está impedindo do teclado abrir corretamente em outras telas
    //FocusScope.of(context).requestFocus(_focusNode);
    //}
  }

  @override
  void initState() {
    _pagecontroller.addListener(() {
      setState(() {
        _controller.paginaAtual = _pagecontroller.page.floor();
      });
    });
    _controller.snapshot = _controller.getAtendimentos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Fila de atendimentos",
          ),
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
                child: new Column(children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(
                  "Uniguaçu",
                  style: new TextStyle(color: Colors.white),
                ),
                accountEmail:
                    new Text("", style: new TextStyle(color: Colors.white)),
                currentAccountPicture: new GestureDetector(
                  onTap: () {},
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
                            builder: (context) => CadastroProfessorModule()));
                  }),
              new ListTile(
                  title: new Text("Cadastro atendente"),
                  trailing: new Icon(Icons.work),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CadastroAtendenteModule()));
                  }),
              new ListTile(
                  title: new Text("Cadastro preços"),
                  trailing: new Icon(Icons.work),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectAnyModule(
                                  SelectModel(
                                      'Preços',
                                      'id',
                                      [
                                        Linha('valor', involucro: 'Valor: ???'),
                                        Linha('tipo_folha/nome',
                                            involucro: 'Tipo de folha: ???'),
                                        Linha('data_inicio',
                                            personalizacao: (data) {
                                          return Text(
                                              '${data['data_inicio'].toString().dateFromHasura().string('dd/MM/yy')} até ${data['data_fim']?.toString()?.dateFromHasura()?.string('dd/MM/yy') ?? 'Data indeterminada'}');
                                        })
                                      ],
                                      SelectAnyPage.TIPO_SELECAO_ACAO,
                                      query: Querys.getListaPrecos,
                                      chaveLista: 'valor_impressao',
                                      botoes: [
                                        Acao('Novo',
                                            (context) => CadastroPrecoModule())
                                      ]),
                                )));
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginModule()));
                  }),
            ]))),
        body: Builder(builder: (context) {
          buildContext = context;
          return _getBody(context);
        }));
  }

  Widget _getBody(BuildContext context) {
    return StreamBuilder(
      stream: _controller.snapshot,
      builder: (_, snap) {
        return new RawKeyboardListener(
            focusNode: _focusNode,
            onKey: onKey,
            child: _getFragent(context, snap));
      },
    );
  }

  Widget _getFragent(BuildContext context, AsyncSnapshot snap) {
    if (snap.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (snap.hasError || !snap.hasData) {
      return FalhaWidget('Ops, houve uma falha ao recuperar os atendimentos');
    }
    if (snap.data['data']['atendimento'].isEmpty) {
      return Center(
          child: ListaVaziaWidget(
              'Nenhuma atendimento na fila',
              'Fila de atendimentos são mostrados aqui',
              'imagens/reception.png'));
    }
    atendimentos.clear();
    for (var data in snap.data['data']['atendimento']) {
      Atendimento atendimento = Atendimento.fromMap(data);
      atendimentos.add(atendimento);
    }
    if (atendimentos.isNotEmpty) {
      return new PageView.builder(
        controller: _pagecontroller,
        itemCount: atendimentos.length,
        itemBuilder: (context, position) {
          return _buildStoryPage(atendimentos[position],
              position == _controller.paginaAtual.floor(), position);
        },
      );
    } else
      return Center(
        child: Text('Nenhum atendimento na fila'),
      );
  }

  Widget _buildStoryPage(Atendimento atendimento, bool active, int index) {
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
                  CabecalhoDetalhesUsuario(atendimento.usuario),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: 'Número do atendimento: ',
                        children: <TextSpan>[
                          TextSpan(
                              text: atendimento.id?.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22)),
                        ],
                      ),
                    ),
                  ),
                  atendimento.status ==
                          Constants.STATUS_ATENDIMENTO_EM_ATENDIMENTO
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child:
                                  Icon(Icons.settings, color: getCorPadrao()),
                            ),
                            Text('Em atendimento...'),
                          ],
                        )
                      : Container(),
                  InkWell(
                    onTap: () async {
                      if (UtilsPlatform.isMobile()) {
                        var res = await Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new LerQrCodeModule()));
                        if (res != null && res.isNotEmpty) {
                          if (res == atendimento.id.toString()) {
                            _marcarEmAtendimento(atendimento);
                          } else {
                            showSnack(
                                buildContext, 'Oops, o QR não foi reconhecido');
                          }
                        }
                      } else {
                        showSnack(
                            buildContext, 'Não é possível ler o qr por aqui');
                      }
                    },
                    child: new Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: Image.asset('imagens/qr_code.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          color: isDarkMode(context)
                              ? Colors.white
                              : Colors.black),
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
                          atendimento.status ==
                                  Constants.STATUS_ATENDIMENTO_EM_ATENDIMENTO
                              ? Container()
                              : FloatingActionButton(
                                  heroTag: 'em_atendimento',
                                  tooltip: 'Em atendimento',
                                  onPressed: () async {
                                    _marcarEmAtendimento(atendimento);
                                  },
                                  child: Icon(Icons.done),
                                ),
                          FloatingActionButton(
                            heroTag: 'finalizar_atendimento',
                            tooltip: 'Finalizar atendimento',
                            onPressed: () async {
                              _finalizarAtendimento(atendimento);
                            },
                            child: Icon(Icons.done_all),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          )))),
    );
  }

  void onKey(RawKeyEvent event) {
    int keyCode = getBotaoPressionado(event);
    if (UtilsPlatform.isWindows()) {
      switch (keyCode) {
        case 39: //left
          setState(() {
            _pagecontroller.nextPage(
                duration: Duration(milliseconds: 600), curve: Curves.ease);
          });

          break;
        case 37:
          setState(() {
            _pagecontroller.previousPage(
                duration: Duration(milliseconds: 600), curve: Curves.ease);
          });

          break;
      }
    } else {
      switch (keyCode) {
        case 124: //left
          setState(() {
            _pagecontroller.nextPage(
                duration: Duration(milliseconds: 600), curve: Curves.ease);
          });

          break;
        case 123:
          setState(() {
            _pagecontroller.previousPage(
                duration: Duration(milliseconds: 600), curve: Curves.ease);
          });

          break;
      }
    }
  }

  Future<void> _finalizarAtendimento(Atendimento atendimento) async {
    List<Atendimento> atendimentosCopia =
        List.of(atendimentos); //faz uma copia dos
    //atendimentos pra nao rolar um erro quando a lista atualizar
    bool result = await UtilsAtendimento.gerarMovimentacao(
        Constants.MOV_ATENDIMENTO_ATENDIDO,
        Constants.STATUS_ATENDIMENTO_ATENDIDO,
        atendimento.id);
    if (result) {
      showSnack(buildContext, 'Atendimento confirmado com sucesso');

      int pos = 0;
      for (int i = 0;
          i < (atendimentosCopia.length > 3 ? 3 : atendimentosCopia.length);
          i++) {
        if (atendimento.id != atendimentosCopia[i].id) {
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
      showSnack(
          buildContext, 'Ops, houve uma falha ao confirmar o atendimento');
    }
  }

  Future<void> _marcarEmAtendimento(Atendimento atendimento) async {
    ProgressDialog progressDialog = ProgressDialog(context)
      ..style(message: 'Marcando como em atendimento');
    await progressDialog.show();

    bool result = await UtilsAtendimento.gerarMovimentacao(
        Constants.MOV_ATENDIMENTO_EM_ATENDIMENTO,
        Constants.STATUS_ATENDIMENTO_EM_ATENDIMENTO,
        atendimento.id);
    progressDialog.hide();
    if (result) {
      showSnack(buildContext, 'Atendimento confirmado com sucesso');
    } else {
      showSnack(context, 'Ops, houve uma falha ao marcar como em atendimento');
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {}
}
