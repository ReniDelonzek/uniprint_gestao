import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprintgestao/app/modules/select_any/models/select_model.dart';
import 'package:uniprintgestao/app/modules/select_any/select_any_module.dart';
import 'package:uniprintgestao/app/modules/select_any/select_any_page.dart';
import 'package:uniprintgestao/app/shared/api/querys.dart';
import 'package:uniprintgestao/app/shared/graph/tipo_folha.dart';
import 'package:uniprintgestao/app/shared/widgets/button.dart';
import 'package:uniprintgestao/app/shared/widgets/selecionar_range_data/selecionar_range_data_widget.dart';
import 'package:uniprintgestao/app/shared/widgets/select/select_widget.dart';
import 'package:uniprintgestao/app/shared/widgets/widgets.dart';
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
  final CadastroPrecoController _controller =
      CadastroPrecoModule.to.bloc<CadastroPrecoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _controller.ctlValor,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Insira o valor'),
                ),
                SelectWidget('Tipo de folha', () async {
                  var res = await Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new SelectAnyModule(SelectModel(
                                  'Tipos de Folha',
                                  'id',
                                  [Linha('nome')],
                                  SelectAnyPage.TIPO_SELECAO_SIMPLES,
                                  query: Querys.tiposFolha,
                                  chaveLista: 'tipo_folha'))));
                  if (res != null) {
                    _controller.ctlTipoFolha.value = res['nome'];
                    _controller.tipoFolha = TipoFolha.fromMap(res);
                  }
                }, controller: _controller.ctlTipoFolha),
                SelecionarRangeDataWidget(
                    'Selecione o período de vigor do preço',
                    (dataInicio, dataFim) {},
                    _controller.ctlDatas),
                Observer(
                  builder: (_) => CheckboxListTile(
                      value: _controller.colorido,
                      onChanged: (b) {
                        _controller.colorido = b;
                      },
                      title: Text('Colorido')),
                ),
                Button('Salvar', () async {
                  String msg = _controller.verificarDados();
                  if (msg == null) {
                    ProgressDialog progressDialog = ProgressDialog(context)
                      ..style(message: 'Cadastrando preço...');
                    await progressDialog.show();
                    bool sucesso = await _controller.salvarDados();
                    progressDialog.hide();
                    if (sucesso) {
                      showSnack(context, 'Preço cadastrado com sucesso',
                          dismiss: true, data: true);
                    } else {
                      showSnack(context,
                          'Ops, houve uma falha ao cadastrar os dados');
                    }
                  } else {
                    showSnack(context, msg);
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
