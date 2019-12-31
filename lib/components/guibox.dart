
import 'dart:math';
import 'package:flutflow/components/dragbox.dart';
import 'package:flutflow/pages/guiboxes.dart';
import 'package:flutflow/utils.dart';
import 'package:flutter/material.dart';

class GuiBox{
  LRTB loc;
  LRTB bounds=LRTB(0.0, 1.0, 0.0, 1.0);
  List<GuiBox> childrenBoxes=[];
  int currentIndex;
  DragBox currentDragBox;
  int tapCount=0;
  int myTapCount=0;
  Color color;

 // Point activeClickLocation;
  bool dismissMe=false;
  bool isDragging=false;
  bool childDragging=false;
  bool passedInChild=false;
  bool guiActive=true;
  bool isRoot=false;
  String type="";
  dynamic childCall;
  

  Widget child;
  GuiBox(this.loc, {this.color});

  bool handleClick(Point clickLocation){
    print("MY LOCATION");
    loc.prnt();
  print(clickLocation);
    if(loc.isWithin(clickLocation)){
      myTapCount+=1;
      Point rs = loc.rescale(clickLocation);
      print("HANDLE CLICK");
      print(rs);
      print(clickLocation);
      print(myTapCount);
     
        if(childrenBoxes.isNotEmpty && myTapCount>1 ){//&& !passedInChild
          print("CHILD NOT EMPTY");
          int i =0;
          while(childrenBoxes.length>i && !childrenBoxes[i].handleClick(rs))i++;
          if(i==childrenBoxes.length){
            print("SELF CLICKED");
            if(currentIndex!=null){currentIndex=null;tapCount=0;}else{ tapCount+=1;}
           // if(!guiActive)return true;
            if(myTapCount>1){// && !passedInChild
                  GuiBox b= GuiBox(LRTB(rs.x, rs.x, rs.y, rs.y),color: RandomColor.next());
                  childrenBoxes.add(b); 
                  currentIndex=childrenBoxes.length-1;
                  setBounds();
                  childrenBoxes.last.fitSpace(shrink:0.75);
              }
            }

          else{
              print("CHILD $i CLICKED");
              if(currentIndex!=i){currentIndex = i;tapCount=0;}
              else tapCount+=1;
              if(tapCount>2){
              print("CHILD MULTITAP");
                
              } 
              }
        }


        else if(myTapCount>2 ){ //&& !passedInChild && guiActive&& !passedInChild
            print("SELF MULTITAP");
           
            GuiBox b= GuiBox(LRTB(rs.x, rs.x, rs.y, rs.y), color: RandomColor.next());
            childrenBoxes.add(b);
            currentIndex=childrenBoxes.length-1;
            setBounds();
              childrenBoxes.last.fitSpace(shrink:0.75);
               print("CHILD LOCATION");
               childrenBoxes.last.loc.prnt();
        }
      else{
           if(currentIndex!=null){currentIndex=null;tapCount=0;}else{ tapCount+=1;}
        }
    
      return true;
    }
    else {
      myTapCount=0;
      currentIndex=null;tapCount=0;
      return false;
    }
  }

  bool handleDrag(Point clickLocation){
   // print("HDRAG");
    print(clickLocation);
    loc.prnt();
    if(loc.isWithin(clickLocation)){
      //print("TRE");
      Point rs = loc.rescale(clickLocation);
      print(rs);
      setBounds();
      if(currentIndex!=null &&
       // tapCount>1 &&
      //!passedInChild &&
         childrenBoxes[currentIndex].handleDrag(rs)){
          print("DRAGGING child $currentIndex");
          
          childDragging=true;
          isDragging=false;
        }
        else if(!isRoot){ // && guiActive
          print("DRAGGING self");
          loc.prnt();
      currentDragBox=DragBox(loc,bounds );
      currentDragBox.isOnBox(clickLocation);
      isDragging=true;
        }
      return true;
    }
    else return false;

  }
  updateDrag(Point point) {
    if(isDragging && !isRoot) currentDragBox.updateDrag(point);
//&& !passedInChild
    else if(childDragging)childrenBoxes[currentIndex].updateDrag(loc.rescale(point));
  }
  endDrag(){
    dismissMe=false;
    setBounds();
    if(isDragging && !isRoot){
      isDragging=false;
      dismissMe=currentDragBox.endDrag();// if(dismissMe)
      currentDragBox=null;
    }else if (childDragging){
      childDragging=false;
      childrenBoxes[currentIndex].endDrag(); //currentDragBox.endDrag();  //if(currentDragBox.isDismissed()){
      if(childrenBoxes[currentIndex].dismissMe){
        print("Dismiss");
        childrenBoxes.removeAt(currentIndex);
        currentIndex=null;
      }
    }
  }

