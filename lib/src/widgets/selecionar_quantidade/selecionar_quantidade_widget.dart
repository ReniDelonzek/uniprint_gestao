import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../widgets.dart';
import 'selecionar_quantidade_controller.dart';
import '../../extensions/string.dart';

class SelecionarQuantidadeWidget extends StatelessWidget {
  final SelecionarQuantidadeController controller =
      SelecionarQuantidadeController();
  final double quantidade;
  final double min;
  final double max;
  final ValueChanged<double> changed;

  SelecionarQuantidadeWidget(this.quantidade, this.changed,
      {this.min = 1, this.max = 999999999999999}) {
    controller.quantidade = this.quantidade;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          _showDialogQuantidade(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: Color(0xFFf5f5f5),
                  borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                child: Icon(Icons.remove, size: 18),
                onTap: () {
                  if (controller.quantidade > min) {
                    changed(--controller.quantidade);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Observer(
                  builder: (_) => Text(
                        controller.quantidade.toString(),
                        style: TextStyle(fontSize: 15),
                      )),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: Color(0xFFf5f5f5),
                  borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                child: Icon(Icons.add, size: 18),
                onTap: () {
                  //if (max > -1.0 && controller.quantidade < max) {
                  changed(++controller.quantidade);
                  //}
                },
              ),
            ),
          ],
        ));
  }

  _showDialogQuantidade(BuildContext context) {
    controller.cltQuantidade.text = controller.quantidade.toString();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Insira a quantidade'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration:
                        InputDecoration(labelText: 'Quantidade de Toras'),
                    controller: controller.cltQuantidade,
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text('Confirmar'),
                    onPressed: () {
                      if (controller.cltQuantidade.text.isEmpty) {
                        showSnack(context, 'A quantidade não pode ficar vazia');
                      } else if (controller.cltQuantidade.text.toDouble() <
                          min) {
                        showSnack(context,
                            'A quantidade especificada é menor que a quantidade mínima permitida');
                      } else if (controller.cltQuantidade.text.toDouble() >
                          max) {
                        showSnack(context,
                            'A quantidade especificada é maior que a quantidade máxima permitida');
                      } else {
                        controller.quantidade =
                            controller.cltQuantidade.text.toDouble();
                        changed(controller.quantidade);
                        Navigator.pop(context);
                      }
                    })
              ],
            ));
  }
}
