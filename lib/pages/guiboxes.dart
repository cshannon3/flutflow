

import 'dart:math';

import 'package:flutflow/components/dragbox.dart';
import 'package:flutflow/components/guibox.dart';
import 'package:flutflow/data/dat.dart';
import 'package:flutflow/widget_manager.dart';
import 'package:flutter/material.dart';
import 'package:no_brainer/utils/random.dart';

class MyMainApp extends StatefulWidget {
  @override
  _MyMainAppState createState() => _MyMainAppState();
}

class _MyMainAppState extends State<MyMainApp> {
  MainDelagator d;
  bool isEditing = false;
  WidgetManager wm;

  void updateVal(String key, var newVal) {
    if (map[key] is Map)
      map[key]["value"] = newVal;
    else
      map[key] = newVal;

  //  print(key);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    d = MainDelagator();
    d.rootBox = GuiBox(LRTB(0.0, 1.0, 0.0, 1.0));
    d.rootBox.isRoot = true;
    d.rootBox.childrenBoxes.addAll([
      GuiBox(LRTB(0.1, 0.9, 0.05, 0.33), color: RandomColor.next()),
      GuiBox(LRTB(0.03, 0.6, .4, 0.8), color: RandomColor.next()),
      GuiBox(LRTB(0.7, 0.9, .5, 0.7), color: RandomColor.next()),
    ]);

    // d.rootBox.childrenBoxes.first.childCall=getImageChoices;
    // d.rootBox.childrenBoxes[1].childCall=wv;

    //  d.mainBoxes.add(f);
    d.addListener(() {
      setState(() {});
    });
    wm = WidgetManager(map: map, updateVal: updateVal);
  }

  @override
  void dispose() {
    d.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    d.size = MediaQuery.of(context).size - Offset(MediaQuery.of(context).size.width*0.2, 0.0);
    d.context = context;
    return Stack(
      children: <Widget>[
        SizedBox.fromSize(
            size: d.size,
            child: GestureDetector(
                onPanStart: d.onPanStart,
                onPanUpdate: d.onPanUpdate,
                onPanEnd: d
                    .onPanEnd, // onDoubleTap: d.onDoubleTap, //   onLongPress: d.onLongPress,
                onTapUp: d.onTapUp, //onTap: // onTapDown: d.onTapDown,
                child: Container(
                    color: Colors.transparent,
                    child: d.rootBox
                        .toStack(d.size, refresh: () => setState(() {})))) //

            ),
        //   wm.only("optionsOpen", optionsWidget(d.size)),
      ],
    );
  }
}

// Main delagator gets taps and sends them down chain of deals with them on own

class MainDelagator extends ChangeNotifier {
  //Set context for each setstate in order to  have access to widget tree info
  BuildContext context;
  Size size;

  GuiBox rootBox;
  Point currentTapLocation;
  MainDelagator();

  double getH() => size.height;
  double getW() => size.width;
  updateTapLocation(Offset screenpos) =>
      currentTapLocation = Point(screenpos.dx / getW(), screenpos.dy / getH());

  delegateTap(Offset screenpos) {
    currentTapLocation = Point(screenpos.dx / getW(), screenpos.dy / getH());
    //currentBox = (i<mainBoxes.length)?i:null;
  }

  onTapUp(TapUpDetails details) {
    print("TAP UP");
    //updateTapLocation(details.globalPosition);
    updateTapLocation(details.localPosition);
    rootBox.handleClick(currentTapLocation);
    notifyListeners();
  }

  onPanStart(DragStartDetails details) {
    print("PAN START");
    //updateTapLocation(details.globalPosition);
    updateTapLocation(details.localPosition);
    rootBox.handleDrag(currentTapLocation);
  }

  onPanUpdate(DragUpdateDetails details) {
    // updateTapLocation(details.globalPosition);
    updateTapLocation(details.localPosition);
    rootBox.updateDrag(currentTapLocation);
    notifyListeners();
  }

  onPanEnd(DragEndDetails details) {
    rootBox.endDrag();
    notifyListeners();
  }
}

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }
enum PRESS { TAP, DOUBLETAP, LONGPRESS, PAN }

class DragPainter extends CustomPainter {
  final DragBox dragbox;
  final Paint boxPaint1;
  //final Paint dropPaint;

  DragPainter({
    this.dragbox,
  }) : boxPaint1 = Paint()
  //dropPaint = Paint()
  {
    boxPaint1.color = this.dragbox.color;
    boxPaint1.style = PaintingStyle.fill;
    // dropPaint.color = Colors.grey;
    // dropPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    Path pathOne = dragbox.drawPath(size);
    canvas.drawPath(pathOne, boxPaint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}