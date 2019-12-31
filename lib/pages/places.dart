
import 'dart:math';

import 'package:flutflow/components/category_bubble.dart';
import 'package:flutflow/components/item_node.dart';
import 'package:flutflow/data/bubble_data.dart';
import 'package:flutter/material.dart';
import 'package:no_brainer/components/text_builder.dart';


class Sites extends StatefulWidget {
  @override
  _SitesState createState() => _SitesState();
}

class _SitesState extends State<Sites>  with TickerProviderStateMixin {
  List<CategoryBubble> subBubs = [];
  AnimationController animationCont;
  ItemNode centerItem;
  ItemNode activeItem;
  double centerDiameter=0.1;
  String defaultDescription='''Web of My Life
Early attempt to better organizing all of the wonderful resources I have found on the internet into an easy to use and share format.

Our brains store and retrieve information in a "network-like" fashion, so why shouldn't we do the same with external resources? To test the concept, I started to make this 'web' of my favorite resources from various different subjects.
''';
  Size s;
  @override
  void dispose() {
    super.dispose();
    animationCont.dispose();
  }

  @override
  void initState() {
    super.initState();
   subBubs=subs;
   subBubs.forEach((subj){
    subj.init();
   });

    animationCont = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..addListener((){
      if(animationCont.isCompleted){
        centerItem=null;
          if(activeItem!=null)centerItem=activeItem;
        setState(() { 
          
        });
      }
    });
   
  }


  startAnimation(ItemNode newBubble){
   print(newBubble.name);
    if(newBubble!=centerItem)activeItem=newBubble;
    else activeItem = null;
    setState(() {
      
    });
     animationCont.forward(from: 0.0);
  }


  List<Widget> _bubbles(Size screenSize){ 
    List<Widget> out=[];
    subBubs.forEach((subj){
     out.add(subj.toWidget(s: s, ));
   });
    subBubs.forEach((subj){
     out.addAll(subj.toWidgets(s: screenSize, anim: animationCont, onTap: (ItemNode newBubble)=>startAnimation(newBubble)));
   });
   out.add(toCenter(s));
   out.add(toAnimated(s));
  
    return out;

  }
  Widget toCenter(Size screenSize){
    if(centerItem==null)return Container();
    
     double x= 0.5*screenSize.width;
     double y=0.3*screenSize.height;
      double scaledDL=centerDiameter*(screenSize.width+screenSize.height)/2;
    double scaledDS=centerItem.diameterS*(screenSize.width+screenSize.height)/2;
    Widget bub =centerItem.bubble(maxR: scaledDL, minR: scaledDS, onTap: ()=>startAnimation(centerItem));
     Offset pixelsToSelf= Offset((centerItem.pt.x-0.5)*screenSize.width, (centerItem.pt.y-0.3)*screenSize.height);

     double pixelsToGrow=scaledDL-scaledDS;
     CurvedAnimation c = CurvedAnimation(
       parent: animationCont,
       curve: Curves.decelerate

     );
     CurvedAnimation e = CurvedAnimation(
       parent: animationCont,
       curve: Curves.fastLinearToSlowEaseIn
     );
        

    return  AnimatedBuilder(
        animation: animationCont,
        child: bub,
        builder: (context, child) {
       double currentD = scaledDL-pixelsToGrow*e.value;
        return   Positioned(
      left: x+pixelsToSelf.dx*c.value - currentD/2,
      width: currentD,
      top: y+pixelsToSelf.dy*c.value - currentD/2,
      height: currentD,
        child:  Stack(
        children: <Widget>[
          Center(child: child),
          Center(child: 
          Text(centerItem.name, textAlign:TextAlign.center, 
          style: TextStyle(fontSize: 26.0-(14.0*animationCont.value).floorToDouble(),
           fontWeight: FontWeight.bold, 
           color: centerItem.fontColor),
           ),
           )
        ],
      )
      );
        }
      );
  }
  
  
   Widget toAnimated(Size screenSize){
     if(activeItem==null)return Container();
     
    double scaledDL=centerDiameter*(screenSize.width+screenSize.height)/2;
    double scaledDS=activeItem.diameterS*(screenSize.width+screenSize.height)/2;
     double x= activeItem.pt.x*screenSize.width;
     double y=activeItem.pt.y*screenSize.height;
     Widget bub =activeItem.bubble(maxR: scaledDL, minR: scaledDS, onTap: ()=>startAnimation(activeItem));
     Offset pixelsToCenter= Offset((0.5-activeItem.pt.x)*screenSize.width, (0.3-activeItem.pt.y)*screenSize.height);
     double pixelsToGrow=scaledDL-scaledDS;
   CurvedAnimation c = CurvedAnimation(
       parent: animationCont,
       curve: Curves.decelerate

     );
     CurvedAnimation e = CurvedAnimation(
       parent: animationCont,
       curve: Curves.easeIn
     );
    
    return  AnimatedBuilder(
        animation: animationCont,
        child:  bub,
        builder: (context, child) {
         double currentD =  scaledDS+pixelsToGrow*e.value;
        return   Positioned(
      left: x+pixelsToCenter.dx*c.value -currentD/2,
      width: currentD,
      top: y+pixelsToCenter.dy*c.value- currentD/2,
      height: currentD, 
            child:  Stack(
        children: <Widget>[
          Center(child: child),
          Center(child: 
          Text(activeItem.name,
          textAlign: TextAlign.center, 
          style: TextStyle(fontSize: 12.0+(14.0*animationCont.value).floorToDouble(), 
          fontWeight: FontWeight.bold, color: activeItem.fontColor),),)
        ],
      )//)
      );
        }
      );
   }

