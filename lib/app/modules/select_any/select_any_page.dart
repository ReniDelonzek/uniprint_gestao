import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:uniprintgestao/app/shared/api/graph_ql_objetct.dart';
import 'package:uniprintgestao/app/shared/utils/utils_sentry.dart';
import 'package:uniprintgestao/app/shared/widgets/falha/falha_widget.dart';

import 'filtro/filtro_page.dart';
import 'models/item_select.dart';
import 'models/select_model.dart';
import 'select_any_controller.dart';
import 'select_any_module.dart';

class SelectAnyPage extends StatefulWidget {
  static const TIPO_SELECAO_SIMPLES = 0;
  static const TIPO_SELECAO_MULTIPLA = 1;
  static const TIPO_SELECAO_ACAO = 2;
  final SelectModel _selectModel;
  Map data;

  SelectAnyPage(this._selectModel, {this.data});

  @override
  _SelectAnyPageState createState() {
    return _SelectAnyPageState();
  }
}

class AppController {}

class _SelectAnyPageState extends State<SelectAnyPage> {
  Future<List<ItemSelect>> future;
  final SelectAnyController controller =
      SelectAnyModule.to.bloc<SelectAnyController>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  _SelectAnyPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final Map args = ModalRoute.of(context).settings.arguments;
    if (args?.containsKey('data') ?? false) {
      if (widget.data == null) {
        widget.data = Map();
      }
      widget.data.addAll(args['data']);
    }
    future =
        widget._selectModel.query == null ? getListFromServer() : getList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    controller.filter.addListener(() {
      if (controller.filter.text.isEmpty) {
        controller.searchText = "";
        controller.listaExibida.clear();
        controller.listaExibida.addAll(controller.listaOriginal);
      } else {
        controller.searchText = controller.filter.text;
        controller.clearList();
        List<ItemSelect> tempList = new List();
        for (int i = 0; i < controller.listaOriginal.length; i++) {
          for (var value in controller.listaOriginal[i].strings.values) {
            if (value
                    ?.toLowerCase()
                    ?.contains(controller.searchText.toLowerCase()) ==
                true) {
              tempList.add(controller.listaOriginal[i]);
            }
          }
        }
        controller.listaExibida.addAll(tempList);
      }
    });

    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Observer(builder: (_) => controller.appBarTitle),
        actions: _getMenuButtons(),
        leading: Observer(
          builder: (_) => new IconButton(
            icon: controller.searchIcon,
            onPressed: _searchPressed,
          ),
        ),
      ),
      bottomNavigationBar:
          widget._selectModel.tipoSelecao == SelectAnyPage.TIPO_SELECAO_MULTIPLA
              ? BottomNavigationBar(
                  onTap: (pos) {
                    Navigator.pop(
                        context,
                        controller.listaExibida
                            .where((item) => item.isSelected)
                            .map((item) => item.object)
                            .toList());
                  },
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.clear), title: Text('')),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.done), title: Text('Concluído')),
                  ],
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _getFloatingActionButtons(),
        ),
      ),
      body: _getBody(),
    );
  }

  void _searchPressed() {
    controller.pesquisar();
    if (controller.searchIcon.icon == Icons.search) {
      controller.searchIcon = new Icon(Icons.close);
      controller.appBarTitle = new TextField(
        autofocus: true,
        controller: controller.filter,
        decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search), hintText: 'Pesquise...'),
      );
    } else {
      controller.searchIcon = new Icon(Icons.search);
      controller.appBarTitle = new Text(widget._selectModel.titulo);
      controller.listaExibida.addAll(controller.listaOriginal);
      controller.filter.clear();
    }
  }

  _getBody() {
    return FutureBuilder<List<ItemSelect>>(
      future: future,
      builder:
          (BuildContext context, AsyncSnapshot<List<ItemSelect>> snapshot) {
        if (snapshot.hasError)
          return FalhaWidget('Houve uma falha ao recuperar os dados');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new RefreshProgressIndicator());
          default:
            if (snapshot.data.isEmpty)
              return Center(child: new Text('Nenhum registro encontrado'));
            else
              return Observer(
                  builder: (_) => RefreshIndicator(
                        onRefresh: () async {
                          future = widget._selectModel.query == null
                              ? getListFromServer()
                              : getList();
                        },
                        key: _refreshIndicatorKey,
                        child: new ListView.builder(
                            itemCount: controller.listaExibida.length,
                            itemBuilder: (context, index) {
                              return Observer(
                                  builder: (_) => _getItemList(
                                      controller.listaExibida[index]));
                            }),
                      ));
        }
      },
    );
  }

  Widget _getItemList(ItemSelect itemSelect) {
    if (itemSelect.strings.length <= 2) {
      return new Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: ListTile(
            leading: widget._selectModel.tipoSelecao == 1
                ? Checkbox(
                    onChanged: (newValue) {
                      itemSelect.isSelected = newValue;
                    },
                    value: itemSelect.isSelected)
                : null,
            title:
                _getLinha(itemSelect.strings.entries.first, itemSelect.object),
            subtitle: (itemSelect.strings.length > 1)
                ? _getLinha(
                    itemSelect.strings.entries.toList()[1], itemSelect.object)
                : null,
            onTap: () async {
              _tratarOnTap(itemSelect);
            },
            onLongPress: () {
              _tratarOnLongPres(itemSelect);
            },
          ));
    } else {
      return InkWell(
        onTap: () {
          _tratarOnTap(itemSelect);
        },
        onLongPress: () {
          _tratarOnLongPres(itemSelect);
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getTexts(itemSelect.strings, itemSelect.object)),
        ),
      );
      /*return Padding(//layout com suporte a selecao
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: widget.tipoSelecao == SelectAnyPage.TIPO_SELECAO_MULTIPLA
                  ? Checkbox(
                      value: itemSelect.isSelected,
                      onChanged: (newValue) {
                        itemSelect.isSelected = newValue;
                        controller.listaOriginal
                            .where((i) => i.id == itemSelect.id)
                            .first
                            .isSelected = newValue;
                      })
                  : Text(''),
            ),
            Container(
              //width: size.width - 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: getTexts(itemSelect.strings),
              ),
            ),
          ],
        ),
      );*/
    }
  }

  Widget _getLinha(MapEntry item, Map map) {
    Linha linha = widget._selectModel.linhas
        .firstWhere((linha) => linha.chave == item.key);
    if (linha != null &&
        (linha.involucro != null || linha.personalizacao != null)) {
      if (linha.personalizacao != null) {
        return linha.personalizacao(map);
      }
      return (Text(linha.involucro.replaceAll(
          '???', item.value?.toString() ?? linha.valorPadrao ?? '')));
    } else {
      return (Text(item.value?.toString() ?? linha.valorPadrao ?? ''));
    }
  }

  _getTexts(Map<String, dynamic> map, Map obj) {
    List<Widget> widgets = List();
    for (var item in map.entries) {
      widgets.add(_getLinha(item, obj));
    }
    return widgets;
  }

  dynamic _getValorLinha(String coluna, Map<String, dynamic> map) {
    List<String> colunas = coluna.split('/');
    for (int i = 0; i < colunas.length - 1; i++) {
      //vai ate o penultimo
      map = map[colunas[i]];
    }
    return map[colunas.last];
  }

  Future<List<ItemSelect>> getList() async {
    try {
      var res =
          await GraphQlObject.hasuraConnect.query(widget._selectModel.query);
      if (res != null) {
        if (res['data'][widget._selectModel.chaveLista] != null) {
          List<ItemSelect> itens = List();
          for (var map in res['data'][widget._selectModel.chaveLista]) {
            ItemSelect item = ItemSelect();
            item.object = map;
            item.id = map[widget._selectModel.id];
            for (Linha linha in widget._selectModel.linhas) {
              item.strings[linha.chave] = _getValorLinha(linha.chave, map);
            }
            itens.add(item);
          }
          controller.listaOriginal.clear();
          controller.listaExibida.clear();
          controller.listaOriginal.addAll(itens);
          controller.listaExibida.addAll(itens);
          return itens;
        } else {
          return <ItemSelect>[];
        }
      }
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
    }
    return <ItemSelect>[];
  }

  Future<List<ItemSelect>> getListFromServer() async {
    return <ItemSelect>[];
    /*var res = await API.post(widget._selectModel.url, data: widget.data);
    if (res.statusCode == 200) {
      return _gerarLista(res.data);
    } else {
      throw ('Falha na resposta do servidor: ${res.data}');
    }*/
  }

  _getMenuButtons() {
    if ((!kIsWeb) && !Platform.isAndroid) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ];
    } else
      return <Widget>[];
  }

  String cortarString(String st) {
    if (st.length > 500) {
      return st.substring(0, 500);
    } else
      return st;
  }

  void _onAction(ItemSelect itemSelect, Acao acao) async {
    Map<String, dynamic> dados = Map();
    if (itemSelect != null && acao.chaves?.entries != null) {
      for (MapEntry dado in acao.chaves.entries) {
        if ((itemSelect.object as Map).containsKey(dado.key)) {
          dados.addAll({dado.value: itemSelect.object[dado.key]});
        } else if (widget.data.containsKey(dado.key)) {
          dados.addAll({dado.value: widget.data[dado.key]});
        }
      }
    }
    var res = await Navigator.of(context).push(new MaterialPageRoute(
        builder: acao.route,
        settings: (itemSelect != null)
            ? RouteSettings(arguments: {
                'cod_obj': itemSelect.id,
                'obj': itemSelect.object,
                'data': dados
              })
            : RouteSettings()));

    if (res != null) {
      Navigator.pop(context);
    }
  }

  _getFloatingActionButtons() {
    List<Widget> widgets = List();
    if (!(widget._selectModel.filtros?.isEmpty ?? true)) {
      widgets.add(FloatingActionButton(
          onPressed: () async {
            Map<String, List<String>> s = await Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new FiltroPage(widget._selectModel.filtros)));
            if (widget.data == null) {
              widget.data = Map();
            }
            widget.data['filtros'] = s;
            future = widget._selectModel.query == null
                ? getListFromServer()
                : getList();
          },
          mini: (!(widget._selectModel.acoes?.isEmpty ?? true)),
          child: Icon(Icons.filter_list)));
    }
    if (!(widget._selectModel.botoes?.isEmpty ?? true)) {
      widgets.add(FloatingActionButton(
        tooltip: widget._selectModel.botoes.first?.descricao,
        onPressed: () {
          _onAction(null, widget._selectModel.botoes.first);
        },
        child: Icon(Icons.add),
      ));
    }
    return widgets;
  }

  void _exibirListaAcoes(ItemSelect itemSelect) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: widget._selectModel.acoes
                  .map((acao) => new ListTile(
                      title: new Text(acao.descricao),
                      onTap: () {
                        Navigator.pop(context);
                        _onAction(itemSelect, acao);
                      }))
                  .toList(),
            ),
          );
        });
  }

  void _tratarOnLongPres(ItemSelect itemSelect) {
    if (widget._selectModel.acoes != null) {
      if (widget._selectModel.acoes.length > 1) {
        _exibirListaAcoes(itemSelect);
      } else {
        Acao acao = widget._selectModel.acoes?.first;
        if (acao != null) {
          _onAction(itemSelect, acao);
        }
      }
    } else if (widget._selectModel.tipoSelecao ==
        SelectAnyPage.TIPO_SELECAO_SIMPLES) {
      Navigator.pop(context, itemSelect.object);
    } else if (widget._selectModel.tipoSelecao ==
        SelectAnyPage.TIPO_SELECAO_MULTIPLA) {
      itemSelect.isSelected = !itemSelect.isSelected;
    } else {
      //case seja do tipo acao, mas n tenha nenhuma acao
      Navigator.pop(context, itemSelect.object);
    }
  }

  void _tratarOnTap(ItemSelect itemSelect) {
    if (widget._selectModel.tipoSelecao == SelectAnyPage.TIPO_SELECAO_ACAO &&
        widget._selectModel.acoes != null) {
      if (widget._selectModel.acoes.length > 1) {
        _exibirListaAcoes(itemSelect);
      } else if (widget._selectModel.acoes.isNotEmpty) {
        Acao acao = widget._selectModel.acoes?.first;
        if (acao != null) {
          _onAction(itemSelect, acao);
        }
      }
    } else if (widget._selectModel.tipoSelecao ==
        SelectAnyPage.TIPO_SELECAO_SIMPLES) {
      Navigator.pop(context, itemSelect.object);
    } else if (widget._selectModel.tipoSelecao ==
        SelectAnyPage.TIPO_SELECAO_MULTIPLA) {
      itemSelect.isSelected = !itemSelect.isSelected;
    }
  }
}
