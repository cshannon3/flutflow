
import 'package:flutflow/utils.dart';
import 'package:flutter/material.dart';

class WidgetManager{
  var map={};
  Function updateVal;

  WidgetManager({this.map, this.updateVal});

 Widget toRow(var items,{var additional}){
   return Row(children: toWidgets(items, additonalWidgets: additional),);
 }
  Widget or(var test, var first, var second){
  var isTrue= map[test]["value"];
  var chosen = isTrue?first:second;
 
  if(chosen is Widget)return chosen;
  return toWidget(chosen);
  
  //return isTrue? toWidget(first):toWidget(second);
 }
  Widget only(var test, var first){
  var isTrue= map[test]["value"];
  return isTrue? (first is Widget)?first:toWidget(first):Container();
 }
  Widget onlyNot(var test, var first){
  var isTrue= map[test]["value"];
  return !isTrue? (first is Widget)?first:toWidget(first):Container();
 }

 Widget toDropdown(var name, {var extra}){
    var info = map[name];
   return DropdownButton<String>(
          value: info["value"],
          items: info["items"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,child: Text(value),
            );
          }).toList(),
          onChanged: (String newVal)=> updateVal(name, newVal),
        );
 }
 Widget toRaisedButton(var name, {var extra})=>toButton(name, extra:extra, type:"raisedButton");
 Widget toFlatButton(var name, {var extra})=>toButton(name, extra:extra, type:"flatButton");

 Widget toButton(var name, {var extra, var type="raisedButton"}){
       var info = map[name];
   if(extra is Map)info={}..addAll(info)..addAll(extra);
      var curVal= ifIs(info, "value")??true;
         var color;
   try{var c = ifIs(info, "color");if(c!=null){color=colorFromString(c);}}catch(e){print("e");}
   var text= ifIs(info, "text")??(curVal?(ifIs(info, "trueText")??""):ifIs(info, "falseText"));
    Widget btn;
    if(type=="flatButton"){
       btn= FlatButton(
          color: color,
          child: Text(text),
          onPressed: () {

            if(info.containsKey("setLocation"))
              updateVal(info["setLocation"], curVal);
              else updateVal(name, !curVal);
          }
        );
    }
    else if(type=="iconButton"){
      var icon= ifIs(info, "icon")??Icons.add;
      btn= IconButton(
          color: color,
          icon: Icon(icon),
          onPressed: //() {
            ifIsOne(info, ["onPressed", "onPress"])
            // if(info.containsKey("setLocation"))
            //   updateVal(info["setLocation"], curVal);
            //   else updateVal(name, !curVal);
         // }
        );
    }else{
      btn= RaisedButton(
     color: color,
     child: Text(text),
     onPressed: () {
       info.containsKey("setLocation")?updateVal(info["setLocation"], curVal):updateVal(name, !curVal);
    }
   );
    }

    var exp= ifIs(info, "expanded")??false;
    var cen= ifIs(info, "center")??false;
    return exp?Expanded(child: btn,):cen?Center(child: btn,):btn;
 }

  List<Widget> toUpDown(var name, {var extra}){
     var info = map[name];
    var incr = ifIs(info, "incr")??1.0;
    var min = (ifIs(info, "min")??0.0)+incr;
    var max = (ifIs(info, "max")??1000000.0)-incr;
    var val = ifIs(info, "value")??0.0;
   return [
                IconButton(onPressed: (){if(val>=min) updateVal(name,val-incr);},icon: Icon(Icons.arrow_downward),),           
                          Text(val.toStringAsPrecision(2)),
                          IconButton(onPressed: (){if(val<=max) updateVal(name,val+incr);},icon: Icon(Icons.arrow_upward),)
   ];
 }


 List<Widget> toWidgets(var items, {Map additonalWidgets}){
   var addit = additonalWidgets??{};
   List<Widget> out = [];
   if(items is List)
        items.forEach((item){
          if(addit.containsKey(out.length.toString()))
            out=tryAdd(out, addit[out.length.toString()]);
          
          if(map.containsKey(item)) 
            out = tryAdd(out,toWidget(item));
            
        });
    else if(items is Map)
      items.forEach((item, extra){
            if(addit.containsKey(out.length.toString()))
              out=tryAdd(out, addit[out.length.toString()]);
            
            if(map.containsKey(item)) 
              out = tryAdd(out,toWidget(item, extra: extra));
              
          });

   return out;
 }
 dynamic toWidget(var name, {var extra}){
   if (map[name].containsKey("type")){
     var type = map[name]["type"];
     if( type == "dropdown")return toDropdown(name, extra:extra);
     if (type =="updownarrows")return toUpDown(name, extra:extra); // rename, info
     if (type =="flatButton")return toFlatButton(name, extra:extra); //, info
     if (type =="raisedButton")return toRaisedButton(name, extra:extra); 
   }
 }

}

List<Widget> randomBlockList() {
   // List<Widget> out = (widget.child is Widget) ? [widget.child] : [];
   List<Widget> out =[];
    for (int y = 0; y < 10; y++) {
      out.add(
        RandomColorBlock(
            height: 50.0,
            child: Container(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
              ),
            )),
      );
    }
    
    return out;
  }
