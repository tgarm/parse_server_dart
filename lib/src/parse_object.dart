import 'dart:convert';
import 'dart:async';

import 'parse_base.dart';
import 'parse_http_client.dart';



class ParseObject implements ParseBaseObject {
  final String className;
  final ParseHTTPClient client;
  String path;
  Map<String, dynamic> objectData = {};

  String get objectId => objectData['objectId'];

  ParseObject(String this.className, [ParseHTTPClient this.client]) {
    path = "/parse/classes/${className}";
  }

  Future<Map> create([Map<String, dynamic> objectInitialData]) async {
    objectData = {}..addAll(objectData)..addAll(objectInitialData);

    final response = this.client.post("${client.baseURL}${path}", body: json.encode(objectData));
    return response.then((value){
      objectData = json.decode(value.body);
      return objectData;
    });
  }

  Future<dynamic> fetch(String objectId) async {
      final response = this.client.get(client.baseURL + "${path}/${objectId}");
      return response.then((value){
        objectData = json.decode(value.body);
        return objectData;
      });
  }

  dynamic get(attribute) async {
    if (objectData.containsKey(attribute)) {
     return objectData[attribute];
    }

    return null;
  }

  void set(String attribute, dynamic value){
    objectData[attribute] = value;
  }

  Future<Map> save([Map<String, dynamic> objectInitialData]){
    objectData = {}..addAll(objectData)..addAll(objectInitialData);
    if (objectId == null){
        return create(objectData);
    }
    else {
      final response = this.client.put(
          client.baseURL + "${path}/${objectId}",  body: json.encode(objectData));
      return response.then((value) {
        objectData = json.decode(value.body);
        return objectData;
      });
    }
  }

  Future<String> destroy(){
    final response = this.client.delete(client.baseURL + "${path}/${objectId}");
    return response.then((value){
      return json.decode(value.body);
    });
  }
}

