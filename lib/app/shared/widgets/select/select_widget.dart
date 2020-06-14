import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../widgets.dart';
import 'select_controller.dart';

class SelectWidget extends StatelessWidget {
  var controller = SelectController();
  final String title;
  final GestureTapCallback onTap;

  SelectWidget(this.title, this.onTap, {SelectController controller}) {
    if (controller != null) {
      this.controller = controller;
    }
    //this.controller.value = (value ?? 'Clique para selecionar');
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextTitle(title),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: InkWell(
            onTap: onTap,
            child: Container(
                padding: EdgeInsets.only(left: 16),
                child: Container(
                  height: 45,
                  constraints: BoxConstraints(
                      minWidth: 45,
                      maxWidth: 500,
                      minHeight: 45,
                      maxHeight: 60),
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).cardColor
                          : Color(0xFFf5f5f5),
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    alignment: Alignment.centerLeft,
                    child: Observer(
                      builder: (_) => Text(
                        controller.value ?? 'Clique para selecionar',
                        maxLines: 2,
                      ),
                    ),
                  ),
                ))),
      )
    ]);
  }
}
