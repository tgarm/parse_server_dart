import 'package:parse_server/src/parse_object.dart';
import 'package:parse_server/src/parse_user.dart';
import 'package:parse_server/src/parse_livequery.dart';
import 'package:parse_server/src/parse_http_client.dart';
import 'package:parse_server/src/credentials.dart';
import 'package:parse_server/src/queries/parse_query.dart';

abstract class ParseBaseObject {
  final String className;
  final ParseHTTPClient client;
  String path;
  Map<String, dynamic> objectData;

  String get objectId => objectData['objectId'];

  void _handleResponse(Map<String, dynamic> response){}

  ParseBaseObject(String this.className, [ParseHTTPClient this.client]);
}

class Parse {
  Credentials credentials;
  final String liveQueryServerURL;
  final String serverURL;
  final ParseHTTPClient client = new ParseHTTPClient();

  Parse(Credentials credentials, String serverURL,[String liveQueryServerURL])
    : credentials = credentials,
      serverURL = serverURL,
      liveQueryServerURL = liveQueryServerURL {
      client.baseURL = serverURL;
      client.liveQueryURL ??= liveQueryServerURL;
      client.credentials = credentials;
  }

  ParseObject _parseObject;
  User _user;
  LiveQuery _liveQuery;

  ParseObject object(objectName) {
    return _parseObject = new ParseObject(objectName, client);
  }

  User user() {
    return _user = new User(client);
  }

  Query query(objectName){
    return new Query(objectName,this.client);
  }

  LiveQuery liveQuery() {
    return _liveQuery = new LiveQuery(client);
  }

}
