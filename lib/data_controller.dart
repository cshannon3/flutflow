import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:no_brainer/makers/model_maker.dart';

class DataController  {
  DataController();
    Future<List<CustomModel>> getDataList(String modelName, String source) async{
      List<CustomModel> em = [];
      String data = await rootBundle.loadString(source);
      final jsonData = json.decode(data);
   //  print(jsonData.length);
      jsonData.forEach((item){
        
        CustomModel cm = CustomModel.fromLib({
         "name": modelName,
         "vars":item
          });
        em.add(cm);
      });
      return em;
    }
}