  updateBounds(LRTB neighborBox)=>
    bounds = loc.updateBounds(neighborBox, bounds);
  
  resetBounds()=>bounds=LRTB(0, 1.0, 0, 1.0);
  
  void fitSpace({double shrink}){
    loc=bounds;
    if(shrink!=null)loc.shrink(shrink);
  }
  setBounds({boxIndex}){
    if(boxIndex==null && currentIndex!=null)boxIndex=currentIndex;//if(currentBox==null)return;
    if(boxIndex==null)return;
    childrenBoxes[boxIndex].resetBounds();
    for (int boxNum=0; boxNum<childrenBoxes.length;boxNum++){
      print("BOX $boxNum BOUNDS");
      if(boxIndex!=boxNum)childrenBoxes[boxIndex].updateBounds(childrenBoxes[boxNum].loc);
    }
  }


  Widget al({Function() refresh}){
    return Align(alignment: Alignment.topRight,child: IconButton(icon: Icon(Icons.blur_circular,color: guiActive?Colors.green:Colors.grey,),
    onPressed: (){
      guiActive=!guiActive;
      if(refresh!=null)refresh();
      },
    ),
    );
  }
  Widget toWidget(Size screenSize, {Widget newChild, Function() refresh}){
    Size s = Size((loc.right-loc.left)*screenSize.width,(loc.bottom-loc.top)*screenSize.height);


     return Positioned(
       left: loc.left*screenSize.width,
       width: s.width,
       top: loc.top*screenSize.height,
       height: s.height,
       child:Stack(
         children: <Widget>[
           SizedBox.fromSize(
          size: s,
         child: Container(color:color,
         child:
         (newChild!=null)?Container(color:Colors.green,child: newChild)
        // :(childCall!=null)?childCall()
         :(childrenBoxes.isNotEmpty)?toStack(s, refresh: refresh):Text("Hello")
         )),
           guiActive?SizedBox.fromSize(
          size: s,
          child:Container(
            color: Colors.grey.withOpacity(0.1),
            child:al(refresh: refresh))):al(refresh: refresh)
         ],
       ));

  }
    Widget toStack(Size screenSize, {Function() refresh}){
      //print(screenSize);
      List<Widget> out=[];
      childrenBoxes.forEach((f){
        out.add(f.toWidget(screenSize, refresh: refresh));
      });
      
     // if(currentDragBox!=null)
      if(childDragging &&
      currentIndex!=null &&
      childrenBoxes[currentIndex].currentDragBox!=null
      )// && mainBoxes[currentBox].currentDragBox!=null)
      out.add( CustomPaint(
                    painter: DragPainter(
                      dragbox: childrenBoxes[currentIndex].currentDragBox
                    ), // Box Painter
                    child: Container()),);
      
      return Stack(children: out);
    }



}








 class LRTB{
   double left;
   double right;
   double top;
   double bottom;
   LRTB(this.left, this.right, this.top, this.bottom);
   void prnt(){
     print("left: $left, right:$right, top: $top, bottom: $bottom");
   }



   bool isWithin(Point clickLocation)=>
     (clickLocation.x > left &&
        clickLocation.x < right &&
        clickLocation.y > top &&
        clickLocation.y< bottom); 

    Point rescale(Point clickLocation){
      Point p=Point(
        (clickLocation.x-left)/(right-left),
        (clickLocation.y-top)/(bottom-top), );
       // print("click");
      //  prit(clickLocation);

       // prin(p);
        return p;
    }
    shrink(double pct){
      var w = (1-pct)*(right-left)/2;
      var h = (1-pct)*(bottom-top)/2;
      
      right=right-w;
      left=left+w;
      bottom=bottom-h;
      top=top+h;

    }
    
    LRTB updateBounds(LRTB neighborBox, LRTB currentBounds){
      // neighbor on left side
     // currentBounds.prnt();
     // neighborBox.prnt();
      if(onEdge(neighborBox))return currentBounds;
      LRTB newBounds = currentBounds;

      // neighbor box could either be on the edge ,no bound, on left right top or bottom
      if(neighborBox.right<left && neighborBox.right>currentBounds.left)
        newBounds.left=neighborBox.right;
      
      // neighbor On Righ side
      else if (neighborBox.left>right && neighborBox.left<currentBounds.right)
        newBounds.right=neighborBox.left;
      
      else if(neighborBox.bottom<top && neighborBox.bottom >currentBounds.top)
        newBounds.top=neighborBox.bottom;
      
      else if(neighborBox.top>bottom && neighborBox.top<currentBounds.bottom)
        newBounds.bottom = neighborBox.top;
    //  newBounds.prnt();
      return newBounds;
    }

   
    bool onEdge(LRTB neighborBox){
      if((neighborBox.bottom<top ||neighborBox.top>bottom) &&(neighborBox.left>right || neighborBox.right<left))return true;
      //if((neighborBox.top>bottom) &&(neighborBox.left>right || neighborBox.right<left))return true;
      return false;
    }
 }

  //Widget _child;
  // passedInChild=false;
  // if (childCall!=null)passedInChild=true;
  //   passedInChild=true;
  // child= Container(color:Colors.amber,child: newChild);
  // }
  // else if(childCall){
  // //else {//if(childrenBoxes.isNotEmpty){
  //   child = (childrenBoxes.isNotEmpty)?toStack(s, refresh: refresh):Text("Hello");
  // }

  // else {
  //   print(child.toString());// =="WebView")
  //   child=WebView(
  //     initialUrl: 'https://flutter.dev',
  //   );
  // }
     // if(!guiActive)return true;
     // activeClickLocation=clickLocation;
  // String toStr(){
  //    return '''
  //    fitted(l:${left}_r:${right}_t${top}_b$bottom)~@child
  //    ''';
  //  }
  //  Widget toPositioned(Size screenSize, Widget child){
  //    return Positioned(
  //      left: left*screenSize.width,
  //      width: (right-left)*screenSize.width,
  //      top: top*screenSize.height,
  //      height: (bottom-top)*screenSize.height,
  //      child: Container(
  //        height: (bottom-top)*screenSize.width,
  //        width: (right-left)*screenSize.width,
  //        color: Colors.blue,child: Text("Hello"),
  //        ),
  //    );
  //  }

        //   (childrenBoxes.isNotEmpty)?SizedBox.fromSize(
      //     size: s,
      //    child: Container(color:Colors.orange,child: toStack(s))):
      //  newChild??Container(
      //    color: Colors.blue,child: Text("Hello"),
      //    ),
    // );
  // }
    //loc.toPositioned(screenSize,Container(color: Colors.blue,child: Text("Add Child"),));


    
    //if(childrenBoxes!=null)return Container();
    //if(newChild!=null)child=newChild;
    //if(child!=null)return loc.toPositioned(screenSize, child);

   // return 
  //}
  
         //  Align(alignment: Alignment.topRight,child: IconButton(icon: Icon(Icons.blur_circular,color: Colors.green,),onPressed: (){},),),
           