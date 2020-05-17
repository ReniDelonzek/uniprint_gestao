import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:uniprintgestao/src/api/querys.dart';
import 'package:uniprintgestao/src/models/graph/tipo_folha.dart';
import 'package:uniprintgestao/src/modules/select_any/models/select_model.dart';
import 'package:uniprintgestao/src/modules/select_any/select_any_module.dart';
import 'package:uniprintgestao/src/modules/select_any/select_any_page.dart';
import 'package:uniprintgestao/src/widgets/button.dart';
import 'package:uniprintgestao/src/widgets/selecionar_range_data/selecionar_range_data_widget.dart';
import 'package:uniprintgestao/src/widgets/select/select_widget.dart';

import 'cadastro_preco_controller.dart';
import 'cadastro_preco_module.dart';

class CadastroPrecoPage extends StatefulWidget {
  final String title;
  const CadastroPrecoPage({Key key, this.title = "Cadastrar Preço"})
      : super(key: key);

  @override
  _CadastroPrecoPageState createState() => _CadastroPrecoPageState();
}

class _CadastroPrecoPageState extends State<CadastroPrecoPage> {
  final _controller = CadastroPrecoModule.to.bloc<CadastroPrecoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (content) => Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Insira o valor'),
              ),
              SelectWidget('Tipo de folha', () async {
                var res = await Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new SelectAnyModule(
                            SelectModel('Tipos de Folha', 'id', [Linha('nome')],
                                SelectAnyPage.TIPO_SELECAO_SIMPLES,
                                query: Querys.tiposFolha,
                                chaveLista: 'tipo_folha'))));
                if (res != null) {
                  _controller.ctlTipoFolha.value = res['nome'];
                }
              }, controller: _controller.ctlTipoFolha),
              SelecionarRangeDataWidget('Selecione o período de vigor do preço',
                  (dataInicio, dataFim) {}, _controller.ctlDatas),
              Button('Salvar', () {}),
            ],
          ),
        ),
      ),
    );
  }
}
