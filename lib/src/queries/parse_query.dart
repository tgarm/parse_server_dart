import 'dart:async';
import 'dart:convert';
import 'package:parse_server/src/parse_base.dart';
import 'package:parse_server/src/parse_http_client.dart';
import 'package:parse_server/src/queries/parse_query_state.dart';
import 'package:parse_server/src/queries/parse_query_constants.dart';


class Query implements ParseBaseObject {
  String className;
  final ParseHTTPClient client;
  String path;
  List<dynamic> results;
  String queryString;

  String get objectId => null;
  Map<String, dynamic> objectData = {};
  QueryState state;

  Query(String this.className, [ParseHTTPClient this.client]) : state = QueryState(className) {
    path = "/classes/${className}";
  }

  Query whereCondition(String condition, String key, dynamic value) {
    // check if command is running
    state.setConditionType(condition, value, key);
    return null;
  }

  Query whereEqualTo(String key, dynamic value) {
    state.setEqualityCondition(key, value);
    return this;
  }

  Query whereGreaterThan(String key, dynamic value) {
    return whereCondition(QueryConstants.PFQueryKeyGreaterThan, key, value);
  }

  Future<List<dynamic>> findObjects() {
    var resp = client.get("${client.baseURL}${path}");
    return resp.then((value){
      var res = json.decode(value.body);
      List list = res['results'];
      return list;
    });
  }
}