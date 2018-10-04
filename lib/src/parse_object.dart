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

  void _resetObject() {
    if (objectData.isNotEmpty) {
      objectData.clear();
    }
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

  // returns all entries in JSON
  Future<dynamic> fetchAll() async {
    final response = this.client.get(client.baseURL + "${path}");
    return response.then((value){
      return json.decode(value.body);
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

  Future<Map> saveNew([Map<String, dynamic> objectInitialData]) {
    _resetObject();
    return save(objectInitialData);
  }

  Future<Map> save([Map<String, dynamic> objectInitialData]){
    if (objectInitialData != null)
      objectData = {}..addAll(objectData)..addAll(objectInitialData);

    if (objectId == null){
        return create(objectData);
    }
    else {
      print(objectData);
      final response = this.client.put(
          client.baseURL + "${path}/${objectId}",
          body: json.encode(objectData));

      return response.then((value) {
        print(value.body);
        objectData = json.decode(value.body);
        return objectData;
      });
    }
  }

  Future<String> destroy(){
    final response = this.client.delete(client.baseURL + "${path}/${objectId}");
    return response.then((value){
      return value.body;
    });
  }

  // update current object
  Future<Map<String, dynamic>> update(Map<String, dynamic> entries) async {
    print(entries);
    if (entries.isEmpty) return;

    final response = this.client.put(
        "${client.baseURL}${path}/${objectId}",
        body: json.encode(entries));

    return response.then((value) {
      objectData = json.decode(value.body);
      return objectData;
    });
  }
}

