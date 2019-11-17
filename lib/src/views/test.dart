/*
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uniprintgestao/src/Api/graphQlObjetct.dart';
import 'package:uniprintgestao/src/temas/Tema.dart';

class Test extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TestScreenState();
  }
}

class TestScreenState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Tema.getTema(context),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Teste'),
        ),
        body: GraphQLProvider(
          client: graphQlObject.client,
          child: CacheProvider(
            child: Query(
              options: QueryOptions(document: getQuery(), pollInterval: 30),
              builder: (QueryResult result, {VoidCallback refetch}) {
                if (result.errors != null) {
                  return Text(result.errors.toString());
                }
                if (result.loading) {
                  return Text('Loading');
                }
                return Text(result.data.toString());
              },
            ),
          ),
        ),
      ),
    );
  }

  String getQuery() {
    return """query MyQuery {
  __typename
  Usuario {
    nome
    uid
  }
}""";
  }
}
*/
