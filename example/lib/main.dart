import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:parse_server/parse_server.dart';
import 'const.dart';

void main() => runApp(new MyApp());

Parse parse = new Parse(new Credentials(Const.PARSE_APPID), Const.PARSE_SERVER_URL);

class MyApp extends StatelessWidget{
  @override Widget build(BuildContext context){
    return new MaterialApp(
      title:'Parse Demo',
      home: new ParseList()
    );
  }
}

class ParseList extends StatefulWidget {
  @override createState(){
    print("loading");
    var state = ParseListState();
    state.loadObjects();
    return state;
  }
}

class ParseListState extends State<ParseList>{
  List objList = [];

  void addObject() {
      var article = parse.object("Article");
      article.set('name','Canon');
      article.set('keyword','canon,pachabel,piano');  
      article.set('desc','Pachabel D version of Canon');
      article.set('content','iiii ooo');
      article.save();
  }

  Future<List> getObjects() async{
    var q = parse.query("Article");
    return  q.findObjects();
  }

  loadObjects(){
    getObjects().then((list){
      print("reload");
      setState((){
        objList = list;
      });
    });
  }

  @override Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title:new Text('Parse Demo App'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.add),
            tooltip: 'Add Object',
            onPressed:()=>addObject()
          ),
          new IconButton(
            icon: new Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: ()=>loadObjects(),
          )
        ]
      ),
      body:new Center(child:ListView.builder(
        padding: new EdgeInsets.all(8.0),
        itemExtent: 40.0,
        itemBuilder: (BuildContext context, int index){
          var val = objList[index]['name'];
          var id = index+1;
          return new Text("$id:$val");
        },
        itemCount: objList.length
      ))
    );
  }
}