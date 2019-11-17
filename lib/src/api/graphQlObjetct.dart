import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uniprintgestao/src/utils/PreferenceToken.dart';

class GraphQlObject {
  static HttpLink httpLink = HttpLink(
    uri: 'https://uniprint-test.herokuapp.com/v1/graphql',
  );
  static AuthLink authLink = AuthLink(getToken: () async {
    //var user = await FirebaseAuth.instance.getUser();
    //var box = await Hive.openBox('myBox');
    //Token token = Token.fromMap(box.get('auth_token'));
    var a = await PreferencesStore.create();
    return "Bearer ${a.refreshToken ?? ''}";
  });

  static Link link = authLink.concat(httpLink);
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    ),
  );
}

GraphQlObject graphQlObject = new GraphQlObject();
