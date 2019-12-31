import 'package:flutflow/data/ess.dart';
import 'package:flutflow/utils.dart';
import 'package:flutter/material.dart';
import 'package:no_brainer/components/text_builder.dart';

class Essays extends StatelessWidget {
  Widget imageTemplate(String textSeg, Size size)=>
  Padding(
      padding: const EdgeInsets.only( left: 15.0, right: 15.0),
      child: toImage({
            "text": textSeg,
            "token":"#",
            "size":size
        })
      );
  Widget toImage(var tokens){
    Size size = ifIs(tokens, "size");
    String token= ifIs(tokens, "token")??"#";
    String text= tokens["text"];
    String imgUrl;
    double height;
    double width;
    Alignment align=Alignment.center;

    text.split(token).forEach((textSeg){
      if(textSeg.contains("link")){
        imgUrl = textSeg.substring("link".length);
      }
      else if (textSeg.contains("height")){
        height= double.tryParse(textSeg.substring("height".length));
       
        if(height!=null)height=size.height*height;
         //print(height);
      }
      else if (textSeg. contains("width")){
        
        width= double.tryParse(textSeg.substring("width".length));
        
        if(width!=null)width=size.width*width;
       // print(width);
      }
      else if (textSeg.contains("align")){
        String al = textSeg.substring("align".length);
        align = ifIs(defaultEnum["alignment"], al)??Alignment.center;
      //  print(align);
      }
    });
    if(imgUrl==null)return Container();

    return  Container(
      height: height,
    //  color: Colors.blue,
      child: Image.network(
        imgUrl,
        height:height,
        width:width,
        alignment: align,
        //color: Colors.blue,
      ),
    );

  }
   
Widget quoteTemplate(String textSeg, Size size)=>
  Padding(
                      padding: const EdgeInsets.only( left: 40.0, right: 15.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 15.0),
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.grey))
                      ), child: toRichText( {
                            "text": textSeg,
                              "token":"#"
                        }))
                      );

 Widget normalTemplate(String textSeg, Size size)=>  
  Padding(
    padding: const EdgeInsets.only(left: 30.0),
    child: toRichText( {
                            "text": textSeg,
                              "token":"#"
                        }),                       
  );
  List<Widget>  toComplexText(String text, {Map templates, String templateTokens="%%", String token="#"}){
    List<Widget> out = [];
    List<String> textSegs= text.split(templateTokens);
    String currentTemplate;
    textSegs.forEach((textSeg){
      if(templates.containsKey(textSeg)){
        currentTemplate=textSeg;
      }else if (currentTemplate!=null){
          out.add(templates[currentTemplate](textSeg));
      }
    });
    return out;
  }
                 
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20.0)

        ),
        child: Row(
          children: <Widget>[
            Container(
              width: s.width*0.14,
             // color: Colors.white,
              child: Column(
                children: <Widget>[
                  ExpansionTile(
                    title: Text("By Name"),
                  ),
                  ExpansionTile(
                    title: Text("By Topic"),
                  ),
                  ExpansionTile(
                    title: Text("By Date"),
                  ),
                  ExpansionTile(
                    title: Text("By Author"),
                  ),
                ],
              )
            ),

           Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 60.0, left: 15.0, right: 30.0),
                    //   child: toRichText({   
                    //     "text": betterWriter,
                    //     "token":"#"
                    //   })),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 60.0, left: 15.0, right: 30.0),
                    //   child: toRichText({   
                    //     "text": cargoCultScience,
                    //     "token":"#"
                    //   })),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 60.0, left: 15.0, right: 30.0),
                    //   child: toRichText({   
                    //     "text": howToBeSuccessful,
                    //     "token":"#"
                    //   })),
                
                  ]..addAll(toComplexText(antilib,
                  templates:{
                    "normal":(String textSeg)=>normalTemplate(textSeg, s),
                    "quote":(String textSeg)=>quoteTemplate(textSeg, s),
                    "image":(String textSeg)=>imageTemplate(textSeg, s),
                  //  "imageOverlay":(String textSeg)=>overlayImageTemplate(textSeg, s),
                  } ))
                  
                  ..add( Padding(
                      padding: const EdgeInsets.only(top: 60.0, left: 15.0, right: 30.0),
                      child: toRichText({   
                        "text": lifesShort,
                        "token":"#"
                      }))),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

//  Widget overlayImageTemplate(String textSeg, Size size)=>
//   Padding(
//       padding: const EdgeInsets.only( left: 15.0, right: 15.0),
//       child: toOverlayImage({
//             "text": textSeg,
//             "token":"#",
//             "size":size
//         })
//       );
//   Widget toOverlayImage(var tokens){
//     Size size = ifIs(tokens, "size");
//     String token= ifIs(tokens, "token")??"#";
//     String text= tokens["text"];
//     String imgUrl;
//     double left, top, height, width;
//     String imageInfo = text.substring(0, text.indexOf("/imageInfo"));
//     String textInfo = text.substring(text.indexOf("/imageInfo")+"/imageInfo".length);
    
