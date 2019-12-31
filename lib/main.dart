/*
Main features - ui layout mode for when editing
Once editing is done you can 'freeze' to data which saves app in data that can be instantly parsed by the app itself,
allowing for 'no-code' updates to apps and websites
or 'freeze' into code which you can then copy and past into a dart file


To be able to do this, first in and out of gui mode,


*/
import 'dart:async';
import 'dart:math';

/*
Main features - ui layout mode for when editing
Once editing is done you can 'freeze' to data which saves app in data that can be instantly parsed by the app itself,
allowing for 'no-code' updates to apps and websites
or 'freeze' into code which you can then copy and past into a dart file


To be able to do this, first in and out of gui mode,


*/

import 'package:flutflow/state_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:no_brainer/components/animated_list.dart';
import 'package:no_brainer/utils/other.dart';

import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;
void main() async{
/*
    try {
    fb.initializeApp(
       apiKey: "AIzaSyDU-vLIua4u1l0i2LikrZIMV3YTqoDynOA",
    authDomain: "portfolio-27dc5.firebaseapp.com",
    databaseURL: "https://portfolio-27dc5.firebaseio.com",
    projectId: "portfolio-27dc5",
    storageBucket: "portfolio-27dc5.appspot.com",
    messagingSenderId: "616077941152",
    
    //appId: "1:616077941152:web:2273ab53f446b9287d2cc5",
    //measurementId: "G-50EGC0S52Y"
    );

    
    runApp(MyApp());
    
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }*/
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MrApp(), 
    );
  }
}
class MrApp extends StatefulWidget {
  @override
  _MrAppState createState() => _MrAppState();
}

class _MrAppState extends State<MrApp> {
  StateManager stateManager = StateManager();
TextInputClient p;
  //Navigation navigation;
  @override
  void initState() {
    super.initState();

    //var db = fb.firestore();
    stateManager.initialize();
    // refresh when ui manager is called so that screen changes
    stateManager.addListener(() {
      setState(() {});
    });
    //navigation = Navigation(() => setState((){}), routes);
  }
  
  Widget menubutton({String name, Function onPress, double width}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: width,
          height: 50.0,
          child: MaterialButton(
            color: Colors.white.withOpacity(0.1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            onPressed: onPress ?? () {},
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(195, 20, 50, 1.0),
                Color.fromRGBO(36, 11, 54, 1.0)
              ]),
        ),
        child: Stack(
          children: <Widget>[
           Positioned(
              top: 0.0,
              height: h,//-50.0,
              width: w*0.85,
              left: 0.0,
              child: SizedBox(width: w*0.85, height: h , child: stateManager.getScreen()),   // navigation.getCurrentScreen()(),),
            ),
          CustomAnimatedList(
          introDirection: DIREC.BTT,
          size: Size(w,h),
          widgetList: <Widget>[
            menubutton(name: "Home", width: .2 * w,
            onPress: () => stateManager.changeScreen("/")
            ),
            menubutton(name: "Essays", width: .2 * w,
            onPress: () => stateManager.changeScreen("/essays")
            ),
            menubutton(name: "Books", width: .2 * w,
            onPress: () => stateManager.changeScreen("/books")),
            menubutton(
                name: "Quotes",
                width: .2 * w,
                onPress: () => stateManager.changeScreen("/music")),
    
            menubutton(name: "Sites", width: .2 * w,
            onPress: () => stateManager.changeScreen("/sites")
            ),
          ],
          lrtb: LRTBsize(0.85, 1.0, 0.05, 0.9),
  
        ),
          ],
        ),
      ),
    );
  }
}





        // ),
          // )
     //   menubutton(name: "Questions", width: .2 * w),
            // menubutton(name: "People", width: .2 * w,
            // onPress: () => stateManager.changeScreen("/people")
            // ),
     // Positioned(
            //   top: 0.0,
            //   height: 50.0,
            //   width: w,
            //   left: 0.0,
            //   child: Container(
            //     height: 50.0,
            //     child: IconButton(
            //       onPressed: () => stateManager.changeScreen("/"),
            //       icon: Icon(Icons.home),
            //     ),
            //     //  child: navigation.navBar(w)
            //   ),
            // ),
// return Scaffold(
//  appBar: navigation.getAppBar(w),
//  body: navigation.getCurrentScreen()()
// Container(color: Colors.blue,),
//  );

// final Completer<WebViewController> _controller =
//   Completer<WebViewController>();
// All widgets reside in a guiBox, which acts like a self contained ui space for content,
// Te guibox itself is a container with it's color, transparency padding border etc changable
// Map<int, GuiBox> mainBoxes; // maps boxes to id
//List<GuiBox> mainBoxes=[];
//  bool isDragging=false;
// DragBox currentDragBox;
// int currentBox=0;
// int tapCount=0;

// final Completer<WebViewController> _controller =
//     Completer<WebViewController>();
// WebViewController webViewController= WebViewPlatformController(handler);
        // CustomAnimatedList(
        //   introDirection: DIREC.BTT,
        //   size: s,
        //   widgetList: <Widget>[
        //     menubutton(name: "Home", width: .2 * s.width),
        //     menubutton(name: "Essays", width: .2 * s.width,
        //     onPress: () => stateManager.changeScreen("/essays")
        //     ),
        //     menubutton(name: "Books", width: .2 * s.width),
        //     menubutton(
        //         name: "Quotes",
        //         width: .2 * s.width,
        //         onPress: () => stateManager.changeScreen("/quotes")),
        //     menubutton(name: "Questions", width: .2 * s.width),
        //     menubutton(name: "People", width: .2 * s.width),
        //     menubutton(name: "Places", width: .2 * s.width),
        //   ],
        //   lrtb: LRTBsize(0.85, 1.0, 0.0, 0.7),
        //   // ),
        //   // )
        // ),
          // Widget menubutton({String name, Function onPress, double width}) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //         width: width,
  //         height: 50.0,
  //         child: MaterialButton(
  //           color: Colors.white.withOpacity(0.1),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //           onPressed: onPress ?? () {},
  //           child: Text(
  //             name,
  //             style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 20.0,
  //                 fontStyle: FontStyle.italic),
  //           ),
  //         )),
  //   );
  // }