
import 'package:flutflow/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:no_brainer/makers/model_maker.dart';
//import 'dart:js' as js;

class Books extends StatefulWidget {
  final StateManager stateManager;
  Books(this.stateManager);

  @override
  _BooksState createState() => _BooksState();
}

class _BooksState extends State<Books> {

  List activeModels = [];

  void onActivate(CustomModel book){
    if(activeModels.contains(book)){
      activeModels.remove(book);
    }else if(activeModels.length<6){
      activeModels.add(book);
    }else activeModels[5]=book;
    setState((){});
  }


  Widget mobileLayout(){
    //List<Widget> out
    return ListView(
      children: <Widget>[
        instrucWidget(),

      ],
    );

  }

  Widget desktopLayout(){

  }

  Widget bookTiles(){
    List books  =widget.stateManager.bookList;
   return Container(
              padding: EdgeInsets.all(30.0),
                child:new GridView.count(
                crossAxisCount:(widget.stateManager.sc.w()/180.0).floor(),
                children: new List<Widget>.generate(books.length, (index) {
                  return new 
                     BookTile(bookData:books[index], setActive: onActivate,isActive: activeModels.contains(books[index]),);
              
                })
                )
                );
  }
  List<Widget> selectedBooks(){
    return List.generate(activeModels.length, ((i){
                return  Container(
                  width: widget.stateManager.sc.h()*.12,
                  height:  widget.stateManager.sc.h()*.15,
                 // color: Colors.green,
                  child: BookTile(bookData: activeModels[i],isActive: true,setActive: onActivate,));
              }))??[]; 
  }

  Widget instrucWidget(){
    return Padding(
                  padding: const EdgeInsets.only(left:50.0, top: 10.0),
                  child: Container(
                    width: widget.stateManager.sc.w(),
                    child:
                     Center(
                       child: Text(
                    "Pick 2-5 books that you have read and enjoyed then enter your name and email or twitter name and I'll send you a recommendation on what to read next!",
                    style: TextStyle(color:Colors.white,)),
                     ),),
                );
  }

  Widget textInputs(){
    TextEditingController nameController;
    TextEditingController eorTController;
    return Column(children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: new InputDecoration(
                           fillColor: Colors.white.withOpacity(0.8),
                           filled: true,
                          hintText: 'Name'
                        ),
                        controller: nameController,
                      )
                      ),
                   Expanded(
                      child: TextField(
                         decoration: new InputDecoration(
                           fillColor: Colors.white.withOpacity(0.8),
                           filled: true,
                          hintText: 'Email or Twitter'
                        ),
                        controller: eorTController,
                      )
                      ),
                      Expanded(
                      child:Center(
                        child: RaisedButton(
                          onPressed: (){},
                          child: Text("Submit"),
                        ),
                      )
                      ),
                  ],);
  }


  @override
  Widget build(BuildContext context) {
 
    return Padding(
      padding: const EdgeInsets.only(top:20.0),
      child: Column(
        children: <Widget>[
          instrucWidget(),
          Container(
           // width:s.width,
            height: 100.0,
            child: Row(
              children: <Widget>[
              ]..addAll(selectedBooks() )
             // ..add(textInputs() )
              ,
          ),
          ),
          Expanded(
            child: bookTiles()
          ),
        ],
      ),
    );
  }
}

class BookTile extends StatefulWidget {
  final CustomModel bookData;
  bool isActive;
  Function(CustomModel) setActive;

  BookTile({this.bookData, this.setActive, this.isActive=false}) ;

  @override
  _BookTileState createState() => _BookTileState();
}

class _BookTileState extends State<BookTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
                    padding: widget.isActive?EdgeInsets.all(0.0):EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: ()=>widget.setActive(widget.bookData),
                      // {setState(() {
                        
                      //   widget.isActive=!widget.isActive;
                      // });}
                      child: new Card(
                        borderOnForeground:widget.isActive,
                        color: Colors.grey.withOpacity(0.3),
                        child: Container(
                          child: (widget.bookData==null)?null: Image.asset(widget.bookData.vars["imgUrl"], fit: BoxFit.fill,)
                        )
                      ),
                    ),
                  
    );
  }
}



// child: Padding(
                  //   padding: const EdgeInsets.all(5.0),
                  //   child: new Card(
                  //     color: Colors.grey.withOpacity(0.3),
                  //     child: Container(
                  //       child: Image.asset(books[index].vars["imgUrl"], fit: BoxFit.fill,)
                  //     )
                  //   ),
                  // ),

//                    Widget build(BuildContext context) {
//     //Size s = MediaQuery.of(context).size;
//     //print(s);
//     //List books  =widget.stateManager.bookList;
//     TextEditingController nameController;
//     TextEditingController eorTController;
//     return Padding(
//       padding: const EdgeInsets.only(top:20.0),
//       child: Column(
//         children: <Widget>[
//           Container(
//             width:s.width,
//             height: s.height*0.15,
//             child: Row(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(left:50.0, top: 10.0),
//                   child: Container(
//                     width: s.width*0.2,
//                     child: Text(
//                     "Pick 2-5 books that you have read and enjoyed then enter your name and email or twitter name and I'll send you a recommendation on what to read next!",
//                     style: TextStyle(color:Colors.white,)),),
//                 ),
               
           
//               ]..addAll(List.generate(activeModels.length, ((i){
//                 return  Container(
//                   width: s.height*.12,
//                   height: s.height*.15,
//                  // color: Colors.green,
//                   child: BookTile(bookData: activeModels[i],isActive: true,setActive: onActivate,));
//               })))..add(Expanded(child: Container(),))..add(
//                  Container(
//                   width: s.width*0.15,
//                   child: Column(children: <Widget>[
//                     Expanded(
//                       child: TextField(
//                         decoration: new InputDecoration(
//                            fillColor: Colors.white.withOpacity(0.8),
//                            filled: true,
//                           hintText: 'Name'
//                         ),
//                         controller: nameController,
//                       )
//                       ),
//                    Expanded(
//                       child: TextField(
//                          decoration: new InputDecoration(
//                            fillColor: Colors.white.withOpacity(0.8),
//                            filled: true,
//                           hintText: 'Email or Twitter'
//                         ),
//                         controller: eorTController,
//                       )
//                       ),
//                       Expanded(
//                       child:Center(
//                         child: RaisedButton(
//                           onPressed: (){},
//                           child: Text("Submit"),
//                         ),
//                       )
//                       ),
//                   ],),
//                 )
//               ),

            
//           ),
//           ),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.all(30.0),
//                 child:new GridView.count(
//                 crossAxisCount:(s.width/180.0).floor(),
//                 children: new List<Widget>.generate(books.length, (index) {
//                   return new 
//                      BookTile(bookData:books[index], setActive: onActivate,isActive: activeModels.contains(books[index]),);
                  
//                 }))),
//           ),
//         ],
//       ),
//     );
//   }
// }