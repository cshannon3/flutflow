import 'package:flutflow/audio/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'dart:io';

class AudioPlayPause extends StatefulWidget {
  AudioPlayPause();

  //AudioPlayerController_audioPlayerController;

  @override
  State createState() {
    return _AudioPlayPauseState();
  }
}

class _AudioPlayPauseState extends State<AudioPlayPause> {
  // _AudioPlayPauseState() {
  //   listener = () {
  //     SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
  //   };
  // }
  AudioPlayerController _audioPlayerController;
  bool startedPlaying = false;
  bool ready=false;
  Map<String, File> loadedFiles = {};


  @override
  void initState() {
    super.initState();
    print("INIT");
  }

  @override
  void dispose() {
    _audioPlayerController.dispose();
    super.dispose();
  }

  Future<bool> started() async {
    print("OK");
    String a = "assets/audio/piano_F.mp3";
    print(a);
    _audioPlayerController =
        AudioPlayerController.asset(a);
    await _audioPlayerController.initialize();
  //  _audioPlayerController.addListener(listener);
    await _audioPlayerController.setVolume(1.0);
    await _audioPlayerController.play();
    startedPlaying = true;
    return true;
  }



  FadeAnimation imageFadeAnim =
      FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
  VoidCallback listener;


 
  // @override
  // void deactivate() {
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //    _audioPlayerController.setVolume(0.0);
  //    _audioPlayerController.removeListener(listener);
  //   });

  //   super.deactivate();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
          future: started(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
    
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
      GestureDetector(
        child: AudioPlayer(_audioPlayerController),
        onTap: () {
          if (!_audioPlayerController.value.initialized) {
            return;
          }
          if (_audioPlayerController.value.isPlaying) {
            imageFadeAnim =
                FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
           _audioPlayerController.pause();
          } else {
            imageFadeAnim =
                FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
           _audioPlayerController.play();
          }
        },
      ),
 
      
      Center(child: imageFadeAnim),
      Center(
          child:_audioPlayerController.value.isBuffering
              ? const CircularProgressIndicator()
              : null),
    ],
    ); 
           
            } else {
              return const Text('waiting for video to load');
            }
          },
        
      );
  }
}

class FadeAnimation extends StatefulWidget {
  FadeAnimation(
      {this.child, this.duration = const Duration(milliseconds: 500)});

  final Widget child;
  final Duration duration;

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animationController.isAnimating
        ? Opacity(
            opacity: 1.0 - animationController.value,
            child: widget.child,
          )
        : Container();
  }
}





class PlayerVideoAndPopPage extends StatefulWidget {
  @override
  _PlayerVideoAndPopPageState createState() => _PlayerVideoAndPopPageState();
}

class _PlayerVideoAndPopPageState extends State<PlayerVideoAndPopPage> {
  AudioPlayerController _audioPlayerController;
  bool startedPlaying = false;
  bool ready=false;
  Map<String, File> loadedFiles = {};


  @override
  void initState() {
    super.initState();
    print("INIT");
    
  
  }

  @override
  void dispose() {
    _audioPlayerController.dispose();
    super.dispose();
  }

  Future<bool> started() async {
    print("OK");
    String a = "assets/audio/piano_F.mp3";
    print(a);
    _audioPlayerController =
        AudioPlayerController.asset(a);
    _audioPlayerController.addListener(() {
      if (startedPlaying && !_audioPlayerController.value.isPlaying) {
        Navigator.pop(context);
    }});

    await _audioPlayerController.initialize();
    await _audioPlayerController.play();
    startedPlaying = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      child: Center(
        child: FutureBuilder<bool>(
          future: started(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return AspectRatio(
                  aspectRatio: _audioPlayerController.value.aspectRatio,
                  child: AudioPlayer(_audioPlayerController));
            } else {
              return const Text('waiting for video to load');
            }
          },
        ),
      ),
    );
  }
}