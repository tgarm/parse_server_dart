import 'package:flutter/material.dart';
import 'dart:math';
import 'package:parse_server_dart/parse_server_dart.dart';
import 'const.dart';

void main() => runApp(new MyApp());

var rndSeed = new Random();

String randomWord(){
  const wordList = ['now','is','come','time','for','all','good','this','Jack','not'];
  return wordList[rndSeed.nextInt(wordList.length-1)];
}

String randomString(int wordCount){
  var res = [];
  for(int i=0;i<wordCount;i++){
    res.add(randomWord());
  }
  var r = res.join(' ');
  var num = rndSeed.nextInt(100);
  return "$r $num";
}

void addObject() {
    var article = parse.object("Article");
    article.set('name',randomString(2));
    article.set('keyword',randomString(3));  
    article.set('desc',randomString(5));
    article.set('content',randomString(10));
    article.set('author',parse.user());
    article.save();
}


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

  Future<List> getObjects() async{
    var q = parse.query("Article");
    return  q.findObjects();
  }

  loadObjects(){
    getObjects().then((list){
      setState((){
        objList = list;
      });
    });
  }

  signUp(){
    var name = randomWord();
    var password = 'nopass';
    parse.user().signUp({
      'username':name,
      'password':password
    }).then((res){
      print("signup done as: $name");
      print("res: $res");
    });
  }

  login(){
    parse.user().queryAll().then((users){
      for (var user in users) {
        var name = user['username'];
        print("user: $name");
      }
      parse.user().set('username',users[0]['username']);
      parse.user().set('password','nopass');
      parse.user().login().then((res){
        print("login as first user: $res");
      });
    });
  }


  @override Widget build(BuildContext context){
    login();
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
          ),
          new IconButton(
            icon: new Icon(Icons.verified_user),
            tooltip: 'Sign-up new User',
            onPressed: ()=>signUp()
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