//     imageInfo.split(token).forEach((textSeg){
//       if(textSeg.contains("link")){
//         imgUrl = textSeg.substring("link".length);
//       }
//       // else if (textSeg.contains("height")){
//       //   height= double.tryParse(textSeg.substring("height".length));
//       //   if(height!=null)height=size.height*height;
//       //    print(height);
//       // }
//       // else if (textSeg. contains("width")){
//       //   width= double.tryParse(textSeg.substring("width".length));
//       //   if(width!=null)width=size.width*width;
//       //   print(width);
//       // }
//       //  else if (textSeg. contains("left")){
//       //   width= double.tryParse(textSeg.substring("width".length));
//       //   if(width!=null)width=size.width*width;
//       //   print(width);
//       // }
//       //  else if (textSeg. contains("width")){
//       //   width= double.tryParse(textSeg.substring("width".length));
//       //   if(width!=null)width=size.width*width;
//       //   print(width);
//       // }
    
//     });
//     if(imgUrl==null)return Container();

//     return  Container( 
//       height: 500.0,
//       foregroundDecoration: BoxDecoration(
//       image: DecorationImage(
//       image: NetworkImage(imgUrl),
//       centerSlice: Rect.fromLTWH(0.0, 0.0,150.0, 150.0)
//     ),
//   ),
//       child:Text('''
//       This week, I caught myself feeling guilty as I walked into my office and looked at the ever-growing number of unread books.

// The library, as I call my office, is full of books I might never get to in my life let alone read this week. My bookshelf, which seems to reproduce on its own, is a constant source of ribbing from my friends.

// “You’ll never read all of those,” they say. And they’re right. I won’t. That’s not really how it works.

//       ''')
//       //  toRichText( {
//       //                       "text":textInfo,
//       //                         "token":"#"
//       //                   })
//     );

//   }

  // Padding(
  //                     padding: const EdgeInsets.only(top: 60.0, left: 15.0, right: 15.0),
  //                     child: toRichText({   
  //                       "text": sampleText["Antilibrary"],
  //                       "token":"#"
  //                     })),
  //                   Padding(
  //                     padding: const EdgeInsets.only( left: 40.0, right: 15.0),
  //                     child: Container(
  //                       padding: EdgeInsets.only(left: 15.0),
  //                     decoration: BoxDecoration(
  //                       border: Border(left: BorderSide(color: Colors.grey))
  //                     ),
  //                       child: toRichText({   
  //                         "text": sampleText["q1"],
  //                         "token":"#"
  //                       }),
  //                     )),
  //                   Padding(
  //                     padding: const EdgeInsets.only( left: 15.0, right: 15.0),
  //                     child: toRichText({   
  //                       "text": sampleText["Anti2"],
  //                       "token":"#"
  //                     })),
  //                      Padding(
  //                     padding: const EdgeInsets.only( left: 40.0, right: 15.0),
  //                     child: Container(
  //                       padding: EdgeInsets.only(left: 15.0),
  //                     decoration: BoxDecoration(
  //                       border: Border(left: BorderSide(color: Colors.grey))
  //                     ),
                       
  //                       child: toRichText({   
  //                         "text": sampleText["q2"],
  //                         "token":"#"
  //                       }),
  //                     )),
  //                      Padding(
  //                     padding: const EdgeInsets.only( left: 15.0, right: 15.0),
  //                     child: toRichText({   
  //                       "text": sampleText["a3"],
  //                       "token":"#"
  //                     })),
  //                      Padding(
  //                     padding: const EdgeInsets.only( left: 40.0, right: 15.0),
  //                     child: Container(
  //                       padding: EdgeInsets.only(left: 15.0),
  //                     decoration: BoxDecoration(
  //                       border: Border(left: BorderSide(color: Colors.grey))
  //                     ),
  //                       child: toRichText({   
  //                         "text": sampleText["q3"],
  //                         "token":"#"
  //                       }),
  //                     )),
  //                      Padding(
  //                     padding: const EdgeInsets.only( left: 15.0, right: 15.0),
  //                     child: toRichText({   
  //                       "text": sampleText["a4"],
  //                       "token":"#"
  //                     })),
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 60.0, left: 15.0, right: 15.0),
  //                     child: toRichText({   
  //                       "text": sampleText["lifes short"],
  //                       "token":"#"
  //                     })),
  //                      Padding(
  //                     padding: const EdgeInsets.only(left: 30.0),
  //                     child: toRichText({  
  //                       "color":"grey700", 
  //                       "fontSize":20.0,
  //                       "text": sampleText["quo"],
  //                       "token":"#"
  //                     }),                       
  //                   ),
  //                    Padding(
  //                     padding: const EdgeInsets.only(left: 2.0),
  //                     child: toRichText({   
  //                       "text": sampleText["Gettysburg Address"],
  //                       "token":"#"
  //                     }),                       
  //                   ),