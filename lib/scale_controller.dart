

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:no_brainer/utils/mathish.dart';
enum LAYOUTTYPE{
  MOBILE,
  DESKTOP
}
class ScaleController extends ChangeNotifier {
  final Size screenSize;
  LAYOUTTYPE layouttype;
  bool mobile=false;

  Rect _menu, _mainArea;
  double paddingLR, paddingTB;
  Size _menuButton;
  ScaleController(this.screenSize){
   // print(screenSize);
    if (screenSize.width<900.0){
     // print("Mobile");
      mobile=true;
      paddingLR=15.0;
      paddingTB=10.0;
      layouttype=LAYOUTTYPE.MOBILE;
    }
      else {
   //     print("Desktop");
      layouttype=LAYOUTTYPE.DESKTOP;
      mobile = false;
       paddingLR=30.0;
      paddingTB=30.0;
    }
    _getMenuRect();
    _getMainAreaRect();
    _getMenuButtonSize();
  }

  double h()=>screenSize.height-(paddingTB*2);
  double w()=>screenSize.width-(paddingLR*2);
  Rect menu()=>_menu??_getMenuRect();
  Rect mainArea()=>_mainArea??_getMainAreaRect();
  Size menuButton()=>_menuButton??_getMenuButtonSize();

  Rect _getMenuRect(){
    if (mobile)_menu= Rect.fromLTWH(paddingLR, paddingTB, w(), fromHRange(0.15, low: 80.0));
    else {
      double ww = fromWRange(0.2, low: 80.0, high: 150.0);
      _menu= Rect.fromLTWH(w()-ww, paddingTB, ww, h());
    }
    return _menu;
  }
  Rect _getMainAreaRect(){
    if (mobile){
      double tb = fromHRange(0.15, low: 80.0);
      _mainArea= Rect.fromLTWH(paddingLR, tb, w(), h()-tb);
    }
    else _mainArea= Rect.fromLTWH(paddingLR, paddingTB, w()-fromWRange(0.2, low: 80.0, high: 150.0), h());
    return _mainArea;
  }
  Size _getMenuButtonSize(){
    if(mobile){
      _menuButton= Size(fromWRange(0.2, low:60.0, high:150.0), _menu.size.height);
    }else{
      _menuButton=  Size(_menu.size.width, fromWRange(0.1, low:50.0, high:70.0));
    }
    return _menuButton;
  }
  double getMenuFontSize(){
    return 16.0;
  }

 // Home

  Rect projList(){
    if(mobile)
      return Rect.fromLTWH(0.0, _mainArea.height/2, w(),  _mainArea.height/2);
    else
      return Rect.fromLTWH(0.0, _mainArea.height/2, _mainArea.width, fromHRange(0.4, low:150.0, high:250.0));
  }
  Size projectTile(){
    Rect p = projList();
    // make tile a square
    if(mobile)
      return Size(fromRange(p.width, high:p.height), fromRange(p.width, high:p.height));
    else
      return Size(fromRange(p.height, high:p.width), p.height);
  }

  // Bubble
  Rect bubbleBox(){
     if(mobile){
     
      return Rect.fromCenter(
        center:_mainArea.center,
        width:fromWRange(0.7, low:250, high:400),
        height:fromHRange(0.6, low:400, high:700)
        );
     }else{

      return  Rect.fromCenter(
        center:_mainArea.center,
        width:fromWRange(0.5, low:250, high:400),
        height:fromHRange(0.6, low:400, high:700)
        );
     }
  }

 Rect getBubbleLoc(Point pt, double diameter){
   double x = _mainArea.left+ pt.x*_mainArea.width;
   double y = _mainArea.top+ pt.y*_mainArea.height;
    return Rect.fromCircle(center:Offset(x,y), 
    radius: (mobile)?fromHRange(diameter, low:50.0, high:150.0)/2:fromHRange(diameter, low:80.0, high:200.0)
    );
  }
  Rect centerRect(){
    Rect bb= bubbleBox();
    //bb.topCenter
    double padding=10.0;
    double radius= fromHRange(0.3, low:25.0, high:100);
    return Rect.fromCircle(
      center:Offset(bb.topCenter.dx, bb.topCenter.dy-padding), 
      radius: radius
      );
  }
  List<Rect> getNodeLocations(Rect bubbleLoc, int nodesShown){
    List<Rect> nodeLocs=[];
    double centerX = bubbleLoc.center.dx;
    double centerY=bubbleLoc.center.dy;
    double ringRadius=bubbleLoc.width/3;
    double angleBetweenNodes = 400/nodesShown;
    double nodeRadius=fromRange(2*pi*ringRadius/(nodesShown*2), high:ringRadius/2, low:25.0);
    for(int nodeIndex=0; nodeIndex<nodesShown;nodeIndex++){
      nodeLocs.add(
        Rect.fromCircle(
          center: Offset(
            centerX+ringRadius*Z(nodeIndex*angleBetweenNodes), 
            centerY+ringRadius*K(nodeIndex*angleBetweenNodes)
            ),
            radius: nodeRadius
            ));
    }
    return nodeLocs;
  }
  
  

  double fromHRange(double frac, {double low=0.0, double high, bool only=false}){
    high??=screenSize.height;
    double out = frac*screenSize.height;
    return fromRange(out, low:low, high:high, only:only);
  }
  double fromWRange(double frac, {double low=0.0, double high, bool only=false}){
    high??=screenSize.width;
    double out = frac*screenSize.width;
    return fromRange(out, low:low, high:high, only:only);
  }

  //double wRangeOnly()
  double fromRange(double out, {double low=0.0, double high, bool only=false} ){
    if(only &&(out>high ||out<low))return 0.0;
    if(out>high)return high;
    if(out<low)return low;
    return out;
  }
  // Rect fillSpace(List<Rect> layoutItems, Point centered){
  //   // get box from layout items
  // }
 
  
}


//   Offset pixelsToCenter(Point pt){

//   }
//  Offset pixelsFromCenter(Point pt){

//   }


 // double fracHIfMore(double frac, double or)=>(screenSize.height*frac>or)?screenSize.height*frac:or;
  // double fracHOnlyIfMore(double frac, double or)=>(screenSize.height*frac>or)?screenSize.height*frac:0.0;
  // double fracWIfMore(double frac, double or)=>(screenSize.width*frac>or)?screenSize.width*frac:or;
  // double wOnlyIfMore(double frac, double or)=>(screenSize.width*frac>or)?screenSize.width*frac:0.0;