   Widget description(Size screenSize){
     
     

    
    return  AnimatedBuilder(
        animation: animationCont,
        child:   ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20.0)),
            padding: EdgeInsets.only(top:80.0, left: 5.0, right: 5.0),
            child: ListView(
              children: <Widget>[
                Container(
                  child: toRichText({
                    "text":(activeItem!=null)? activeItem.description??"":(centerItem!=null)?centerItem.description??"":"",//defaultDescription,
                    "token":"#"
                  })
                ),
              ],
            ),
             
            
          ),),
        builder: (context, child) {
      
        return   Positioned(
          height: 300,
          width: 300.0,
          left: s.width/2-150.0,
          top: s.height/2-150,
          child:Opacity(
          opacity: (animationCont.value>0.8)?(animationCont.value-0.8)*5.0:0.0,
          child: child,

        ));
        }
      );
   }


  @override
  Widget build(BuildContext context) {
    s=MediaQuery.of(context).size;
    return Stack(
      children: [
        
      ]..addAll(_bubbles(s))..add(description(s)),//, 100.0, 300.0
      
    );
  }
}




class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    double ax,bx,cx,ay,by,cy;
    ax=0.18;
    bx=0.24;
    cx=0.3;
    ay=0.0;
    by=0.14;
    cy=0.28;

    path.lineTo(size.width*0.1, 0);
    //path.lineTo(size.width/2, size.height/5);
    path.quadraticBezierTo(size.width*ax, ay,
        size.width*bx, size.height*by);
    path.quadraticBezierTo(size.width*cx, size.height*cy,
        size.width/2, size.height*cy);
    path.quadraticBezierTo(size.width*(1-cx), size.height*cy,
        size.width*(1-bx), size.height*by);//0.86
    path.quadraticBezierTo(size.width*(1-ax),cy,
        size.width*0.9, 0.0);
    //path.lineTo(size.width*0.85,0);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, 0.0);
 
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}






  //bool isActive=false;
  //bool isCenter=false;
 // Function() onTap;
 // double diameterL=0.1;
  ///double scaledDS=60;
 // double scaledDL=250;
//  Widget child;
        //if(activeItem!=null)centerItem=activeItem;
        //else centerItem=null;
       // bubblesData.forEach((b)=>b.shift());
       // subBubs.forEach((b)=>b.shift());
        

    //out.add(toWidget(s: s, ));
   // nodes.sort((a,b)=> b.order.compareTo(a.order));
