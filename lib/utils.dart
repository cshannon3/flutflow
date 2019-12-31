// Random color from https://github.com/matthew-carroll/fluttery/blob/master/lib/framing.dart
/// Tools for framing out user interfaces quickly.
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
 List<String> incrList = ["","100", "200","300", "400","500","600", "700", "800", "900"];
class RandomColor {
  static final Random _random = new Random();

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }
}

// from https://github.com/matthew-carroll/fluttery/blob/master/lib/framing.dart

/// Widget that takes up a given [width] and [height] and paints itself with a
/// random color.
///
/// The random color survives through hot reload because [RandomColorBlock] is
/// a [StatefulWidget].  However, the color will be randomized again after a
/// full reload or a full rebuild.
class RandomColorBlock extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final double opacity;

  RandomColorBlock({this.width, this.height, this.child, this.opacity=1.0});

  @override
  _RandomColorBlockState createState() => new _RandomColorBlockState();
}

class _RandomColorBlockState extends State<RandomColorBlock> {
  Color randomColor;

  @override
  void initState() {
    super.initState();
    randomColor = RandomColor.next().withOpacity(widget.opacity);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: widget.width,
      height: widget.height,
      color: randomColor,
      child: widget.child,
      
    );
  }
}
List<Widget> tryAdd(List<Widget> items, var wid){
  if (wid is List<Widget>) items.addAll(wid);
  else if  (wid is Widget) items.add(wid);
  return items;

}
dynamic ifIsOne(var tokens, var names) {
  if (tokens==null || names==null || !(names is List))return null;
  var out;
  int index = 0;
  while (out==null && index<names.length){out=ifIs(tokens, names[index]);index+=1;}
   return out;

}
dynamic checkPath(var map, List path){
  int i = 0;
  if(map is Map){
    while (map.containsKey(path[i])){
      map = map[path[i]];
      i++;
      if(i==path.length)return [true, map];
    }
    return [false, null];
  }else return [false, null];
}
List trimList(var list, {skipEmpty=true}){
  List out = [];
  list.forEach((l){
    if(l.trim()!="" || !skipEmpty)out.add(l.trim());
    });
  return out;
}
dynamic ifIs(var tokens, var name) => 
    (tokens!=null && name!=null && tokens.containsKey(name)) ? tokens[name] : null;

String capWord(String word) {
  if (!word.contains("_")) return word[0].toUpperCase() + word.substring(1);
  String out = "";
  word.split("_").forEach((w) => out += capWord(w));
  return out;
}

bool hasChildren(String key){
   var widgetInfo = key.contains("_") ? key.split("_") : [key];
   return (["stack", "column", "row", "listview"].contains(widgetInfo[0]));
 }
String token = "_";
List<String> tokenList= ["~"];
Map<String, dynamic> parseMap = {
  "height": (var tokens) => tryParse(tokens, ["height", "h"]),
  "width": (var tokens) => tryParse(tokens, ["width", "w"]),
  "left": (var tokens) => tryParse(tokens, ["left", "l"]),
  "right": (var tokens) => tryParse(tokens, ["right", "r"]),
  "top": (var tokens) => tryParse(tokens, ["top", "t"]),
  "ratio": (var tokens) => tryParse(tokens, ["ratio", "ra"]),
  "vertical": (var tokens) =>
      tryParse(tokens, ["vertical", "vert", "v"]),
  "horizontal": (var tokens) =>
      tryParse(tokens, ["horizontal", "hor"]),
  "all": (var tokens) => tryParse(tokens, ["all"]),
  "bottom": (var tokens) => tryParse(tokens, ["bottom", "b"]),
  "flex": (var tokens) => tryParse(tokens, ["flex", "f"], type: "int"),
  "color": (var tokens) =>
      tryParse(tokens, ["color", "c"], type: "color"),
  "alignment": (var tokens) =>
      tryParse(tokens, ["alignment", "align", "al"], type: "alignment"),
    "x": (var tokens) => tryParse(tokens, ["x", "dx"]),
  "y": (var tokens) => tryParse(tokens, ["y", "dy"]),
   "length": (var tokens) => tryParse(tokens, ["length", "len"]),
};



