import 'dart:async';
import 'dart:convert';
import 'parse_base.dart';
import 'parse_http_client.dart';
import 'parse_query_state.dart';
import 'parse_query_constants.dart';


class Query implements ParseBaseObject {
  String className;
  final ParseHTTPClient client;
  String path;
  List<dynamic> results;
  String _queryString;

  String get objectId => null;
  Map<String, dynamic> objectData = {};
  final QueryState _state;

  Query(String this.className, [ParseHTTPClient this.client]) : _state = QueryState(className) {
    path = "/classes/${className}";
  }

  Query whereCondition(String condition, String key, dynamic value) {
    // check if command is running
    _state.setConditionType(condition, value, key);
    return null;
  }

  Query whereEqualTo(String key, dynamic value) {
    _state.setEqualityCondition(key, value);
    return this;
  }

  Query whereGreaterThan(String key, dynamic value) {
    return whereCondition(QueryConstants.PFQueryKeyGreaterThan, key, value);
  }

  Future<List<dynamic>> findObjectsInBackground() {
    // TODO
  }
  
  /** WORKAROUND **/
  get queryString => _queryString;

  set queryString(String q) {
    _queryString = json.encode(client);
  }
}