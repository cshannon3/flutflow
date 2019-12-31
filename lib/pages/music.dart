



import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutflow/audio/audio_controller.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:no_brainer/utils/mathish.dart';
List<String> notesC = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
List<int> sharps = [49, 51 ,54,56, 58, 61 , 63, 66, 68, 70];

class PianoScreen extends StatefulWidget {
  final List<int> scale;
  final Function(bool correct) iscorrect;
  PianoScreen({
    this.scale,
    this.iscorrect,
  });
  @override
  _PianoScreenState createState() => new _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> with TickerProviderStateMixin{
  List<int> scalenotes;
  int inputnumber = 0;
  bool startedPlaying = false;
  bool ready=false;
  Timer _timer;
  double phase=0.0;
  double hfr= 0.0;
  double endfr=0.0;
  double decay=0.5;
  double amp=1.0;
  int last=0;
  bool doub=false;
  //Map<String, File> loadedFiles = {};
  List<AudioPlayerController> players=[];
  Map<String, int> keys = {
    "q":48,
    "w":49,
    "e":50,
    "r":51,
    "t":52,
    "y":53,
    "u":54,
    "i":55,
    "o":56,
    "p":57,
    "[":58,
    "]":59,
    "a":60,
    "s":61,
    "d":62,
    "f":63,
    "g":64,
    "h":65,
    "j":66,
    "k":67,
    "l":68,
    "z":69,
    "x":70,
    "c":71,
    "v":72
  };
  Map<int, AudioPlayerController> pl={};
List<int> activeKeys=[];


  @override
  void initState() {
    super.initState();
    scalenotes = widget.scale; 
    //_timer = Timer.periodic(
     //   Duration(milliseconds: (1000 / 15).round()), _update);
    keys.forEach((k,l){
      String a = "assets/audio/piano_$l.mp3";
      pl[l]=AudioPlayerController.asset(a);
      pl[l].initialize();
    });
  }

  _update(Timer t) {
    phase-=20.0;
    hfr+=0.005;
    if(hfr>1.0){endfr+=0.005;}
    else hfr+=0.005;
    
    setState(() {});
  }
  
  
// The node used to request the keyboard focus.
final FocusNode _focusNode = FocusNode();
// The message to display.
String _message;

// Focus nodes need to be disposed.
@override
void dispose() {
  _focusNode.dispose();
    players.forEach((p){
      p.dispose();
    });
  super.dispose();
} 
  


// Handles the key events from the RawKeyboardListener and update the
// _message.
void _handleKeyEvent(RawKeyEvent event) {
  setState(() {
    
   // print(event);
   // if(!startedPlaying){_testNote();startedPlaying=true;}
   if(keys.containsKey(event.logicalKey.keyLabel)){
     int note= keys[event.logicalKey.keyLabel];
    if(pl.containsKey(note)){
 
      if(pl[note].value.isPlaying){
          //print("playing");
         
          pl[note].pause();
          
           //pl[note].seekTo(Duration());
          //pl[note].seekTo(position)
          
          
        
      }
      else{
      pl[note].play();
       }
      if(activeKeys.length>=5)activeKeys.removeAt(0);
      activeKeys.add(note);
    }
   }
   });
  
}
  List<Widget> _buildKeys2() {
    List<Widget> keys = [];
    for (int p = 48; p< 72; ++p) {
      keys.add(_buildKey2(p));
    }
    return keys;
    // 49 C#/ 51 D#/ 54 F#/ 56 G#/ 58 A#/ //61 / 63/ 66/ 68/ 70
  }
 
  Widget _buildKey2(int keyname) {
    return GestureDetector(
      onTap: () {
        setState(() {
       
        if(pl.containsKey(keyname)){
          if(pl[keyname].value.isPlaying){
            print("playing");
            pl[keyname].pause();
            pl[keyname].seekTo(Duration());
          }

          pl[keyname].play();
          if(activeKeys.length>=5)activeKeys.removeAt(0);
          activeKeys.add(keyname);
        }
           
        });

      
 
        },
      onLongPress: () {} ,
      child: new Container(
        height: 100.0,
        width: 50.0,
        //color: (keyname.contains("sharp")) ? Colors.black : Colors.white10,
        decoration: BoxDecoration(

            color: activeKeys.contains(keyname)?Colors.pink: (sharps.contains(keyname)) ? Colors.black : Colors.white,
            border: Border(
              left: BorderSide(color: Colors.white24, width: 1.0),
              right: BorderSide(color: Colors.white24, width: 1.0),
              bottom: BorderSide(color: Colors.white24, width: 1.0),
            )
        ),
        padding: EdgeInsets.all(1.0),
        child: Text(
            notesC[keyname-48],
          style: TextStyle(
            color: (sharps.contains(keyname)) ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
Widget sinePainter({double height=80.0, double width,  double freq}){
    
    return Container(
        height:height,
        width: 80.0,
            child: CustomPaint(
              painter: SinePainter(
                 amplitude: amp,
                 frequency:freq,
                  yRange:height,
                  phaseShift: phase,
                  height: hfr,
                  startH: endfr,
                  decay:decay
                  ),
            ),
          );
  }

@override
Widget build(BuildContext context) {
  Size s=MediaQuery.of(context).size;
  final TextTheme textTheme = Theme.of(context).textTheme;
  return    
    Column(
      children: <Widget>[
        Expanded(child:  Row(
          children: <Widget>[
            Expanded(child: Container(
              child: Center(
                child: sinePainter(
                  width: s.width/3,
                  height: s.height/2,
               //   amp: 1.0,
                  freq: 20.0
                ),
              ),
            ),),
            Expanded(
              child: Container(
    color: Colors.white,
    alignment: Alignment.center,
    child: DefaultTextStyle(
      style: textTheme.display1,
      child: RawKeyboardListener(
              focusNode: _focusNode,
              onKey: _handleKeyEvent,
              child: AnimatedBuilder(
                animation: _focusNode,
                builder: (BuildContext context, Widget child) {
                  if (!_focusNode.hasFocus) {
                    return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      child: const Text('Tap to focus'),
                    );
                  }
                  return Text(_message ?? 'Press a key');
                },
              ),
      ),
    ),
  ),
            ),
          ],
        )),
        Expanded(
          child: Container(
            color: Colors.red,
                child: new ListView(
                  scrollDirection: Axis.horizontal,
                  children: _buildKeys2(),
                ), // ListView
          ),
        ),
      ],
    );
}
}
  /// A Custom Painter used to generate the trace line from the supplied dataset
class SinePainter extends CustomPainter {
  final double amplitude;
  final double phaseShift;
  final double frequency;
  final Color traceColor;
  double height;
  double startH;
  double decay;
  final double yRange;

  SinePainter( 
      {
      this.amplitude, 
      this.frequency,
      this.yRange,
      this.phaseShift=0.0,
      this.decay=0.0,
this.height=1.0,
this.startH=0.0,
      this.traceColor = Colors.green});

  @override
  void paint(Canvas canvas, Size size) {
    final tracePaint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0
      ..color = traceColor
      ..style = PaintingStyle.stroke;

    
   
    Path trace = Path();
    height??=1.0;
    if(height>1.0)height=1.0;
    else if(height<0.0)height=0.0;
    double h = height*size.height;
    startH??=0.0;
    if(startH>1.0)return;

    if(startH<0.0)startH=0.0;
    double h2 = startH*size.height;
    
   //print(size.height);
   trace.moveTo(size.width/2+amplitude*size.width*K(phaseShift+ h2*frequency*2)/2, (size.height -h2).toDouble());//
   for(int i=h2.floor(); i<h;i++){
     double y=(size.height -i).toDouble();
     double a = amplitude-(decay*i/size.height);
     if(a<0.0)a=0.0;
   // print(a);
     trace.lineTo(size.width/2+a
          *size.width*K(phaseShift+ i*frequency*2)/2, y);//
   }

    canvas.drawPath(trace, tracePaint);

      // if yAxis required draw it here
  
  }

  @override
  bool shouldRepaint(SinePainter old) => true;
}
// Future<void> _playNote(int keyname) async {
  //   print(keyname);
  //   bool playthis=true;
  //   String a = "assets/audio/piano_$keyname.mp3";
  //   AudioPlayerController p= AudioPlayerController.asset(a);
     
  //   await p.initialize();
  //   p.play();

    //   await players.last.initialize();
    //   await players.last.setVolume(1.0);
    //   await players.last.play();
    // print(players.length);
    // if(players.isNotEmpty){
    //   int i=0;
    //  while (i<players.length){
    //    print(players[i].value.position.inMilliseconds);
    //    if(players[i].value.position.inMilliseconds==0.0){
    //      players[i].dispose();
    //      players.removeAt(i);
    //    }
    //    else if(players[i].value.position.inMilliseconds<500){
    //      playthis=false;
    //      i++;
    
    //    }
    //    else{
    //      i++;
    //    }
    //  }
     
    // }
    // if(playthis){

    //   players.add(AudioPlayerController.asset(a));
    //   await players.last.initialize();
    //   await players.last.setVolume(1.0);
    //   await players.last.play();
     
    // }
    

    //   if (players.first.value.isPlaying){
      
    //   //players.forEach((p){
    //    // if(p.value.isPlaying)p.pause();
    //  // });
    //   players.add(AudioPlayerController.asset(a));
    //   await players.last.initialize();
    //   await players.last.setVolume(1.0);
    //   print(players.length);
    //   //players.forEach((p){
    //   //  p.play();
    //   //});
    //   await players.last.play();
    // }else{
    //   players.first.dispose();
    //   players.first = AudioPlayerController.asset(a);
    //   await players.first.initialize();
    //   await players.first.setVolume(1.0);
    //   await players.first.play();

    
  
   // return true;
 // }

  // _testNote() async {
  //   String a = "assets/audio/piano_50.mp3";
  //   String b = "assets/audio/piano_53.mp3";
  //   String c = "assets/audio/piano_58.mp3";
  //   players=[];
  //   players.add(AudioPlayerController.asset(a));
  //   await players.last.initialize();
  //   await players.last.setVolume(1.0);
  //   players.add(AudioPlayerController.asset(b));
  //   await players.last.initialize();
  //   await players.last.setVolume(1.0);
  //   players.add(AudioPlayerController.asset(c));
  //   await players.last.initialize();
  //   await players.last.setVolume(1.0);
  //   players.forEach((p){
  //     p.play();
  //   });
  //   return true;
  // }
  // setState(() {
      
        
    // });
    
    //if (event.logicalKey == LogicalKeyboardKey.keyQ) {
    //  _message = 'Pressed the "Q" key!';
    //} else {
    //  if (kReleaseMode) {
     //   _message = 'Not a Q: Key label is "${event.logicalKey.keyLabel ?? '<none>'}"';
     // } else {
        // This will only print useful information in debug mode.
     //   _message = 'Not a Q: Pressed ${event.logicalKey.debugName}';
     // }
   // }
  //});
  // @override
  // void dispose() {
  //   //_audioPlayerController.dispose();
  //   players.forEach((p){

  //     p.dispose();
  //   });
  //   super.dispose();
  // }


  // @override
  // Widget build(BuildContext context) {
  
  //   return  
  //   Column(
  //     children: <Widget>[
  //       Expanded(child: Container(),),
  //       Expanded(
  //         child: Container(
  //           color: Colors.red,
  //               child: new ListView(
  //                 scrollDirection: Axis.horizontal,
  //                 children: _buildKeys2(),

  //               ), // ListView
  //         ),
  //       ),
  //     ],
  //   );
  // }

//}

















// class Music extends StatefulWidget {
//   @override
//   _MusicState createState() => _MusicState();
// }

// class _MusicState extends State<Music> {
//     html.AudioElement e; 
//     @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     e=html.AudioElement();
//     e.src="audio/piano_51.mp3";
  
//   }
//   @override
//   Widget build(BuildContext context) {
    
//     e.autoplay=true;

//     return Container(
      
//     );
//   }
// }


// //import 'package:flame/flame.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:soundpool/soundpool.dart';

// Soundpool _soundpool;
// int _alarmSound = -1;

// class SimpleApp extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//      _soundpool = Soundpool();
//     return Center(
//           child: RaisedButton(
//             onPressed: _playSound,
//             child: Text("Play sound"),
//           ),
        
//     );
//   }

//   void _playSound() async {
//     if (_alarmSound < 0) {
//       _alarmSound = await _soundpool.loadAndPlayUri(
//           "https://github.com/ukasz123/soundpool/raw/master/example/sounds/dices.m4a");
//     } else {
//       _soundpool.play(_alarmSound);
//     }
//   }
// }