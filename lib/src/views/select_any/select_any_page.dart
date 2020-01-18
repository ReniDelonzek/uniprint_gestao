import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uniprintgestao/src/api/graphQlObjetct.dart';
import 'package:uniprintgestao/src/views/select_any/select_any_controller.dart';
import 'package:uniprintgestao/src/views/select_any/select_any_module.dart';

import 'filtro/filtro_page.dart';
import 'models/filtro.dart';
import 'models/item_select.dart';

class SelectAnyPage extends StatefulWidget {
  final int tipoSelecao; //0 selecao simples, 1 selecao multipla, 2 acao
  final String titulo;
  final String query;
  final String url;
  final List<String> chaves;
  final String id;
  final WidgetBuilder route;
  bool showLabels = false;
  Map data;
  List<Filtro> filtros;

  static int TIPO_SELECAO_SIMPLES = 0;
  static int TIPO_SELECAO_MULTIPLA = 1;
  static int TIPO_SELECAO_ACAO = 2;

  SelectAnyPage(this.titulo, this.tipoSelecao, this.chaves, this.id,
      {this.query,
      this.url,
      this.data,
      this.route,
      this.filtros,
      this.showLabels});

  @override
  _SelectAnyPageState createState() {
    return _SelectAnyPageState(this.tipoSelecao, this.titulo, this.query,
        this.url, this.chaves, this.id, this.data, this.route);
  }
}

class _SelectAnyPageState extends State<SelectAnyPage> {
  Future<List<ItemSelect>> future;
  final int tipoSelecao;
  final String titulo;
  final String query;
  final String url;
  final List<String> chaves;
  final String id;
  final Map data;
  final WidgetBuilder route;

  final controller = SelectAnyModule.to.bloc<SelectAnyController>();

  _SelectAnyPageState(this.tipoSelecao, this.titulo, this.query, this.url,
      this.chaves, this.id, this.data, this.route);

  @override
  void initState() {
    //future = query == null ? getListFromServer() : getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    future = query == null ? getListFromServer() : getList();
    //ver forma de deixar isso no initState, lá ele carrega somente uma vez, porém n recarrega quando algum filtro é aplcifcao
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

    return GraphQLProvider(
      client: graphQlObject.client,
      child: CacheProvider(
        child: Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            title: Observer(builder: (_) => controller.appBarTitle),
            actions: _getActions(),
            leading: Observer(
              builder: (_) => new IconButton(
                icon: controller.searchIcon,
                onPressed: _searchPressed,
              ),
            ),
          ),
          bottomNavigationBar:
              widget.tipoSelecao == SelectAnyPage.TIPO_SELECAO_MULTIPLA
                  ? BottomNavigationBar(
                      onTap: (pos) {
                        Navigator.pop(
                            context,
                            controller.listaExibida
                                .where((item) => item.isSelected)
                                .map((item) => item.object));
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
              children: (widget.filtros?.isEmpty ?? true)
                  ? <Widget>[]
                  : <Widget>[
                      FloatingActionButton(
                          onPressed: () async {
                            Map<String, List<String>> s =
                                await Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new FiltroPage(widget.filtros)));
                            //print(s);
                            setState(() {
                              if (widget.data == null) {
                                widget.data = Map();
                              }
                              widget.data['filtros'] = s;
                            });
                          },
                          child: Icon(Icons.filter_list))
                    ],
            ),
          ),
          body: _getBody(),
        ),
      ),
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
      controller.appBarTitle = new Text(titulo);
      controller.listaExibida.addAll(controller.listaOriginal);
      controller.filter.clear();
    }
  }

  _getBody() {
    return Query(
        options: QueryOptions(
          document: widget.query,
          // this is the query string you just created
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.exception != null) {
            return Text(result.exception.toString());
          }

          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }
          List<ItemSelect> itens = List();
          for (var i in result.data['usuario']) {
            ItemSelect item = ItemSelect();
            item.strings['nome'] = i['pessoa']['nome'];
            item.strings['email'] = i['email'];
            item.id = i[widget.id];
            itens.add(item);
          }

          return ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, index) {
                final repository = itens[index];
                return _getItemList(repository);
              });
        });

    /*return FutureBuilder<List<ItemSelect>>(
      future: future,
      builder:
          (BuildContext context, AsyncSnapshot<List<ItemSelect>> snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new RefreshProgressIndicator());
          default:
            if (snapshot.data.isEmpty)
              return Center(child: new Text('Nenhum registro encontrado'));
            else
              return Observer(
                  builder: (_) => new ListView.builder(
                      itemCount: controller.listaExibida.length,
                      itemBuilder: (context, index) {
                        return Observer(
                            builder: (_) =>
                                _getItemList(controller.listaExibida[index]));
                      }));
        }
      },
    );*/
  }

  Widget _getItemList(ItemSelect itemSelect /*, Size size*/) {
    if (itemSelect.strings.length <= 2) {
      return new Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: ListTile(
            leading: widget.tipoSelecao == 1
                ? Checkbox(
                    onChanged: (newValue) {
                      itemSelect.isSelected = newValue;
                    },
                    value: itemSelect.isSelected)
                : null,
            title: Text(cortarString(itemSelect.strings.values.first ?? '')),
            subtitle: (itemSelect.strings.length > 1)
                ? Text(
                    cortarString(itemSelect.strings.values.toList()[1] ?? ''))
                : null,
            onTap: () async {
              if (widget.tipoSelecao == SelectAnyPage.TIPO_SELECAO_SIMPLES) {
                Navigator.pop(context, itemSelect.object);
              } else if (widget.tipoSelecao ==
                  SelectAnyPage.TIPO_SELECAO_MULTIPLA) {
                itemSelect.isSelected = !itemSelect.isSelected;
              } else if (widget.route != null) {
                var res = await Navigator.of(context).push(
                    new CupertinoPageRoute(
                        builder: widget.route,
                        settings: RouteSettings(arguments: {
                          'cod': itemSelect.id,
                          'obj': itemSelect.object
                        })));
                if (res != null) {
                  Navigator.pop(context);
                }
              }
            },
          ));
    } else {
      return Padding(
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
      );
    }
  }

  getTexts(Map<String, dynamic> map) {
    List<Widget> widgets = List();
    for (var item in map.values) {
      widgets.add(Text(item));
    }
    return widgets;
  }

  Future<List<ItemSelect>> getList() async {}

  Future<List<ItemSelect>> getListFromServer() async {
    List<ItemSelect> lista = List();
    /*var i = await API.post(url, data: data);
    if (i.statusCode == 200) {
      List<ItemSelect> lista = List();
      for (var a in i.data) {
        ItemSelect itemSelect = ItemSelect();
        for (var itemMap in widget.chaves) {
          if (a[itemMap] is List) {
            String s = "";
            for (var subItem in a[itemMap]) {
              s += "${subItem['package']}\n"; //todo fazer ser generico aqui
            }
            itemSelect.strings[itemMap] = s;
          } else {
            itemSelect.strings[itemMap] =
                ((widget.showLabels ?? false) ? '$itemMap: ' : '') +
                    a[itemMap].toString();
          }
        }
        itemSelect.isSelected = false;
        itemSelect.id = a[id];
        itemSelect.object = a;
        lista.add(itemSelect);
      }
      controller.listaOriginal.clear();
      controller.listaExibida.clear();
      controller.listaOriginal.addAll(lista);
      controller.listaExibida.addAll(lista);*/
    return lista;
  }

  _getActions() {
    if ((!kIsWeb) && Platform.isIOS) {
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
}
