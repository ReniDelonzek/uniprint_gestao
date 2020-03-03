import 'package:hasura_connect/hasura_connect.dart';
import 'package:uniprintgestao/src/utils/preference_token.dart';

class GraphQlObject {
  static String url = 'https://uniprint-uv.herokuapp.com/v1/graphql';

  static HasuraConnect hasuraConnect =
      HasuraConnect(url, token: (isError) async {
    var a = await PreferencesStore.create();
    return "Bearer ${a?.refreshToken ?? ''}";
  });
}

GraphQlObject graphQlObject = new GraphQlObject();
