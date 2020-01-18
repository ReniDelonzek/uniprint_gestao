import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uniprintgestao/src/api/graphQlObjetct.dart';
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
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  if (result.exception != null) {
                    return Text(result.exception.toString());
                  }

                  if (result.loading) {
                    return Text('Loading');
                  }
                  return Text(result.data);
                }),
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
