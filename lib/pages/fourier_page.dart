import 'package:flutter/material.dart';
import 'package:no_brainer/components/text_builder.dart';
import 'package:no_brainer/screens/fourier_boxes.dart';
import 'package:no_brainer/screens/fourier_lines.dart';
import  'package:no_brainer/utils/oscilloscope.dart';



class Fourier2 extends StatefulWidget {
  @override
  _Fourier2State createState() => _Fourier2State();
}

class _Fourier2State extends State<Fourier2> {

  List<WaveController> waves=[];


  List<WaveInfo> _toWaveVals(){
    List<WaveInfo> out = [];
    waves.forEach((w){

      //if(w.isActive)
      out.add(w.toWaveInfo());
    });
    return out;

  }

  @override
  void initState() {
    super.initState();
    [[1.0, 1.0], [2.0,0.5],[3.0, 0.33],[4.0,0.25], [5.0, 0.2]].forEach((initVals){
      print(initVals);
      waves.add(WaveController(initVals[0], initVals[1]));
    });
  }

  @override
  void dispose() {
    
    waves.forEach((wave){
      wave.dispose();
    });
    
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        children: <Widget>[
          Container(
              width: size.width / 3,
              height: size.height,
              color: Colors.white.withOpacity(0.3),
              child: ListView(
                children: <Widget>[
                  Container(height: 160,width: double.infinity,
                  child: Image.network("https://upload.wikimedia.org/wikipedia/commons/7/72/Fourier_transform_time_and_frequency_domains_%28small%29.gif"),
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: Center(child:  toRichText({
                                      "token":"#",
                                         "fontSize":18,
                                      "text":
'''Resources:
  -#linkhttps://betterexplained.com/articles/an-interactive-guide-to-the-fourier-transform/#Interactive Guide to Fourier Transforms#/color##/link#
  -#linkhttp://www.jezzamon.com/fourier/index.html##colorblue#An Interactive Introduction to Fourier Transforms#/color##/link#
  -#linkhttps://www.youtube.com/watch?v=ds0cmAV-Yek##colorblue#Smarter Every Day Video#/color##/link#
  -#linkhttps://www.youtube.com/watch?v=r6sGWTCMz2k##colorblue#3blue1brown Video#/color##/link#
  -#linkhttps://www.youtube.com/watch?v=spUNpyF58BY##colorblue#3blue1brown Video 2#/color##/link#
  -#linkhttps://www.youtube.com/watch?v=Mm2eYfj0SgA##colorblue#Coding Train Video#/color##/link#
  -#linkhttps://www.youtube.com/watch?v=r18Gi8lSkfM##colorblue#Eugene Physics Video#/color##/link#
  '''
                                    }),),
                  ),
               
                ]
               ..addAll(List.generate(waves.length,(i) =>  waves[i].makeRow(setState:()=>setState(() {}), height:80.0, width: size.width / 3)
                      
               )
               )
              )
          ),
           Expanded(
                  child:FourierLines(
                    waves: _toWaveVals()

              )
           ),

        ],
      ),
    );
  }
 
}


  // Widget sinePainter({double amplitude, double freq, double height=80.0}){
    
  //   return Container(
  //       height:height,
  //       width: double.infinity,
  //           child: CustomPaint(
  //             painter: SinePainter(
  //                amplitude: amplitude,
  //                frequency:freq,
  //                 yRange:height),
  //           ),
  //         );
  // }
// class Fourier extends StatefulWidget {
//   @override
//   _FourierState createState() => _FourierState();
// }

// class _FourierState extends State<Fourier> {

//   Map<String, TextEditingController> c = {
//     "w1a": TextEditingController(),
//     "w2a": TextEditingController(),
//     "w3a": TextEditingController(),
//     "w4a": TextEditingController(),
//     "w5a": TextEditingController(),
//     "w1f": TextEditingController(),
//     "w2f": TextEditingController(),
//     "w3f": TextEditingController(),
//     "w4f": TextEditingController(),
//     "w5f": TextEditingController()
//   };
//   Map<String, dynamic> data = {
//     "wave1": {
//       "AmpCon":TextEditingController(),
//       "AmpVa":0.5,

//       },

//     "w2a": TextEditingController(),
//     "w3a": TextEditingController(),
//     "w4a": TextEditingController(),
//     "w5a": TextEditingController(),
//     "w1f": TextEditingController(),
//     "w2f": TextEditingController(),
//     "w3f": TextEditingController(),
//     "w4f": TextEditingController(),
//     "w5f": TextEditingController()
//   };

