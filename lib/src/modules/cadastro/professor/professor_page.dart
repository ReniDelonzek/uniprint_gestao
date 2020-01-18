import 'package:flutter/material.dart';

class ProfessorPage extends StatefulWidget {
  final String title;
  const ProfessorPage({Key key, this.title = "Professor"}) : super(key: key);

  @override
  _ProfessorPageState createState() => _ProfessorPageState();
}

class _ProfessorPageState extends State<ProfessorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