EdgeInsets getPadding(var tokens) {
  var all = parseMap["all"](tokens);
  if (all != null) return EdgeInsets.all(all);
  var hor = parseMap["horizontal"](tokens);
  var vert = parseMap["vertical"](tokens);
  if (hor != null || vert != null)
    return EdgeInsets.symmetric(vertical: vert ?? 0.0, horizontal: hor ?? 0.0);
  return EdgeInsets.only(
      top: parseMap["top"](tokens) ?? 0.0,
      bottom: parseMap["bottom"](tokens) ?? 0.0,
      left: parseMap["left"](tokens) ?? 0.0,
      right: parseMap["right"](tokens) ?? 0.0);
}



dynamic tryParse(var tokens, List<String> names,
    {String type = "double", bool parseType=true}) {
  var out;
  int i = 0;
  tokens = trySplit(tokens, type);
  if(tokens is List){
    while (out == null && i < names.length) {
    if (tokens.contains(names[i]))
      out = parseToken(tokens, label:names[i],dictName: names[0], type: type);
    i++;
  }
  }
  else{
    while (out == null && i < names.length) {
      if (tokens.containsKey(names[i])){
        out = parseType?parseToken(tokens[names[i]],dictName: names[0], type: type):tokens[names[i]];
      }
      i++;
    }
  }
  return out;
}

parseToken(var tokens, {var label,var dictName, var type = "double"}) {
  var tok = tokens;
  if(tokens is List){
    tok = tokens[tokens.indexOf(label) + 1];
  }
  if(tok is String){
  switch (type) {
    case "double":
      if(tok=="max")return double.maxFinite;
      return double.tryParse(tok);
      break;
    case "int":
      return int.tryParse(tok);
      break;
    case "color":
      return colorFromString(tok);
      break;
    case "string":
      return tok;
      break;
    case "alignment":
      return defaultEnum["alignment"].containsKey(tok)?defaultEnum["alignment"][tok]:null;
      break; 
    // case "class":
    //   var key = (dictName!=null)?dictName:(tok is List)?tok[0]:tok;
    //   if(tok is List)return defaultClass.containsKey(key)?defaultClass[key](tok.sublist(1)):null;
    //   return defaultClass.containsKey(key)?defaultClass[key]:null;
    // case "enum":
    //   var key = (dictName!=null)?dictName:(tok is List)?tok[0]:tok;
    //   if(tok is List)return defaultEnum.containsKey(key)?defaultEnum[key](tok.sublist(1)):null;
    //   return defaultEnum.containsKey(key)?defaultEnum[tok]:null;
    default:
      return tok;
      break;
  }
  }
  else return tok;
}

dynamic trySplit(var tokens, String type){
  if (!(tokens is List))return tokens;
  if(type!="class" || type!="enum")return tokens;
  var outTokens =[];
  tokens.forEach((t){
    int i=0;
    while (i<tokenList.length &&!t.contains(tokenList[i]))i++;
    if(i!=tokenList.length)outTokens.add(t.split(tokenList[i]));
    else outTokens.add(t);
  });
}