//   double w2a=0.5;
//   double w2f=2.0;
//   double w3a=0.33;
//   double w3f=3.0;
//   double w4a=0.25;
//   double w4f=4.0;
//    double w5a=0.125;
//   double w5f=8.0;

//   Widget fourier;

//   Widget sinePainter({double amplitude, double freq, double height=80.0}){
    
//     return Container(
//         height:height,
//         width: double.infinity,
//             child: CustomPaint(
//               painter: SinePainter(
//                  amplitude: amplitude,
//                  frequency:freq,
//                   yRange:height),
//             ),
//           );
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     c["w2f"].text=w2f.toString();
//     c["w2a"].text=w2a.toString();
//     c["w3f"].text=w3f.toString();
//     c["w3a"].text=w3a.toString();
//     c["w4f"].text=w4f.toString();
//     c["w4a"].text=w4a.toString();
//     c["w5f"].text=w5f.toString();
//     c["w5a"].text=w5a.toString();
//   }


//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     c.forEach((k,v){
//       v.dispose();
//     });

//   }
//   @override
//   Widget build(BuildContext context) {
  

//     Size size = MediaQuery.of(context).size;
//     return Container(
//       child: Row(
//         children: <Widget>[
//           Container(
//               width: size.width / 3,
//               height: size.height,
//               color: Colors.white.withOpacity(0.3),
//               child: Column(
//                 children: <Widget>[
//                   Container(height: 160,width: double.infinity,
//                   child: Image.network("https://upload.wikimedia.org/wikipedia/commons/7/72/Fourier_transform_time_and_frequency_domains_%28small%29.gif"),
//                   ),
//                   Container(
//                   //  height: 100.0,
//                     width: double.infinity,
//                     child: Center(child:  toRichText({
//                                       "token":"#",
//                                          "fontSize":18,
//                                       "text":
// '''Resources:
//   -#linkhttps://betterexplained.com/articles/an-interactive-guide-to-the-fourier-transform/#Interactive Guide to Fourier Transforms#/color##/link#
//   -#linkhttps://www.youtube.com/watch?v=ds0cmAV-Yek##colorblue#Smarter Every Day Video#/color##/link#
//   -#linkhttps://www.youtube.com/watch?v=r6sGWTCMz2k##colorblue#3blue1brown Video#/color##/link#
//   -#linkhttps://www.youtube.com/watch?v=spUNpyF58BY##colorblue#3blue1brown Video 2#/color##/link#
//   -#linkhttps://www.youtube.com/watch?v=Mm2eYfj0SgA##colorblue#Coding Train Video#/color##/link#
//   -#linkhttps://www.youtube.com/watch?v=r18Gi8lSkfM##colorblue#Eugene Physics Video#/color##/link#
//   '''
//                                     }),),
//                   ),
//                   Container(
//                       height: 80.0,
//                       child: Row(children: [
                        
//                         Expanded(
//                           child: Row(
//                             children: <Widget>[
//                               Text("Amp: "),
//                           Expanded(
//                             child: TextField(
//                               controller: c["w2a"],
//                               onChanged: (text) {
//                                 var out = double.tryParse(text);
//                                 if (out != null) {
//                                   setState(() {
//                                     w2a=out;
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                            Text("Freq: "),
                           
//                           Expanded(
//                             child: TextField(
                              
//                               controller: c["w2f"],
//                               onChanged: (text) {
//                                 var out = double.tryParse(text);
//                                 if (out != null) {
//                                   setState(() {
//                                     w2f=out;
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                            ],
//                           ),
//                         ),
//                         Expanded(child: sinePainter(amplitude: w2a, freq: w2f) )
//                       ])
//                       ),
//                                       Container(
//                       height: 80.0,
//                       child: Row(children: [
                        
//                         Expanded(
//                           child: Row(
//                             children: <Widget>[
//                               Text("Amp: "),
//                           Expanded(
//                             child: TextField(
//                               controller: c["w3a"],
//                               onChanged: (text) {
//                                 var out = double.tryParse(text);
//                                 print(out);
//                                 if (out != null) {
//                                   print("OUT");
//                                   //c["w2p"].text=text;
//                                   setState(() {
//                                     w3a=out;
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                            Text("Freq: "),
                           
//                           Expanded(
//                             child: TextField(
                              
//                               controller: c["w3f"],
//                               onChanged: (text) {
//                                 var out = double.tryParse(text);
//                                 print(out);
//                                 if (out != null) {
//                                   print("OUT");
//                                   //c["w2p"].text=text;
//                                   setState(() {
//                                     w3f=out;
//                                   });
//                                 }
//                               },
//                             ),
//                           ),

