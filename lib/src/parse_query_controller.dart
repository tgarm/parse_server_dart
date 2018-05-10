import 'parse_http_client.dart';

class QueryController {
  ParseHTTPClient client;

  QueryController() {}

//  Future<List<dynamic>> execute(QueryState queryState) async {
//    String q = client.baseURL + "${path}";
//    if (queryState.constraints != null) {
//      final constraintJson = json.encode(queryState.constraints);
//      final where = Uri.encodeFull(constraintJson);
//      q += where;
//    }
//    final response = this.client.get(q);
//    return response.then((value){
//      objectData = json.decode(value.body);
//      if (objectData.containsKey("results")) {
//        return objectData["results"];
//      }
//    });
//  }
}