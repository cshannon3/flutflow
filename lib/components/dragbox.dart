

import 'package:flutflow/components/guibox.dart';
import 'package:flutflow/data/dat.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DragBox {
  bool isDragging = false;
  Color color = Colors.transparent;
  DRAGSIDE dragside = DRAGSIDE.NONE;
  LRTB o;
  LRTB b;
  double newposition;
  Point start;
  Point activePoint;
  //Size size;
  DragBox(LRTB initPosition, LRTB initBounds){
    this.o=initPosition;
    this.b =initBounds;
  }


  bool isOnBox(Point tap) {
      print("IN BOX");
      start = tap;
      isDragging = true;
      color = Colors.grey[400].withOpacity(.3);
      return true;
  }

  void updateDrag(Point point) {
    if (!isDragging) return;
    activePoint = point;
    var dragVecY = activePoint.y - start.y;
    var dragVecX = activePoint.x - start.x;
    final normDragVecX = (dragVecX ).clamp(-1.0, 1.0);
    final normDragVecY = (dragVecY ).clamp(-1.0, 1.0);
    if (dragside == DRAGSIDE.NONE) getdragside(dragVecX, dragVecY);
    if (dragside == DRAGSIDE.CENTER) {
      start = activePoint;
      o.left = (o.left + normDragVecX).clamp(b.left, b.right);
      o.right = (o.right + normDragVecX).clamp(b.left, b.right);
      o.top = (o.top + normDragVecY).clamp(b.top, b.bottom);
      o.bottom = (o.bottom + normDragVecY).clamp(b.top, b.bottom);
    } else if (dragside == DRAGSIDE.LEFT || dragside == DRAGSIDE.RIGHT) {
      if (dragside == DRAGSIDE.LEFT)
        newposition = (o.left + normDragVecX).clamp(b.left, b.right);
      else
        newposition = (o.right + normDragVecX).clamp(b.left, b.right);
    } else {
      if (dragside == DRAGSIDE.DOWN)
        newposition = (o.bottom + normDragVecY).clamp(b.top, b.bottom);
      else
        newposition = (o.top + normDragVecY).clamp(b.top, b.bottom);
    }
  }

  void getdragside(double dragVecX, double dragVecY) {

    double centerX = (o.left + (o.right - o.left) / 2);
    double centerY = (o.top + (o.bottom - o.top) / 2);
    double spanX = o.right - o.left;
    double spanY = o.bottom - o.top;
    if ((start.x - centerX).abs() < spanX * .25 &&
        (start.y - centerY).abs() < spanY * .25) {
      print("Center");
      dragside = DRAGSIDE.CENTER;
    } else {
      if (dragVecX.abs() > dragVecY.abs()) {
        if (start.x - o.left > o.right - start.x) {
          print("right");
          dragside = DRAGSIDE.RIGHT;
        }
        // if(dragVecX>0)dragside=DRAGSIDE.RIGHT;
        else {
          print("left");
          dragside = DRAGSIDE.LEFT;
        }
      } else {
        if (start.y - o.top > o.bottom - start.y) {
          print("down");
          dragside = DRAGSIDE.DOWN;
        } else {
          print("up");
          dragside = DRAGSIDE.UP;
        }
       
      }
    }
  }


  bool endDrag() {
    if (dragside == DRAGSIDE.UP)
      o.top = newposition;
    else if (dragside == DRAGSIDE.DOWN)
      o.bottom = newposition;
    else if (dragside == DRAGSIDE.LEFT)
      o.left = newposition;
    else if (dragside == DRAGSIDE.RIGHT) o.right = newposition;
    activePoint = null;
    newposition = null;
    start = null;
    dragside = DRAGSIDE.NONE;
    color = Colors.transparent;
    isDragging = false;
    return ((o.right-o.left)<0.02 || (o.bottom-o.top)<0.02);

  }
  //bool isDismissed()=>((o.right-o.left)<0.03 || (o.bottom-o.top)<0.03);

  Path drawPath(Size size) {
    if (dragside == DRAGSIDE.DOWN) return drawBottom(size);
    if (dragside == DRAGSIDE.UP) return drawTop(size);
    if (dragside == DRAGSIDE.LEFT) return drawLeft(size);
    if (dragside == DRAGSIDE.RIGHT) return drawRight(size);
    return drawBox(size);
    //
    //
  }

  Path drawBox(Size size) {
   // print(size);
    final path = Path();
    // Draw the curved sections with quadratic bezier to
    // Start at the point of the touch
    path.moveTo(size.width * o.left, size.height * o.top);
    // draw the curvedo.left side curve
    path.lineTo(size.width * o.right, size.height * o.top);
    path.lineTo(size.width * o.right, size.height * o.bottom);
    path.lineTo(size.width * o.left, size.height * o.bottom);
    path.close();

    return path;
  }

  Path drawBottom(Size size) {
    final boxValueY = size.height * newposition;
    final prevBoxValueY = (size.height * o.bottom);
    final midPointY = ((boxValueY - prevBoxValueY) * 1.2 + prevBoxValueY)
        .clamp(0.0, size.height);
    Point mid;

    mid = Point(size.width * (o.left + (o.right - o.left) / 2), midPointY);

    final path = Path();
    path.moveTo(mid.x, mid.y);
    path.moveTo(size.width *o.left, size.height *o.top);
    path.lineTo(size.width *o.left, size.height *o.bottom);
    // draw the curvedo.left side curve
    path.quadraticBezierTo(
      mid.x - size.width* ( o.right -o.left )/2, //x1,
      mid.y, //y1,
       mid.x, mid.y
      // size.width * o.left, //x2,
      // size.height * o.bottom, //y2
    );
    //
    // path.lineTo(size.width*right, size.height*top);
 //   path.moveTo(mid.x, mid.y);
    path.quadraticBezierTo(
      mid.x + size.width* ( o.right -o.left )/2, //x1,
      mid.y, //y1,
      size.width * o.right, //x2,
      size.height * o.bottom, //y2
    );
    path.lineTo(size.width *o.right, size.height *o.top);
    path.lineTo(size.width *o.left, size.height *o.top);
    //path.lineTo(size.width *o.left, size.height *o.bottom);
    //path.close();

    return path;
  }

  Path drawTop(Size size) {
    final boxValueY = size.height * newposition;
    final prevBoxValueY = (size.height *o.top);
    final midPointY = ((boxValueY - prevBoxValueY) * 1.2 + prevBoxValueY)
        .clamp(0.0, size.height);
    Point mid;
  
    mid = Point(size.width * (o.left + (o.right -o.left) / 2), midPointY);
    final path = Path();
    path.moveTo(size.width *o.left, size.height *o.bottom);
    path.lineTo(size.width *o.left, size.height *o.top);
    //path.moveTo(mid.x, mid.y);
      path.quadraticBezierTo(
      mid.x-size.width* ( o.right -o.left )/2,
      mid.y, //y1,
      mid.x, mid.y
      // size.width *o.left, //x2,
      // size.height *o.top, //y2
    );

  
    //path.moveTo(mid.x, mid.y);
    path.quadraticBezierTo(
      mid.x + size.width* ( o.right -o.left )/2, //x1,
      mid.y, //y1,
      size.width *o.right, //x2,
      size.height *o.top, //y2
    );
    path.lineTo(size.width *o.right, size.height *o.bottom);
    path.lineTo(size.width *o.left, size.height *o.bottom);
   // path.lineTo(size.width *o.left, size.height *o.top);
  //  path.close();

    return path;
  }

  Path drawLeft(Size size) {
    final boxValueY = size.width * newposition;
    final prevBoxValueX = (size.width *o.left);
    final midPointX = ((boxValueY - prevBoxValueX) * 1.2 + prevBoxValueX)
        .clamp(0.0, size.width);
    Point mid;

    mid = Point(midPointX, size.height * (o.top + (o.bottom -o.top) / 2));

    final path = Path();
    //path.moveTo(mid.x, mid.y);
    path.moveTo(size.width *o.right, size.height *o.top);
    path.lineTo(size.width *o.left, size.height *o.top);
    // draw the curvedo.left side curve
    path.quadraticBezierTo(
      mid.x, //x1,
      mid.y -size.height* ( o.bottom -o.top )/2, //y1,
      mid.x, mid.y
      // size.width *o.left, //x2,
      // size.height *o.top, //y2
    );
    //
    // path.lineTo(size.width*right, size.height*top);
    //path.moveTo(mid.x, mid.y);
    path.quadraticBezierTo(
      mid.x, //x1,
      mid.y +size.height* ( o.bottom -o.top )/2, //y1,
      size.width *o.left, //x2,
      size.height *o.bottom, //y2
    );
    path.lineTo(size.width *o.right, size.height *o.bottom);
    path.lineTo(size.width *o.right, size.height *o.top);
   // path.lineTo(size.width *o.left, size.height *o.top);
    //path.close();

    return path;
  }

  Path drawRight(Size size) {
    final boxValueY = size.width * newposition;
    final prevBoxValueX = (size.width *o.right);
    final midPointX = ((boxValueY - prevBoxValueX) * 1.2 + prevBoxValueX)
        .clamp(0.0, size.width);
    Point mid;

    mid = Point(midPointX, size.height * (o.top + (o.bottom -o.top) / 2));

    final path = Path();
 //   path.moveTo(mid.x, mid.y);  // draw the curvedo.left side curve

    path.moveTo(size.width *o.left, size.height *o.top);
    path.lineTo(size.width *o.right, size.height *o.top);
    
    path.quadraticBezierTo(
      mid.x, //x1,
      mid.y - size.height* ( o.bottom -o.top )/2, //y1,
      mid.x, 
      mid.y
      // size.width *o.right, //x2,
      // size.height *o.top, //y2
    );
    //
    //path.moveTo(mid.x, mid.y);
    path.quadraticBezierTo(
      mid.x, //x1,
      mid.y + size.height* ( o.bottom -o.top )/2, //y1,
      size.width *o.right, //x2,
      size.height *o.bottom, //y2
    );
    path.lineTo(size.width *o.left, size.height *o.bottom);
    path.lineTo(size.width *o.left, size.height *o.top);
    //path.lineTo(size.width *o.right, size.height *o.top);
    //path.close();

    return path;
  }

}

