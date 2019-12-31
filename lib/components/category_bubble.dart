
import 'dart:math';

import 'package:flutflow/components/item_node.dart';
import 'package:flutflow/data/bubble_data.dart';
import 'package:flutflow/scale_controller.dart';
import 'package:flutter/material.dart';
import 'package:no_brainer/utils/mathish.dart';





class CategoryBubble{
  final String name;
  final int id;
  Color color;
  Rect bubbleLoc;
  List<ItemNode> nodes;
  
  Point centerAbout;
  double diameter;
  CategoryBubble({this.name, this.id, this.centerAbout, this.diameter, this.color});

  init(ScaleController sc){
    nodes = bubs.where((b)=>(b.categories!=null && b.categories[0]==name)).toList();
    int len = nodes.length;
    if(len>8)len=8;
    bubbleLoc = sc.getBubbleLoc(centerAbout, diameter);
    List<Rect> nodeLocs = sc.getNodeLocations(bubbleLoc, len);
    for(int y=0;y<nodeLocs.length;y++){
      nodes[y].nodeLoc=nodeLocs[y];
    }
   
  }

  Widget toWidget(){
    return Positioned.fromRect(
      rect: bubbleLoc,
      child: Container(decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        border: Border.all(color: color),
        shape: BoxShape.circle
      ),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: Text(name, style: TextStyle(color: Colors.white, fontSize: 12.0),),// TODO fonsize of label
        )),)
      );
     // return self;
  }

  List<Widget> toWidgets({AnimationController anim, Function(ItemNode) onTap}){
    List<Widget> out=[];
    nodes.forEach((b){
      if(b.nodeLoc!=null)out.add(b.toWidget(()=>onTap(b)));//s, 
    });
    return out;

  }

}


    //{Size s}
    //if(screenSize==s && self!=null)return self;
   // double scaledDiameter = diameter*(s.width+s.height)/2;
      // left: centerAbout.x*s.width-scaledDiameter/2,
      // width: scaledDiameter,
      // top:centerAbout.y*s.height-scaledDiameter/2,
      // height: scaledDiameter,

//Widget self;
 // int i=0;
    // double ilen = 400/len;
    
    //  nodes.forEach((b){
    //    i++;
    //    sc
    //   // b.pt = 
    //    Point(centerAbout.x+Z(ilen*i)*diameter/3, centerAbout.y+K(ilen*i)*diameter/3);
    //    print("");
    //    print(b.name);
    //    print(b.pt);
       
    //    b.diameterS=diameter/3;
    //   });
// class CategoryBubble{
//   final String name;
//   final int id;
//   Color color;
//   Size screenSize;
//   List<ItemNode> nodes;
//   //Widget self;
//   Point centerAbout;
//   double diameter;
//   CategoryBubble({this.name, this.id, this.centerAbout, this.diameter, this.color});

//   init(){
//     nodes = bubs.where((b)=>(b.categories!=null && b.categories[0]==name)).toList();
//     // want to give the children their point within the subject bubble
//     // To do this I need to know the subject center, # of nodes, and subject diameter
//     // want a circular ring nodes for now, do do this need to maximize space between each point
//     //
//     int i=0;
//     int len = nodes.length;
//     double ilen = 400/len;
//      nodes.forEach((b){
//        i++;
//        b.pt = Point(centerAbout.x+Z(ilen*i)*diameter/3, centerAbout.y+K(ilen*i)*diameter/3);
//        print("");
//        print(b.name);
//        print(b.pt);
       
//        b.diameterS=diameter/3;
//       });
//   }

//   Widget toWidget({Size s}){
//     //if(screenSize==s && self!=null)return self;
//     double scaledDiameter = diameter*(s.width+s.height)/2;
//     return Positioned(
//       left: centerAbout.x*s.width-scaledDiameter/2,
//       width: scaledDiameter,
//       top:centerAbout.y*s.height-scaledDiameter/2,
//       height: scaledDiameter,
//       child: Container(decoration: BoxDecoration(
//         color: color.withOpacity(0.5),
//         border: Border.all(color: color),
//         shape: BoxShape.circle
//       ),
//       child: Align(
//         alignment: Alignment.topCenter,
//         child: Padding(
//           padding: const EdgeInsets.only(top:20.0),
//           child: Text(name, style: TextStyle(color: Colors.white, fontSize: 30*(s.width+s.height)/(1500.0+800.0)),),
//         )),)
//       );
//      // return self;
//   }

//   List<Widget> toWidgets({Size s, AnimationController anim, Function(ItemNode) onTap})=>
//     nodes.map((b){
//       return b.toWidget(s, ()=>onTap(b));
//     }).toList();

// }
