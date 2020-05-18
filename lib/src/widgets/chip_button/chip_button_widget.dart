import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:uniprintgestao/src/widgets/chip_button/chip_button_controller.dart';

class ChipButtonState extends StatelessWidget {
  final ChipButtonController controller;
  final String title;
  final GestureTapCallback onTap;

  ChipButtonState(this.title, this.controller, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
          decoration: new BoxDecoration(
              color: controller.isSelected ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              border: new Border.all(color: Colors.blue)),
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.white24,
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                onTap: onTap,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 12, bottom: 12, left: 30, right: 30),
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0.27,
                          color: controller.isSelected
                              ? Colors.white
                              : Colors.blue),
                    ),
                  ),
                ),
              ))),
    );
  }
}