//diameterSmall+pixelsToGrow*e.value,
      //child: FractionalTranslation(
           // translation: Offset(-0.5, -0.5),


// After reading Thinking Fast and Slow by Daniel Khaneman a couple years ago, I've become more and more obsessed with how we go about making decisions and how to identify and prevent faulty decision processes. 

// With the overwhelming amount of information available to us at our fingertips, toughest part of learning is figuring out what information is actually beneficial. 

// The Knowledge Project and The Tim Ferris Podcast are phenomenal resources for anyone who wants to live life better.

 // b.onTap=(String name, bool isActive)=>startAnim(name, isActive);
      //b.toChildWidget(()=>startAnim(b.name, b.isActive));
  // bubblesData.forEach((b){
  //   b.order=i;
  //   i++;
  //     b.diameterS=0.08;
  //     b.diameterL=0.3;
  //      b.onTap=(String name, bool isActive)=>startAnimation(name, isActive);
  //    // b.toChildWidget(()=>startAnimation(b.name, b.isActive));
  //     });
  // void shift(){
  //   order+=1;
  //   if(isActive){
  //     print("Active");
  //     isActive=false;
  //     isCenter=true;
  //   }
  //   else if(isCenter){
  //     isCenter=false;
  //     order+=1;
  //   }
  // }

// setDiameters(double small, double large){
  //   diameterSmall=small;
  //   diameterLarge=large;
  // }
  // onSelfTapped(){//Function onTap
  // print("self tapped");
  // print(name);
  //  // if(!isCenter) isActive=true;
  //  // else if(isCenter)isActive=false;
  //   image=NetworkImage(imgUrl);
  //   order=0;
  //   onTap(name, isActive);
  // }
  // toChildWidget(Function onTap){
  //   child=Bubble(
  //   name: name,
  //   url: url,
  //   imgUrl: imgUrl,
  //   categories: categories,
  //   max: scaledDL,
  //   min: scaledDS,
  //   onTap:()=>onSelfTapped(onTap),
  // );}
// class Bubble extends StatefulWidget {
//   final String name;
//   final String url; 
//   final String imgUrl;
//   final Function onTap;

//   NetworkImage image;
//   double min;
//   double max;

  
//   List<String> categories=[];
//   Bubble({ this.name, this.url, this.imgUrl,this.onTap, this.categories, this.min=100.0, this.max=300.0}){
//     this.image= NetworkImage(imgUrl);
//   }

//   @override
//   _BubbleState createState() => _BubbleState();
// }

// class _BubbleState extends State<Bubble> {

//   BoxDecoration _getDecoration(){

//     if(widget.categories.isEmpty) return BoxDecoration( shape: BoxShape.circle,);
//     List<Color> colors = [];
//     widget.categories.forEach((c){
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
    
