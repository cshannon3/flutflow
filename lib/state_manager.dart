
import 'package:firebase/firestore.dart';
import 'package:flutflow/audio/audio_example.dart';
import 'package:flutflow/data_controller.dart';
import 'package:flutflow/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:no_brainer/makers/model_maker.dart';
import 'package:no_brainer/screens/paint_demo.dart';

class StateManager extends ChangeNotifier {
  DataController dataController = DataController();
  StateManager();
  List<CustomModel> bookList = List();
  List<CustomModel> quotesList = List();
  String currentRoute = "/";
  Map<String, dynamic> routes = {
    "/": (StateManager m) => AnimTest(m),
    "/fourier": (StateManager m) => Fourier2(),
    "/guiboxes": (StateManager m) => MyMainApp(),
    "/paint": (StateManager m) => PaintDemo(),
    "/music": (StateManager m) => PianoScreen(),
    "/quotes": (StateManager m) => Quotes(m),
    "/books":(StateManager m) => Books(m),
    "/essays": (StateManager m) => Essays(),
    "/sites":(StateManager m) =>  Sites(),
    //"/people":(StateManager m) => Container()
  };
  Widget getScreen() {
    return routes[currentRoute](this);
  }

  changeScreen(String route) {
    if (routes.containsKey(route)) {
      currentRoute = route;
      notifyListeners();
    }
  }
  Map<String, dynamic> dataMap={
    "books":{"name":"book", "collection_name": "books", "models":[],},
    "quotes":{"name":"quote", "collection_name": "quotes", "models":[],},
    //"blogs":{"name":"blog", "collection_name": "blogs", "models":[],}
  };

  initialize(/*Firestore _db,*/) async {
    bookList = await dataController.getDataList("book", "assets/book.json");
    quotesList = await dataController.getDataList("quote", "assets/quotes.json");
    //db=_db;
    // dataMap.forEach((key,infoMap){
    //   print("\n\n$key\n\n");
    //   _db.collection(infoMap["collection_name"]).onSnapshotMetadata.listen((onData){
    //   var l =[];
    //   onData.docs.forEach((dataItem){
    //     try{
    //       l.add(CustomModel.fromLib({"name":infoMap["name"], "vars":dataItem.data()}));
    //     }
    //     catch(e){
    //       print("err"); } });
    //   infoMap["models"]=l;
    // });
    // });
    // (dataMap["quotes"]["models"] as List).shuffle();
    // quotesList=dataMap["quotes"]["models"];
    // bookList=dataMap["books"]["models"];
   //print(quotesList.last.vars["author"]);
  }
}
