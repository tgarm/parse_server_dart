import 'package:flutter/material.dart';
import 'package:parse_server/parse_server.dart';
import 'const.dart';

void main() => runApp(new MyApp());

void conn_parse() async{
  Parse parse = new Parse(new Credentials(Const.PARSE_APPID), Const.PARSE_SERVER_URL);
  var article = parse.object("Article");
  article.set('name','Canon');
  article.set('content','iiii ooo');
  print("to save article:$article");
  await article.saveNew();
  print("saved article: $article");
  print("objectID: ${article.objectId}");
}

class MyApp extends StatelessWidget{
  @override Widget build(BuildContext context){
    print("try connect to parse server");
    conn_parse();
    return new MaterialApp(
      title:'Parse Demo',
      home: new Scaffold(appBar: new AppBar(title:new Text('Parse Demo App')),body:new Center(child:new Text('Hello')))
    );
  }
}
