import 'package:flutflow/utils.dart';
import 'package:flutter/material.dart';

const BOX_COLOR = Colors.cyan;
const BOX_COLOR2 = Colors.yellow;
enum DRAGSIDE { LEFT, RIGHT, DOWN, UP, NONE, CENTER }
enum CHILDTYPE { BOX,IMAGE,TEXT,BUTTON}

var map={
     "color":{ "type":"dropdown",  "value":"",  "items": colorOptions },
      "shade":{ "type":"dropdown","value":"", "items": incrList },
      "opacity":{ "type": "updownarrows", "incr":0.1, "max":1.0, "min":0.0, "value":1.0 },
      "borderColor":{ "type":"dropdown", "value":"", "items": colorOptions, },
      "borderThickness":{  "type": "updownarrows", "incr":1.0,   "min":0.0, "value":2.0  },
      "borderRadius":{"type": "updownarrows","incr":1.0,   "min":0.0, "value":2.0 },
      "decorate":{ "type":"raisedButton","text":"decorate","value":false },
      "hasChildren":{"value":false},
      "singleChild":{"type":"flatButton", "text":"single Child", "expanded":true,"setLocation":"hasChildren", "value":false,},//"color":(){ var b = map["hasChildren"]["value"]; if(b)print("true");return b?"red":"blue";}},
      "children":{ "type":"flatButton","text":"children","expanded":true, "setLocation":"hasChildren", "value":true},// "color":(){return (map["hasChildren"]["value"])?"blue":""; }},
      "centered":{ "type":"raisedButton","trueText":"center", "falseText":"uncenter","value":true},
      "childType":{"value":CHILDTYPE.BOX},
      "box":{"type":"flatButton", "text":"Box", "expanded":true,"setLocation":"childType", "value":CHILDTYPE.BOX,},
      "image":{"type":"flatButton", "text":"Image", "expanded":true,"setLocation":"childType", "value":CHILDTYPE.IMAGE,},
      "text":{"type":"flatButton", "text":"Text", "expanded":true,"setLocation":"childType", "value":CHILDTYPE.TEXT,},
      "button":{"type":"flatButton", "text":"Button", "expanded":true,"setLocation":"childType", "value":CHILDTYPE.BUTTON,},
      "textcolor":{ "type":"dropdown",  "value":"",  "items": colorOptions },
      "photoFromUrl":{ "type":"dropdown",  "value":"",  "items": imges },
      "hasImage":{ "type":"raisedButton","trueText":"remove Image", "falseText":"remove Image","value":false},
      "hasPadding":{ "type":"raisedButton","trueText":"Remove Padding", "falseText":"Add Padding","value":false, "centered":true},
      "optionsOpen":{ "type":"raisedButton","text":"close","value":true },
      "bold":{ "type":"iconButton","icon":Icons.format_bold,"value":false },
      "italic":{ "type":"iconButton","icon":Icons.format_italic,"value":false },
      "nextLine":{ "type":"iconButton","icon":Icons.arrow_downward,"value":false },
      };


var imges = [
"https://i.imgur.com/XWcBSjn.jpg",
"https://i.imgur.com/TH5XFUL.jpg",
"https://i.imgur.com/4Bskj1L.jpg",
"https://i.imgur.com/MXOCgBK.jpg",
"https://i.imgur.com/m4aCN9y.jpg",
"https://i.imgur.com/Rwh5gIW.jpg",
"https://i.imgur.com/Tp2wOZ9.jpg",
"https://i.imgur.com/DZvXzfc.jpg",
"https://i.imgur.com/XmcE4ZD.jpg",
"https://i.imgur.com/RD8x7Kc.jpg",
"https://i.imgur.com/y4Vi9ZN.jpg",
"https://i.imgur.com/6zjd5r3.jpg",
"https://i.imgur.com/83PU3BB.jpg",
"https://i.imgur.com/RweJxxr.jpg",
"https://i.imgur.com/Kt2rwA1.jpg",
"https://i.imgur.com/btUdggO.jpg",
"https://i.imgur.com/RHpacJu.jpg",
"https://i.imgur.com/CyvLw0l.jpg",
"https://i.imgur.com/wfhjhJQ.jpg",
"https://i.imgur.com/ISXo3vZ.jpg",
"https://i.imgur.com/XDzrQav.jpg",
"https://i.imgur.com/pLzZjOx.jpg",
"https://i.imgur.com/1q3H75i.jpg",
"https://i.imgur.com/u8K0FgF.jpg",
"https://i.imgur.com/2puGKY1.jpg",
"https://i.imgur.com/XzTgsGG.jpg",
"https://i.imgur.com/TeAlTPW.jpg",
"https://i.imgur.com/YfFfZx5.jpg",
"https://i.imgur.com/LDq31F3.jpg",
"https://i.imgur.com/JBK9N7Y.jpg",
"https://i.imgur.com/w62nNmA.jpg",
"https://i.imgur.com/cY5ziCU.jpg",
"https://i.imgur.com/MrsCOrT.jpg",
"https://i.imgur.com/MrdvMLT.jpg",
"https://i.imgur.com/yVKWMdg.jpg",
"https://i.imgur.com/OfuDNk0.jpg",
"https://i.imgur.com/Hz4LpwD.jpg",
"https://i.imgur.com/5cNd4jF.jpg",
"https://i.imgur.com/nStuxwY.jpg",
"https://i.imgur.com/km2mbDj.jpg"
];