//   @override
//   Widget build(BuildContext context) {
//     return // FractionalTranslation(
//             //translation: Offset(-0.5, -0.5),
//        GestureDetector(
//         onLongPress: ()=>launch(widget.url),
//         onTap: ()=>widget.onTap(),
//         child: Container(
//               decoration: _getDecoration(),
//               padding: EdgeInsets.all(5.0),
//               child: 
//               CircleAvatar(  backgroundImage:widget.image, maxRadius: widget.max/2, minRadius: widget.min/2,),
//             ),
      
    
//     );
//   }
// }

   // var firstControlPoint = Offset(size.width / 4, size.height);
    // var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    // path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
    //     firstEndPoint.dx, firstEndPoint.dy);

    // var secondControlPoint =
    //     Offset(size.width - (size.width / 3.25), size.height - 65);
    // var secondEndPoint = Offset(size.width, size.height - 40);
    // path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
    //     secondEndPoint.dx, secondEndPoint.dy);

    // path.lineTo(size.width, size.height - 40);
    // path.lineTo(size.width, 0.0);

       // CategoryBubble(
        //   name: "Neuroscience", 
        //   color: catColors["Neuroscience"], 
        //   centerAbout: Point(0.25,0.3),
        //   diameter: .5*s.height
        //   ),
        //   CategoryBubble(
        //   name: "Networks", 
        //   color: catColors["Networks"], 
        //   centerAbout: Point(0.65,0.3),
        //   diameter: .33*s.height
        //   ),
        //   CategoryBubble(
        //   name: "AI", 
        //   color: catColors["AI"], 
        //   centerAbout: Point(0.4,0.6),
        //   diameter: .5*s.height
        //   ),
        //   CategoryBubble(
        //   name: "Math", 
        //   color: catColors["Math"], 
        //   centerAbout: Point(0.6,0.73),
        //   diameter: .25*s.height
        //   ),
        //   CategoryBubble(
        //   name: "Music", 
        //   color: catColors["Music"], 
        //   centerAbout: Point(0.2,0.73),
        //   diameter: .33*s.height
        //   ),
  // Widget CategoryBubble({String name, Color color,Point centerAbout, double diameter}){
  //   return Positioned(
  //     left: centerAbout.x*s.width-diameter/2,
  //     width: diameter,
  //     top:centerAbout.y*s.height-diameter/2,
  //     height: diameter,
  //     child: Container(decoration: BoxDecoration(
  //       color: color.withOpacity(0.5),
  //       border: Border.all(color: color),
  //       shape: BoxShape.circle
  //     ),
  //     child: Align(
  //       alignment: Alignment.topCenter,
  //       child: Padding(
  //         padding: const EdgeInsets.only(top:20.0),
  //         child: Text(name, style: TextStyle(color: Colors.white, fontSize: 30.0),),
  //       )),)
  //     );
  // }


   //   Positioned(
      // left: s.width*0.0,
      // width: s.width/2,
      // top:s.height*0.1,
      // height: .5*s.height,
      // child: Container(decoration: BoxDecoration(
      //   color: Colors.green.withOpacity(0.5),
      //   border: Border.all(color: Colors.lightGreen),
      //   shape: BoxShape.circle
      // ),
      // child: Align(
      //   alignment: Alignment.topCenter,
      //   child: Padding(
      //     padding: const EdgeInsets.only(top:20.0),
      //     child: Text("Neuroscience", style: TextStyle(color: Colors.white, fontSize: 30.0),),
      //   )),)
      // ),
      //         Positioned(
      // left: s.width*0.53,
      // width: s.width/3,
      // top:0.1*s.height,
      // height: .4*s.height,
      // child: Container(decoration: BoxDecoration(
      //   color: Colors.blue.withOpacity(0.5),
      //   border: Border.all(color: Colors.lightGreen),
      //   shape: BoxShape.circle
      // ),
      // child: Align(
      //   alignment: Alignment.topCenter,
      //   child: Padding(
      //     padding: const EdgeInsets.only(top:20.0),
      //     child: Text("Networks", style: TextStyle(color: Colors.white, fontSize: 30.0),),
      //   )),)
      // ),
      // Positioned(
      // left: s.width*0.23,
      // width: s.width/3,
      // top:s.height*0.4,
      // height: .5*s.height,
      // child: Container(decoration: BoxDecoration(
      //   color: Colors.red.withOpacity(0.5),
      //   border: Border.all(color: Colors.lightGreen),
      //   shape: BoxShape.circle
      // ),
      // child: Align(
      //   alignment: Alignment.topCenter,
      //   child: Padding(
      //     padding: const EdgeInsets.only(top:20.0),
      //     child: Text("AI", style: TextStyle(color: Colors.white, fontSize: 30.0),),
      //   )),)
      // ),
      // Positioned(
      // left: s.width*0.5,
      // width: s.width/4,
      // top:s.height*0.6,
      // height: .3*s.height,
      // child: Container(decoration: BoxDecoration(
      //   color: Colors.amber.withOpacity(0.5),
      //   border: Border.all(color: Colors.lightGreen),
      //   shape: BoxShape.circle
      // ),
      // child: Align(
      //   alignment: Alignment.topCenter,
      //   child: Padding(
      //     padding: const EdgeInsets.only(top:20.0),
      //     child: Text("Math", style: TextStyle(color: Colors.white, fontSize: 30.0),),
      //   )),)
      // ),
      //  Positioned(
      // left: s.width*0.1,
      // width: s.width/4,
      // top:s.height*0.55,
      // height: .4*s.height,
      // child: Container(decoration: BoxDecoration(
      //   color: Colors.purple.withOpacity(0.5),
      //   border: Border.all(color: Colors.lightGreen),
      //   shape: BoxShape.circle
      // ),
      // child: Align(
      //   alignment: Alignment.topCenter,
      //   child: Padding(
      //     padding: const EdgeInsets.only(top:20.0),
      //     child: Text("Music", style: TextStyle(color: Colors.white, fontSize: 30.0),),
      //   )),)
      // ),

   // new current item
        // if(currentItem==null || currentItem!=activeItem){
        //   currentItem=activeItem;
        //   activeItem=null;
        // } // current item back
        // else if(activeItem==currentItem){
        //   currentItem=null;
        //   activeItem=null;
        // }
        //  bubbles.forEach((b){
        //    if(b.isCenter)b.isCenter=false;
        //     else if(b.isActive) {
        //        print("\n Active");
        //       print(b.name);
        //       b.isActive=false;b.isCenter=!b.isCenter;
        //     }});

  // List<Widget> _bubbles(Size screenSize, double diameterSmall, double diameterLarge){
  //   List<Widget> out=[];
  //  int current;
  //   int active;
  //  // Widget anim;

  //  // Widget abac;
  //   for (int i=0; i<bubbles.length;i++){
  //   //  if(i!=active && i!=current)
  //  // if(bubbles[i].isActive)active=i;
  //  // else if(bubbles[i].isCenter)current=i;
  //   else
  //     out.add(bubbles[i].toWidget(screenSize, (int id)=>startAnimation(id), animationCont));
  //   }
  //   if(current!=null)out.add(bubbles[current].toWidget(screenSize, (int id)=>startAnimation(id), animationCont));
  //   if(active!=null)out.add(bubbles[active].toWidget(screenSize, (int id)=>startAnimation(id), animationCont));
  //   // if(active!=-1)
  //   //   out.add(bubbles[active].toAnimated(screenSize, animationCont));
    
  //   // if(current!=-1) out.add(bubbles[active].toCenter(screenSize, (int id)=>startAnimation(id), animationCont));
  
  //   // bubbles.forEach((b){
  //   //   if(b.isActive){ anim= b.toAnimated(screenSize, animationCont);
  //   //   print("\n Active");
  //   //    print(b.name);
       
  //   //   }
  //   //   else if(b.isCenter)abac= b.toCenter(screenSize, (bool dir)=>startAnimation(dir), animationCont);
      
  //   //   else out.add(b.toWidget(screenSize, (bool dir)=>startAnimation(dir)));
  //   // });
  //   // if(abac!=null)
  //   //   out.add(abac);
  //   // if(anim!=null)
  //   //   out.add(anim);
  //   return out;
  // }
  // Widget toWidget(Size screenSize, Function setState,AnimationController anim){
  //   if(isActive){
  //     isCenter=true;
  //     isActive=false;
  //     return toAnimated(screenSize, anim);
  //   }
  //   else if(isCenter){
  //     isCenter=false;
  //     isActive=false;
  //     return toCenter(screenSize, setState, anim);
  //   }
    
  //   return Positioned(
  //     left: pt.x*screenSize.width,
  //     width: diameterSmall,
  //     top: pt.y*screenSize.height,
  //     height: diameterSmall,
  //     child:
  //      FractionalTranslation(
  //           translation: Offset(-0.5, -0.5),
  //           child: GestureDetector(
  //       onLongPress:()=>launch(url) ,
  //       onTap: (){
  //         isActive=true;
  //         isCenter=true;
  //         setState(id);
  //         },//isActive=!isActive; setState(isActive);},
  //       child: Container(
  //         decoration: _getDecoration(),
  //         padding: EdgeInsets.all(5.0),
  //         child: CircleAvatar(
  //           backgroundImage: image,
  //           //NetworkImage(imgUrl),
  //           radius:diameterSmall/2,
  //         ),
  //       ),
  //     ),
  //   )
  //   );
  // }
  // Widget toCenter(Size screenSize,Function setState,AnimationController anim){
  //   print("CETNER");
  //   print(name);
      
  //    double x= 0.5*screenSize.width;
  //    double y=0.5*screenSize.height;
  //    print("\n---------------------");
  //    print(name);
  //    print(y);
  //    print(x);
  //    print(pt);
  //   // double r=800;
  //    Offset pixelsToSelf= Offset((pt.x-0.5)*screenSize.width, (pt.y-0.5)*screenSize.height);
  //    //print(pixelsToCenter);
  //    double pixelsToGrow=diameterLarge-diameterSmall;

  //   return  AnimatedBuilder(
  //       animation: anim,
  //       child:  FractionalTranslation(
  //           translation: Offset(-0.5, -0.5),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
  //           child: Container(
  //           decoration: _getDecoration(),
  //           padding: EdgeInsets.all(5.0),
  //           child: CircleAvatar(
  //             backgroundImage: image,
  //             //NetworkImage(imgUrl),
  //             minRadius: diameterSmall/2,
  //             maxRadius: diameterLarge/2,
  //           ),
  //         ),
  //     ),  
  //       ),
  //       builder: (context, child) {
  //       //  pt=Point(pt.x, y+animation.value);
  //        // if(widget.size.heiht*(widget.lrtb.bottom-widget.lrtb.top)-100< itemAnimations[index].value)return Container();
  //       return   Positioned(
  //     left: x+pixelsToSelf.dx*anim.value,
  //     width: diameterLarge-pixelsToGrow*anim.value,
  //     top: y+pixelsToSelf.dy*anim.value,
  //     height: diameterLarge-pixelsToGrow*anim.value,
  //     child: child);
  //       }
  //     );
  // }
  
  
  //  Widget toAnimated(Size screenSize, AnimationController anim){
  //    double x= pt.x*screenSize.width;
  //    double y=pt.y*screenSize.height;
  //    print("\n---------------------");
  //    print(name);
  //    print(y);
  //    print(x);
  //    print(pt);
  //   // double r=800;
  //    Offset pixelsToCenter= Offset((0.5-pt.x)*screenSize.width, (0.5-pt.y)*screenSize.height);
  //    print(pixelsToCenter);
  //    double pixelsToGrow=diameterLarge-diameterSmall;

  //   return  AnimatedBuilder(
  //       animation: anim,
  //       child:  FractionalTranslation(
  //           translation: Offset(-0.5, -0.5),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
  //           child: Container(
  //           decoration: _getDecoration(),
  //           padding: EdgeInsets.all(5.0),
  //           child: CircleAvatar(
  //             backgroundImage:image,
  //             // NetworkImage(imgUrl),
  //             minRadius: diameterSmall/2,
  //             maxRadius: diameterLarge/2,
  //           ),
  //         ),
  //     ),  
  //       ),
  //       builder: (context, child) {
  //       //  pt=Point(pt.x, y+animation.value);
  //        // if(widget.size.heiht*(widget.lrtb.bottom-widget.lrtb.top)-100< itemAnimations[index].value)return Container();
  //       return   Positioned(
  //     left: x+pixelsToCenter.dx*anim.value,
  //     width: diameterSmall+pixelsToGrow*anim.value,
  //     top: y+pixelsToCenter.dy*anim.value,
  //     height: diameterSmall+pixelsToGrow*anim.value,
  //     child: child);
  //       }
  //     );
  // }
  // print("center");
  //   return Positioned(
  //     left: 0.5*screenSize.width,
  //     width: diameter,
  //     top: 0.5*screenSize.height,
  //     height: diameter,
  //     child:
  //      FractionalTranslation(
  //           translation: Offset(-0.5, -0.5),
  //           child: GestureDetector(
  //       onLongPress:()=>launch(url) ,
  //       onTap: (){isActive=true;setState(isCenter);},//isCenter=!isCenter; 
  //       child: Container(
  //         decoration: _getDecoration(),
  //         padding: EdgeInsets.all(5.0),
  //         child: CircleAvatar(
  //           backgroundImage: NetworkImage(imgUrl),
  //           radius:diameter/2,
  //         ),
  //       ),
  //     ),
  //   )
  //   );
   //  print(pixelsToGrow);
   //  final Animation animation = Tween<double>(begin: 0, end: r).animate(anim);
    //  Animation pixelsY=Tween<double>(
    //     begin:  0.0, 
    //     end:  1.0,
    //     ).animate(
    //       new CurvedAnimation(
    //           parent: anim,
    //           curve: new Interval(0.0, pixelsToCenter.dy, curve: Curves.decelerate)));

