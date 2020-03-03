import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

import '../widgets.dart';
import 'selecionar_range_data_controller.dart';

typedef RangeDateChanged(DateTime dataInicial, DateTime dataFinal);

class SelecionarRangeDataWidget extends StatelessWidget {
  final SelecionarRangeDataController controller;
  final String title;
  final String formatDate;

  final RangeDateChanged onChanged;
  SelecionarRangeDataWidget(this.title, this.onChanged, this.controller,
      {this.formatDate = 'dd/MM/yyyy'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(children: [
        TextTitle(title),
        Observer(
          builder: (_) => InkWell(
              onTap: () async {
                _showDatePicked(context);
              },
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 45,
                    width: 220,
                    constraints: BoxConstraints(
                        minWidth: 45,
                        maxWidth: 250,
                        minHeight: 45,
                        maxHeight: 60),
                    decoration: BoxDecoration(
                        color: Color(0xFFf5f5f5),
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      alignment: Alignment.center,
                      child: Text(
                        this.controller.data != null
                            ? this.controller.data
                            : 'Selecione a data',
                        maxLines: 2,
                      ),
                    ),
                  ))),
        )
      ]),
    );
  }

  Future _showDatePicked(BuildContext context) async {
    //DateTime dataFinalPadrao = new DateTime.now().add(new Duration(days: 7));
    //DateTime dataFinal = dataMax == null ? (dataFinalPadrao) : dataMax;
    /*(dataMax.isBefore(dataFinalPadrao)
            ? DateTime.fromMicrosecondsSinceEpoch(
                    dataMax.millisecondsSinceEpoch)
                .subtract(Duration(days: 1))
            : (dataFinalPadrao));*/
    final List<DateTime> dates = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: controller.dataInicial ?? DateTime.now(),
        initialLastDate: controller.dataFinal ??
            (controller.dataInicial ?? new DateTime.now())
                .add(new Duration(days: 7)),
        firstDate: controller.dataMin ?? new DateTime(2019),
        lastDate: controller.dataMax ??
            new DateTime.now().add(new Duration(days: 365)));
    if (dates != null && dates.isNotEmpty) {
      if (dates.length == 1) {
        /*dates.add(DateTime(
            dates.first.year, dates.first.month, dates.first.day, 23, 59, 59));*/
      }
      this.controller.dataInicial = DateTime(
          dates.first.year, dates.first.month, dates.first.day, 0, 0, 0);
      if (dates.length > 1) {
        this.controller.dataFinal = DateTime(
            dates.last.year, dates.last.month, dates.last.day, 23, 59, 59);
      } else {
        this.controller.dataFinal = null;
      }
      onChanged(this.controller.dataInicial, this.controller.dataFinal);
    }
  }
}
