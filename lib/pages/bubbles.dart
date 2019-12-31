
import 'dart:math';

import 'package:flutflow/components/category_bubble.dart';
import 'package:flutflow/components/item_node.dart';
import 'package:flutflow/data/bubble_data.dart';
import 'package:flutflow/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:no_brainer/components/text_builder.dart';


class Bubbles extends StatefulWidget {
  final StateManager stateManager;

  Bubbles(this.stateManager);
  @override
  _BubblesState createState() => _BubblesState();
}

class _BubblesState extends State<Bubbles>  with TickerProviderStateMixin {
  List<CategoryBubble> subBubs = [];
  AnimationController animationCont;
  ItemNode centerItem;
  ItemNode activeItem;
  double centerDiameter=0.5;
  CurvedAnimation decelerate, fastIn, easeIn;
  
        

  @override
  void initState() {
    super.initState();
   subBubs=subs;
   subBubs.forEach((subj){
    subj.init(widget.stateManager.sc);
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
    decelerate= CurvedAnimation(
       parent: animationCont,
       curve: Curves.decelerate
     );
    fastIn = CurvedAnimation(
       parent: animationCont,
       curve: Curves.fastLinearToSlowEaseIn
     );
      easeIn= CurvedAnimation(
       parent: animationCont,
       curve: Curves.easeIn
     );
    
   
  }

  
  @override
  void dispose() {
    super.dispose();
    animationCont.dispose();
  }


  startAnimation(ItemNode newBubble){
   //print(newBubble.name);
    if(newBubble!=centerItem)activeItem=newBubble;
    else activeItem = null;
    setState(() {
      
    });
     animationCont.forward(from: 0.0);
  }


  List<Widget> _bubbles(){ 
    List<Widget> out=[];
    subBubs.forEach((subj){
     out.add(subj.toWidget());
   });
    subBubs.forEach((subj){
     out.addAll(subj.toWidgets( anim: animationCont, onTap: (ItemNode newBubble)=>startAnimation(newBubble)));
   });
   out.add(toCenter());
   out.add(toAnimated());
  
    return out;

  }
  Widget toCenter(){
    if(centerItem==null)return Container();

    Rect centerRect = widget.stateManager.sc.centerRect();
    Rect nodeRect = centerItem.nodeLoc;
  
     Widget bub =centerItem.bubble(maxR: centerRect.width/2, minR: nodeRect.width/2, onTap: ()=>startAnimation(centerItem));
     
     Offset pixelsToSelf= centerRect.center-nodeRect.center;
     double pixelsToGrow= (centerRect.width-nodeRect.width)/2;
     

    return  AnimatedBuilder(
        animation: animationCont,
        child: bub,
        builder: (context, child) {
        return  Positioned.fromRect(
          rect: Rect.fromCircle(
            center: centerRect.center+pixelsToSelf*decelerate.value,
           radius: (centerRect.width/2)-pixelsToGrow*fastIn.value
          ),
          child:  child
      );
     
        }
      );
  }
  
  
   Widget toAnimated(){
     if(activeItem==null)return Container();
    final Rect centerRect = widget.stateManager.sc.centerRect();
     final Rect nodeRect = activeItem.nodeLoc;
  
     Widget bub =activeItem.bubble(maxR: centerRect.width/2, minR: nodeRect.width/2, onTap: ()=>startAnimation(activeItem));
     
     Offset pixelsToCenter= centerRect.center-nodeRect.center;
     double pixelsToGrow= (centerRect.width-nodeRect.width)/2;

    
    return  AnimatedBuilder(
        animation: animationCont,
        child:  bub,
        builder: (context, child) {
        return Positioned.fromRect(
          rect: Rect.fromCircle(
            center: nodeRect.center.translate(pixelsToCenter.dx*decelerate.value, pixelsToCenter.dy*decelerate.value),
            radius: (nodeRect.width/2)+pixelsToGrow*easeIn.value,

          ),
            child:  child
      );
      
        }
      );
   }

   Widget description(){
    return  AnimatedBuilder(
        animation: animationCont,
        child:   ClipPath(
            clipper: CircleIndentClipper(),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9),
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
      
        return   (activeItem==null && centerItem==null)?Container():
        Positioned.fromRect(
          rect: widget.stateManager.sc.bubbleBox(),
          child:Opacity(
          opacity: (animationCont.value>0.8)?(animationCont.value-0.8)*5.0:0.0,
          child: child,

        ));
        }
      );
   }


  @override
  Widget build(BuildContext context) {
  
    return Stack(
      children: _bubbles()..add(description()),//, 100.0, 300.0
      
    );
  }
}


class CircleIndentClipper extends CustomClipper<Path> {
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


