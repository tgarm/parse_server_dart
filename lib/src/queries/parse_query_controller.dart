import 'package:parse_server_dart/src/parse_http_client.dart';
import 'package:parse_server_dart/src/queries/parse_query.dart';
import 'dart:convert';
import 'dart:async';

class QueryController {
  String className;
  
  
  ParseHTTPClient _client;
  String path;
  final Query query;

  get client => _client;
  
  set client(ParseHTTPClient client) {
    _client = client;
  }

  QueryController(this.query){
    this.className = query.className;
    this.client = query.client;
    this.path = "/classes/${className}";
  }

  
  Future<dynamic> execute() async {
    /** WORKAROUND **/
    // only where!!
    var url = Uri.parse(client.baseURL + path);

    final response = this.client.get(url);
    return response.then((value) {
      var objectData = json.decode(value.body);
      if (objectData.containsKey("results")) {
        return objectData["results"];
      }
    });
  }
}