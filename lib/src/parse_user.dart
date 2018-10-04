import 'dart:convert';
import 'dart:async';
import 'package:parse_server/src/parse_base.dart';
import 'package:parse_server/src/parse_http_client.dart';
import 'package:parse_server/src/queries/parse_query.dart';
import 'package:parse_server/src/credentials.dart';

class User implements ParseBaseObject {
  final String className = '_User';
  final ParseHTTPClient client;
  String password;
  String path;
  Map<String, dynamic> objectData = {};

  String get objectId => objectData['objectId'];

  String get sessionId => objectData['sessionToken'];

  String get username => objectData['username'];

  String get userId => objectData['objectId'];

  User([ParseHTTPClient client])
      : path = "/parse/classes/_User",
        client = client;

  void set(String attribute, dynamic value) {
    objectData[attribute] = value;
  }

  Future<dynamic> get(attribute) async {
    final response = this.client.get(client.baseURL + "/parse/users/${objectId}",
        headers: {"X-Parse-Session-Token": sessionId} );
    return response.then((value) {
      objectData = json.decode(value.body);
      return objectData[attribute];
    });
  }

  Future<dynamic> me() async {
    final response = this.client.get(client.baseURL + "/parse/users/me",
        headers: {"X-Parse-Session-Token": sessionId});
    return response.then((value) {
      _handleResponse(value.body);
      return objectData;
    });
  }

  Map<String, dynamic> _handleResponse(String response) {
    Map<String, dynamic> responseData = json.decode(response);

    if (responseData.containsKey('objectId')) {
      objectData = responseData;
      this.client.credentials.sessionId = sessionId;
    }
    return responseData;
  }

  void _resetObjectId() {
    if (objectId != null) objectData.remove('objectId');
    if (sessionId != null) objectData.remove('sessionToken');
  }

  Future<Map<String, dynamic>> signUp(
      [Map<String, dynamic> objectInitialData]) async {
    if (objectInitialData != null) {
      objectData = {}..addAll(objectData)..addAll(objectInitialData);
    }
    _resetObjectId();

    Uri url = Uri.parse("${client.baseURL}/parse/users");

    final response = this.client.post(
        url,
        headers: {
          'X-Parse-Revocable-Session': "1",
        },
        body: json.encode(objectData));

    return response.then((value) {
      var responseData = _handleResponse(value.body);
      // for error handling
      if(responseData.containsKey('error')){
        return responseData;
      }
      return objectData;
    });
  }

  Future<Map<String, dynamic>> login() async {
    Uri url = Uri.parse("${client.baseURL}/parse/login?" +
        "username=" + objectData['username'] +
        "&password=" + objectData['password']
    );

    final response = this.client.get(
      url,
      headers: {
        'X-Parse-Revocable-Session': "1",
      },
    );

    return response.then((value) {
      _handleResponse(value.body);
      return objectData;
    });
  }

  Future<List<dynamic>> fetchUsers(String username) async {
    var query = new Query(className, client);
    query.whereEqualTo("username", username);

    return null;
  }

  Future<Map<String, dynamic>> verificationEmailRequest() async {
    final response = this.client.post(
        "${client.baseURL}/parse/verificationEmailRequest",
        body: json.encode({"email": objectData['email']}));
    return response.then((value) {
      return _handleResponse(value.body);
    });
  }

  Future<Map<String, dynamic>> requestPasswordReset() async {
    final response = this.client.post(
        "${client.baseURL}/parse/requestPasswordReset",
        body: json.encode({"email": objectData['email']}));

    return response.then((value) {
      return _handleResponse(value.body);
    });
  }

  Future<Map<String, dynamic>> save([Map<String, dynamic> objectInitialData]) {
    objectData = {}..addAll(objectData)..addAll(objectInitialData);
    if (objectId == null) {
      return signUp(objectData);
    } else {
      final response = this.client.put(client.baseURL + "/parse/users/${objectId}",
          body: json.encode(objectData));
      return response.then((value) {
        return _handleResponse(value.body);
      });
    }
  }

  Future<String> destroy() {
    final response = this.client.delete(client.baseURL + "${path}/${objectId}",
        headers: {"X-Parse-Session-Token": sessionId});
    return response.then((value) {
      _handleResponse(value.body);
      return objectId;
    });
  }

  Future<Map<String, dynamic>> all() {
    final response = this.client.get(client.baseURL + "/parse/users");
    return response.then((value) {
      return _handleResponse(value.body);
    });
  }

  // update current user
  Future<Map<String, dynamic>> update(Map<String, dynamic> entries) async {
    print(entries);
    if (entries.isEmpty) return;

    final response = this.client.put(
        "${client.baseURL}/parse/users/" + objectId,
        headers: {"X-Parse-Session-Token": sessionId},
        body: json.encode(entries));

    return response.then((value) {
      return _handleResponse(value.body);
    });
  }
}
