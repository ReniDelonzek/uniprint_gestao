import 'package:flutter/material.dart';
import 'package:uniprintgestao/app/modules/select_any/models/filtro.dart';
import 'package:uniprintgestao/app/shared/widgets/button.dart';

import '../select_any_module.dart';
import 'filtro_controller.dart';

class FiltroPage extends StatefulWidget {
  final String title;
  final List<Filtro> filtros;

  const FiltroPage(this.filtros, {Key key, this.title = "Filtro"})
      : super(key: key);

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage> {
  final controller = SelectAnyModule.to.bloc<FiltroController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Builder(
              builder: (context) => Column(
                    children: <Widget>[
                      Column(
                          children: widget.filtros.map((item) {
                        TextEditingController textController =
                            TextEditingController();
                        controller.controllers[item.id] = textController;
                        return TextFormField(
                            keyboardType: item.inputType,
                            textCapitalization: item.textCapitalization,
                            controller: textController,
                            decoration: InputDecoration(labelText: item.label));
                      }).toList()),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Button('Salvar', () {
                          Map<String, List<String>> s = Map();
                          controller.controllers.forEach((chave, valores) {
                            if (valores.text.isNotEmpty) {
                              List<String> subList = List();
                              valores.text.split(',').forEach((valor) {
                                subList.add(valor);
                              });
                              s[chave] = subList;
                            }
                          });
                          Navigator.pop(context, s);
                        }),
                      )
                    ],
                  )),
        ));
  }
}
