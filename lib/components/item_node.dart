
//import 'dart:math';

import 'package:flutflow/data/bubble_data.dart';
import 'package:flutter/material.dart';
import 'package:no_brainer/utils/url.dart';

class ItemNode{
  final String name;
  final String url; 
  final String imgUrl;
  final int id;
  final String description;
  Color fontColor;
  Rect nodeLoc;

 // Point pt;
  NetworkImage image;
  List<String> categories=[];

  ItemNode({this.imgUrl, this.name, this.url, this.categories, this.fontColor=Colors.white,this.id,  this.description}){
    image=NetworkImage(imgUrl);
  }
  

  Widget toWidget( Function() onTap){//Size screenSize,
    
     return (nodeLoc==null)?null:
     Positioned.fromRect(
       rect: nodeLoc,
      child: bubble(radius: nodeLoc.width/2, onTap: onTap)
     );
  }

  

   Widget bubble({double minR, double maxR, double radius, Function() onTap}){
       return GestureDetector(
        onLongPress: ()=>launch(url),
        onTap:onTap,
        child: Container(
              decoration: _getDecoration(),
              padding: EdgeInsets.all(5.0),
              child: (maxR!=null && minR!=null)?
              CircleAvatar(
                backgroundImage:image,
                maxRadius: maxR/2,
                minRadius: minR/2,
              ):
              CircleAvatar(
                backgroundImage:image,
                radius: radius??double.maxFinite,
              )
              ,
            ),
    );
   }
  BoxDecoration _getDecoration(){

    if(categories.isEmpty) return BoxDecoration( shape: BoxShape.circle,);
    List<Color> colors = [];
    categories.forEach((c){
      if(catColors.containsKey(c))colors.add(catColors[c]);
    });
    if(colors.isEmpty) return BoxDecoration( shape: BoxShape.circle,);
    if (colors.length==1)
       return new BoxDecoration( shape: BoxShape.circle,color: colors[0] );
    else 
      return BoxDecoration(
        shape: BoxShape.circle,
        gradient:new LinearGradient(
        colors:colors,
      ),
      );
  }

}













// import 'dart:math';

// import 'package:flutflow/data/bubble_data.dart';
// import 'package:flutter/material.dart';
// import 'package:no_brainer/utils/url.dart';

// class ItemNode{
//   final String name;
//   final String url; 
//   final String imgUrl;
//   final int id;
//   final String description;
//  // int order;
//   Color fontColor;
//   double diameterS=0.1;

//   Point pt;
//   NetworkImage image;
//   List<String> categories=[];

//   ItemNode({this.imgUrl, this.name, this.url, this.categories, this.fontColor=Colors.white,this.id, this.pt, this.description}){
//     image=NetworkImage(imgUrl);
//   }
  

//   Widget toWidget(Size screenSize, Function() onTap){
//     //scaledDL=diameterL*screenSize.width;
//     double sc= (screenSize.width+screenSize.height)/2;
//     double scaledDS=diameterS*(screenSize.width+screenSize.height)/2;
//     // if(isActive)return toAnimated(screenSize,anim);
//     // if(isCenter) return toCenter(screenSize, anim);
//      return Positioned(
//       left: pt.x*screenSize.width,
//       width:scaledDS,
//       top: pt.y*screenSize.height,
//       height: scaledDS,
//       child:FractionalTranslation(
//             translation: Offset(-0.5, -0.5),
//             child: bubble(radius: scaledDS/2, onTap: onTap))
//      );
//   }

  

//    Widget bubble({double minR, double maxR, double radius, Function() onTap}){
//        return GestureDetector(
//         onLongPress: ()=>launch(url),
//         onTap:onTap,
//         child: Container(
//               decoration: _getDecoration(),
//               padding: EdgeInsets.all(5.0),
//               child: (maxR!=null && minR!=null)?
//               CircleAvatar(
//                 backgroundImage:image,
//                 maxRadius: maxR/2,
//                 minRadius: minR/2,
//               ):
//               CircleAvatar(
//                 backgroundImage:image,
//                 radius: radius??double.maxFinite,
//               )
//               ,
//             ),
//     );
//    }
//   BoxDecoration _getDecoration(){

//     if(categories.isEmpty) return BoxDecoration( shape: BoxShape.circle,);
//     List<Color> colors = [];
//     categories.forEach((c){
//       if(catColors.containsKey(c))colors.add(catColors[c]);
//     });
//     if(colors.isEmpty) return BoxDecoration( shape: BoxShape.circle,);
//     if (colors.length==1)
//        return new BoxDecoration( shape: BoxShape.circle,color: colors[0] );
//     else 
//       return BoxDecoration(
//         shape: BoxShape.circle,
//         gradient:new LinearGradient(
//         colors:colors,
//       ),
//       );
//   }

// }