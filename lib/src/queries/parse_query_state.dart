import 'package:parse_server_dart/src/parse_http_client.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parse_server_dart/src/parse_base.dart';
import 'package:parse_server_dart/src/queries/parse_query_constants.dart';

@JsonSerializable(nullable: false)
class QueryState implements ParseBaseObject {

  String className;
  final ParseHTTPClient client;
  String path;

  String get objectId => null;
  Map<String, dynamic> objectData = {};

  Map _conditions;

  QueryState(String this.className, [ParseHTTPClient this.client]) {
    path = "/classes/${className}";
    _conditions = {};
  }

  void setConditionType(String conditionType, dynamic value, String key) {
    var condition;

    if (_conditions[key] != null) {
      condition = _conditions[key];
    }else {
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

/*  fromJson(Map<String, dynamic> json) {
    this._conditions = json.decode(json);
  }
  
  Map<String, dynamic> toJson() => json.encode(_conditions);

  String toString() {
    return toJson().toString();
  }*/
}