 // height: 300,
          // width: 300.0,
          // left: s.width/2-150.0,
          // top: s.height/2-150,


//     Positioned(
      // left: x+pixelsToCenter.dx*decelerate.value -currentD/2,
      // width: currentD,
      // top: y+pixelsToCenter.dy*decelerate.value- currentD/2,
      // height: currentD, 
      //       child:  child
      // );
     
     //Offset((0.5-activeItem.pt.x)*screenSize.width, (0.3-activeItem.pt.y)*screenSize.height);
     //double pixelsToGrow=scaledDL-scaledDS;

  // double scaledDL=centerDiameter*(screenSize.width+screenSize.height)/2;
    // double scaledDS=activeItem.diameterS*(screenSize.width+screenSize.height)/2;
    //  double x= activeItem.pt.x*screenSize.width;
    //  double y=activeItem.pt.y*screenSize.height;
    // Widget bub =activeItem.bubble(maxR: scaledDL, minR: scaledDS, onTap: ()=>startAnimation(activeItem));
 // left: x+pixelsToSelf.dx*decelerate.value - currentD/2,
      // width: currentD,
      // top: y+pixelsToSelf.dy*decelerate.value - currentD/2,
      // height: currentD,
        
      //    Positioned(
      // left: x+pixelsToSelf.dx*decelerate.value - currentD/2,
      // width: currentD,
      // top: y+pixelsToSelf.dy*decelerate.value - currentD/2,
      // height: currentD,
      //   child:  child
      // );

    //  double x= 0.5*screenSize.width;
    //  double y=0.3*screenSize.height;
    //   double scaledDL=centerDiameter*(screenSize.width+screenSize.height)/2;
    // double scaledDS=centerItem.diameterS*(screenSize.width+screenSize.height)/2;
    // Widget bub =centerItem.bubble(maxR: scaledDL, minR: scaledDS, onTap: ()=>startAnimation(centerItem));
    //  Offset pixelsToSelf= Offset((centerItem.pt.x-0.5)*screenSize.width, (centerItem.pt.y-0.3)*screenSize.height);

    //  double pixelsToGrow=scaledDL-scaledDS;

        

//   String defaultDescription='''Web of My Life
// Early attempt to better organizing all of the wonderful resources I have found on the internet into an easy to use and share format.

// Our brains store and retrieve information in a "network-like" fashion, so why shouldn't we do the same with external resources? To test the concept, I started to make this 'web' of my favorite resources from various different subjects.
// ''';
//   Size s;

    //  CurvedAnimation c = CurvedAnimation(
    //    parent: animationCont,
    //    curve: Curves.decelerate
    //  );
    //  CurvedAnimation e = CurvedAnimation(
    //    parent: animationCont,
    //    curve: Curves.fastLinearToSlowEaseIn
    //  );

      //  CurvedAnimation c = CurvedAnimation(
  //      parent: animationCont,
  //      curve: Curves.decelerate

  //    );
  //    CurvedAnimation e = CurvedAnimation(
  //      parent: animationCont,
  //      curve: Curves.easeIn
  //    );