// Distill
// https://distill.pub/

// THE ASIMOV INSTITUTE
// https://www.asimovinstitute.org/
// https://www.asimovinstitute.org/neural-network-zoo-prequel-cells-layers/

// The brain from top to bottom
// https://thebrain.mcgill.ca/index.php
// https://thebrain.mcgill.ca/flash/d/d_06/d_06_cr/d_06_cr_mou/d_06_cr_mou_4a.jpg

// Project AGI
// https://agi.io/
// https://agi.io/wp-content/uploads/2019/10/logo-inverse-brown.png

// Blue Brain Portal
// https://portal.bluebrain.epfl.ch/
// https://i1.wp.com/portal.bluebrain.epfl.ch/wp-content/uploads/2019/07/BBP_megapaper_header_homepage_1.jpg


// Virtual Brain
// https://www.thevirtualbrain.org/tvb/zwei/brainsimulator-software
// https://www.thevirtualbrain.org/tvb/static/style/img/logo_tvb_main.svg

// Network Science Book
// http://networksciencebook.com/
// http://networksciencebook.com/images/ch-01/figure-1-6.jpg


// Network Models (Data Communications and Networking)
// https://what-when-how.com/data-communications-and-networking/network-models-data-communications-and-networking/
// http://what-when-how.com/wp-content/uploads/2011/08/tmp314_thumb.jpg

