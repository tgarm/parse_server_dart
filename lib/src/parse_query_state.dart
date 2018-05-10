import 'parse_http_client.dart';

import 'parse_base.dart';
import 'parse_query_constants.dart';

class QueryState implements ParseBaseObject {

  String className;
  final ParseHTTPClient client;
  String path;

  String get objectId => null;
  Map<String, dynamic> objectData = {};

  Map _conditions;

  QueryState(String this.className, [ParseHTTPClient this.client]) {
    path = "/parse/classes/${className}";
    _conditions = {};
  }

  void setConditionType(String conditionType, dynamic value, String key) {
    var condition = null;

    var val = _conditions[key];
    if (val != null) {
      condition = val;
    }

    if (condition == null) {
      condition = {};
    }

    condition[conditionType] = value;

    setEqualityCondition(key, condition);
  }

  void setEqualityCondition(String key, dynamic value) {
    _conditions[key] = value;
  }

  void setRelationConditionWithObject(dynamic value, String key) {
    var condition = {};
    condition["object"] = value;
    condition["key"] = key;
    
    setEqualityCondition(QueryConstants.PFQueryKeyRelatedTo, condition);
  }
  
}