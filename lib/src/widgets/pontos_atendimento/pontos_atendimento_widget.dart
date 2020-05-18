import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:uniprintgestao/src/models/graph/ponto_atendimento.dart';
import 'package:uniprintgestao/src/widgets/chip_button/chip_button_controller.dart';
import 'package:uniprintgestao/src/widgets/chip_button/chip_button_widget.dart';

import '../widgets.dart';
import 'pontos_atendimento_controller.dart';

class PontosAtendimentoWidget extends StatelessWidget {
  final PontosAtendimentoController _controller;
  final String title;
  final ValueChanged<PontoAtendimento> onSelect;
  final List<PontoAtendimento> locais = List();

  PontosAtendimentoWidget(this.title, this.onSelect, this._controller);

  @override
  Widget build(BuildContext context) {
    PontoAtendimento local1 = PontoAtendimento();
    local1.nome = 'CTU';
    local1.id = 1;
    locais.add(local1);
    PontoAtendimento local2 = PontoAtendimento();
    local2.nome = 'Sede';
    local2.id = 2;
    locais.add(local2);
    PontoAtendimento local3 = PontoAtendimento();
    local3.nome = 'Cleve';
    local3.id = 3;
    locais.add(local3);
    return _getLocais();
  }

  Widget _getLocais() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 0.0, left: 0, right: 16),
                child: TextTitle(title)),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: locais
                      .map((e) => Observer(
                            builder: (_) => ChipButtonState(
                                e.nome,
                                ChipButtonController(
                                    e.id == _controller.pontoAtendimento?.id),
                                () {
                              _controller.pontoAtendimento = e;
                              onSelect(_controller.pontoAtendimento);
                            }),
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
