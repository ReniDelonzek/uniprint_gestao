import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:uniprintgestao/src/utils/PreferenceToken.dart';

class GraphQlObject {
  static String url = 'http://192.168.0.101:8080/v1/graphql';

  static HttpLink httpLink =
      HttpLink(uri: url //'https://uniprint-test.herokuapp.com/v1/graphql',
          );
  static AuthLink authLink = AuthLink(getToken: () async {
    var a = await PreferencesStore.create();
    return "Bearer ${a.refreshToken ?? ''}";
  });

  static HasuraConnect hasuraConnect =
      HasuraConnect(url, token: (isError) async {
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
