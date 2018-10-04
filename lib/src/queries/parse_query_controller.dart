import 'package:parse_server/src/parse_http_client.dart';
import 'package:parse_server/src/queries/parse_query.dart';
import 'package:parse_server/src/queries/parse_query_state.dart';
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
    this.path = "/parse/classes/${className}";
  }

 // QueryController(String this.className, [ParseHTTPClient this.client]) {
 //   this.path = "/parse/classes/${className}";
 // }
  
  Future<dynamic> execute() async {
    /** WORKAROUND **/
    // only where!!
    var url = Uri.parse(client.baseURL + path);
        //?" + Uri.encodeFull(query.queryString));
    //var url += Uri.encodeFull(query.queryString);

    final response = this.client.get(url);
    return response.then((value) {
      var objectData = json.decode(value.body);
      if (objectData.containsKey("results")) {
        return objectData["results"];
      }
    });
    
/*    if (query.state != null) {
      final constraintJson = json.encode(query.state);
      final where = Uri.encodeFull(constraintJson);
      var q = 'where=' + where;

      final response = this.client.get(q);
      return response.then((value) {
        print(value.body);
        var objectData = json.decode(value.body);
        if (objectData.containsKey("results")) {
          return objectData["results"];
        }
      });
    }*/
    return null;
  }
}