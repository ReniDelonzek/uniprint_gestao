import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/src/temas/Tema.dart';
import 'package:uniprint/src/views/operador/cadastros/cadastro_atendente.dart';

class ListaAtendente extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ListaAtendentePageState();
  }
}

class ListaAtendentePageState extends State<ListaAtendente> {
  String turno;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: Tema.getTema(context),
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text(
                "Lista de atendentes",
                style: new TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new CadastroAtendente()));
              },
              child: Icon(Icons.add),
            ),
            backgroundColor: Colors.white,
            body: _getItemAtendimento(context)));
  }

  Widget _getItemAtendimento(BuildContext context) {
    List<Widget> createChildren(AsyncSnapshot<QuerySnapshot> s) {
      return s.data.documents
          .map(
            (document) => InkWell(
                onTap: () {},
                child: new Padding(
                  padding: EdgeInsets.all(15.0),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[_getItensCard(document)]),
                )),
          )
          .toList();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("Atendentes").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new RefreshProgressIndicator());
          default:
            if (snapshot.data?.documents?.isEmpty ?? true)
              return Center(
                  child: new Text('Nenhum atendente cadastrado ainda'));
            else
              return new ListView(children: createChildren(snapshot));
        }
      },
    );
  }

  Widget _getItensCard(DocumentSnapshot document) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        children: <Widget>[
          new Text(
            document['nome'] ?? "<Funcionário sem nome>",
            style: TextStyle(fontSize: 18, color: Colors.black),
          )
        ],
      ),
    );
  }
}
