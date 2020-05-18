import 'package:flutter/material.dart';

class SelectWidget extends StatelessWidget {
  final String title;
  final String value;
  final GestureTapCallback onTap;

  SelectWidget(this.title, this.value, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        InkWell(
            onTap: onTap,
            child: Container(
                child: Container(
              height: 45,
              constraints: BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                  color: Color(0xFFf5f5f5),
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                alignment: Alignment.centerLeft,
                child: Text(value ?? 'Clique para selecionar'),
              ),
            )))
      ]),
    );
  }
}