// Visualizing Quaternions
// https://eater.net/quaternions/video/intro

// Perspective Math
// https://www.cse.unr.edu/~bebis/CS791E/Notes/PerspectiveProjection.pdf

// Interactive Physics Labs 
// https://physics-labs.com/optics-lab/

// Hook Theory
// https://www.hooktheory.com/trends

// Magenta
// https://magenta.tensorflow.org/demos/community/

// Branch Education
// https://branch.education/

// PhET
// https://phet.colorado.edu/

// Flutter Widget Livebook
// https://flutter-widget-livebook.blankapp.org/basics/introduction/


// flutter-in-action
// https://livebook.manning.com/book/flutter-in-action/chapter-1/v-9/

// // class Places extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     Size s = MediaQuery.of(context).size;
// //     return Stack(
// //       children:[
// //         Positioned(
// //               top: s.height/2,
// //               height: 30.0,//-50.0,
// //               width: s.width/2,
// //               left: 30.0,
// //               child:Container(color: Colors.blue,),
// //               ),
// //         Positioned(
// //               top: 0.0,
// //               height: s.height,//-50.0,
// //               width: s.width*0.85,
// //               left: 0.0,
// //               child:
// //         Container(
// //               height: s.height*0.7,
// //               width: s.width*0.7,
// //               decoration: BoxDecoration(image:DecorationImage(  fit: BoxFit.cover,image:AssetImage("assets/map.png")) ),
// //               child: Center(
// //                 child: Container(
// //                   height: 30.0,
// //                   width: 40.0,
// //                   color: Colors.green,
// //                 ),
// //               )
// //         )
// //       ),
// //               Positioned(
// //               top: s.height/2,
// //               height: 30.0,//-50.0,
// //               width: s.width/2,
// //               left: 30.0,
// //               child:Container(color: Colors.red,),
// //               )
// //               //Image.network("http://www.pngall.com/wp-content/uploads/2017/05/World-Map-Free-Download-PNG.png")),
       
         
      
// //       ]
// //     );

// //   }
// // }