//                            ],
//                           ),
//                         ),
                        
//                        Expanded(child: sinePainter(amplitude: w3a, freq: w3f) )
//                       ])
//                       ),
//                                  Container(
//                       height: 80.0,
//                       child: Row(children: [
                        
//                         Expanded(
//                           child: Row(
//                             children: <Widget>[
//                               Text("Amp: "),
//                           Expanded(
//                             child: TextField(
//                               controller: c["w4a"],
//                               onChanged: (text) {
//                                 var out = double.tryParse(text);
//                                 print(out);
//                                 if (out != null) {
//                                   print("OUT");
//                                   //c["w2p"].text=text;
//                                   setState(() {
//                                     w4a=out;
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                            Text("Freq: "),
                           
//                           Expanded(
//                             child: TextField(
                              
//                               controller: c["w4f"],
//                               onChanged: (text) {
//                                 var out = double.tryParse(text);
//                                 print(out);
//                                 if (out != null) {
//                                   print("OUT");
//                                   //c["w2p"].text=text;
//                                   setState(() {
//                                     w4f=out;
//                                   });
//                                 }
//                               },
//                             ),
//                           ),

//                            ],
//                           ),
//                         ),
                        
//                        Expanded(child: sinePainter(amplitude: w4a, freq: w4f) )
//                       ])
//                       ),
//                                    Container(
//                       height: 80.0,
//                       child: Row(children: [
                        
//                         Expanded(
//                           child: Row(
//                             children: <Widget>[
//                               Text("Amp: "),
//                           Expanded(
//                             child: TextField(
//                               controller: c["w5a"],
//                               onChanged: (text) {
//                                 var out = double.tryParse(text);
//                                 print(out);
//                                 if (out != null) {
//                                   print("OUT");
//                                   //c["w2p"].text=text;
//                                   setState(() {
//                                     w4a=out;
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                            Text("Freq: "),
                           
//                           Expanded(
//                             child: TextField(
                              
//                               controller: c["w5f"],
//                               onChanged: (text) {
//                                 var out = double.tryParse(text);
//                                 print(out);
//                                 if (out != null) {
//                                   print("OUT");
//                                   //c["w2p"].text=text;
//                                   setState(() {
//                                     w4f=out;
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                            ],
//                           ),
//                         ),
                        
//                       Expanded(child: sinePainter(amplitude: w5a, freq: w5f) )
//                       ])
//                       ),
//                 ],
//               )
//               ),
//         // Expanded(
//          //  child: Column(
//             //  children: <Widget>[
//                /* Expanded(
//                   child: FourierBoxes(
//                     w1size: 1.0,
//                     w1speed: 1.0,
//                     w2size: w2a,
//                     w2speed: w2f,
//                     w3size: w3a,
//                     w3speed: w3f,
//                     w4size: w4a,
//                     w4speed: w4f,

//               ),
//                 ),*/ 
//                 Expanded(
//                   child:FourierLines(
//                     w1size: 1.0,
//                     w1speed: 1.0,
//                     w2size: w2a,
//                     w2speed: w2f,
//                     w3size: w3a,
//                     w3speed: w3f,
//                     w4size: w4a,
//                     w4speed: w4f,
//                     w5size: w5a,
//                     w5speed: w5f,

//               )
//                 //)r],
//           //  ),
//           ),
//         ],
//       ),
//     );
//   }
 
// }


// /// A Custom Painter used to generate the trace line from the supplied dataset
// class SinePainter extends CustomPainter {
//   final double amplitude;
//   final double frequency;
//   final Color traceColor;
//   final double yRange;

//   SinePainter( 
//       {
//         this.amplitude, 
//         this.frequency,
//       this.yRange,
//       this.traceColor = Colors.green});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final tracePaint = Paint()
//       ..strokeJoin = StrokeJoin.round
//       ..strokeWidth = 2.0
//       ..color = traceColor
//       ..style = PaintingStyle.stroke;

//     double yScale = (size.height / yRange);

//     // only start plot if dataset has data

//     double amp = yScale*amplitude;
//    // double slope = xScale*frequency;
//    // dataSet.length;
   
//     Path trace = Path();
//    trace.moveTo(0.0, size.height/2);
//    //print(size.height);
//    for(int i=0; i<size.width;i++){

//      trace.lineTo(i.toDouble(), size.height/2+amplitude*size.height*K(i*frequency*2)/2);//
//    }

//     canvas.drawPath(trace, tracePaint);

//       // if yAxis required draw it here
  
//   }

//   @override
//   bool shouldRepaint(SinePainter old) => true;
// }