List<String> colorOptions=["", "black","white","pink","red","orange", "amber", "yellow","lime", "lightGreen","green","teal","cyan","lightBlue","blue","indigo","purple","grey","brown","blueGrey"];
//String to(String baseName) => capWord(baseName) + "Model";
Color colorFromString(String color, {double opacity}){
  if(color == null)return null;
  var incr;
  if(opacity==null)opacity=1.0;
  if (color.contains("[")){
    var c = color.split("[");
    color = c[0];
    incr = int.tryParse(c[1].substring(0, c[1].length-1));
  }  

  else if(color.length>3){
      incr = int.tryParse(color.substring(color.length-3));
      if(incr!=null)color=color.substring(0,color.length-3);
  }
    switch(color){
      case "":
        return Colors.transparent;
         case "transparent":
        return Colors.transparent;
      case "black":
        return Colors.black.withOpacity(opacity);
      case "red":
        return (incr!=null)?Colors.red[incr].withOpacity(opacity): Colors.red.withOpacity(opacity);
      case "grey":
        return (incr!=null)?Colors.grey[incr].withOpacity(opacity): Colors.grey.withOpacity(opacity);
      case "indigo":
        return (incr!=null)?Colors.indigo[incr].withOpacity(opacity): Colors.indigo.withOpacity(opacity);
      case "blue":
        return (incr!=null)?Colors.blue[incr].withOpacity(opacity): Colors.blue.withOpacity(opacity);
      case "green":
        return (incr!=null)?Colors.green[incr].withOpacity(opacity): Colors.green.withOpacity(opacity);
      case "purple":
        return (incr!=null)?Colors.purple[incr].withOpacity(opacity): Colors.purple.withOpacity(opacity);
      case "pink":
        return (incr!=null)?Colors.pink[incr].withOpacity(opacity): Colors.pink.withOpacity(opacity);
      case "amber":
        return (incr!=null)?Colors.amber[incr].withOpacity(opacity): Colors.amber.withOpacity(opacity);
        case "lime":
        return (incr!=null)?Colors.lime[incr].withOpacity(opacity): Colors.lime.withOpacity(opacity);
        case "brown":
        return (incr!=null)?Colors.brown[incr].withOpacity(opacity): Colors.brown.withOpacity(opacity);
        case "blueGrey":
        return (incr!=null)?Colors.blueGrey[incr].withOpacity(opacity): Colors.blueGrey.withOpacity(opacity);
        case "indigo":
        return (incr!=null)?Colors.indigo[incr].withOpacity(opacity): Colors.indigo.withOpacity(opacity);
        case "cyan":
        return (incr!=null)?Colors.cyan[incr].withOpacity(opacity): Colors.cyan.withOpacity(opacity);
        case "teal":
        return (incr!=null)?Colors.teal[incr].withOpacity(opacity): Colors.teal.withOpacity(opacity);
        case "lightBlue":
        return (incr!=null)?Colors.lightBlue[incr].withOpacity(opacity): Colors.lightBlue.withOpacity(opacity);
      case "lightGreen":
        return (incr!=null)?Colors.lightGreen[incr].withOpacity(opacity): Colors.lightGreen.withOpacity(opacity);
      case "white":
        return Colors.white.withOpacity(opacity);
      case "orange":
        return (incr!=null)?Colors.orange[incr].withOpacity(opacity): Colors.orange.withOpacity(opacity);
      case "yellow":
        return (incr!=null)?Colors.yellow[incr].withOpacity(opacity): Colors.yellow.withOpacity(opacity);
      case "random":
        return RandomColor.next().withOpacity(opacity);
      default:
        return Colors.black;
    }
  }    


Map<String, dynamic> defaultClass = {

  "paint": (var tokens)=>Paint()
      ..strokeJoin = tryParse(tokens, ["strokeJoin", "sj"], type: "enum")??StrokeJoin.round
      ..strokeWidth = tryParse(tokens, ["strokeWidth", "sw"], type: "enum")??StrokeCap.round
      ..color = parseMap["color"](tokens)??Colors.green
      ..style = tryParse(tokens, ["paintStyle", "sc"], type: "enum")??PaintingStyle.stroke
};



Map<String, dynamic> defaultEnum = {

  "strokeJoin":{
    "round":StrokeJoin.round,
    "r": StrokeJoin.round,
    "bevel":StrokeJoin.bevel,
    "b":StrokeJoin.bevel
  } ,
  "strokeCap":{
    "b":StrokeCap.butt,
    "butt":StrokeCap.butt,
    "r":StrokeCap.round,
    "round":StrokeCap.round,
    "s":StrokeCap.square,
    "square":StrokeCap.square,
  },
  "paintStyle":{
    "f":PaintingStyle.fill,
    "fill":PaintingStyle.fill,
    "stroke":PaintingStyle.stroke,
    "s":PaintingStyle.stroke
  },
  "alignment":{
    "center": Alignment.center,
    "topLeft": Alignment.topLeft,
    "topRight": Alignment.topRight,
    "bottomLeft": Alignment.bottomLeft,
    "bottomRight": Alignment.bottomRight,
    "topCenter": Alignment.topCenter,
    "bottomCenter": Alignment.bottomCenter,
    "centerRight": Alignment.centerRight,
    "centerLeft": Alignment.centerLeft
  }
};


