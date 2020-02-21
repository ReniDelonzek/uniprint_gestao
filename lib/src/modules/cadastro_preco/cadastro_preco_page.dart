import 'package:flutter/material.dart';
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
        builder: (content) => Column(
          children: <Widget>[
            SelectWidget('Tipo de folha', () {}),
            SelecionarRangeDataWidget('Selecione o período de vigor do preço',
                (dataInicio, dataFim) {}, _controller.ctlDatas),
            Button('Salvar', () {}),
          ],
        ),
      ),
    );
  }
}
