import 'dart:async';
import 'dart:html';

import 'package:flutflow/audio/audio_player_interface.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;

// Required for PluginUtilities.
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
//https://github.com/luanpotter/audioplayers/blob/master/lib/audioplayers.dart


class AudioPlayerWeb extends AudioPlayerPlatform{
  
  static void registerWith(Registrar registrar) {
    AudioPlayerPlatform.instance = AudioPlayerWeb();
  }
  /// Reference [Map] with all the players created by the application.
  ///
  /// This is used to exchange messages with the [MethodChannel]
  /// (there is only one).
  
  /// Enables more verbose logging.

  Map<int, _AudioPlayer> _audioPlayers = <int, _AudioPlayer>{};
  int _textureCounter = 1;

  AudioPlayerState _audioPlayerState;

  AudioPlayerState get state => _audioPlayerState;

  @override
  Future<void> init() async {
    return _disposeAllPlayers();
  }

  @override
  Future<void> dispose(int textureId) async {
    _audioPlayers[textureId].dispose();
    _audioPlayers.remove(textureId);
    return null;
  }
  void _disposeAllPlayers() {
    _audioPlayers.values
        .forEach((_AudioPlayer videoPlayer) => videoPlayer.dispose());
    _audioPlayers.clear();
  }
  @override
  Future<int> create(DataSource dataSource) async {
    final int textureId = _textureCounter;
    _textureCounter++;

    Uri uri;
    switch (dataSource.sourceType) {
      case DataSourceType.network:
        uri = Uri.parse(dataSource.uri);
        break;
      case DataSourceType.asset:
        String assetUrl = dataSource.asset;
        if (dataSource.package != null && dataSource.package.isNotEmpty) {
          assetUrl = 'packages/${dataSource.package}/$assetUrl';
        }
        // 'webOnlyAssetManager' is only in the web version of dart:ui
        // ignore: undefined_prefixed_name
        assetUrl = ui.webOnlyAssetManager.getAssetUrl(assetUrl);
        uri = Uri.parse(assetUrl);
        break;
      case DataSourceType.file:
        return Future.error(UnimplementedError(
            'web implementation of video_player cannot play local files'));
    }

    final _AudioPlayer player = _AudioPlayer(
      uri: uri,
      textureId: textureId,
    );

    player.initialize();

    _audioPlayers[textureId] = player;
    return textureId;
  }
    @override
  Future<void> setLooping(int textureId, bool looping) async {
    return _audioPlayers[textureId].setLooping(looping);
  }
  @override
  Stream<AudioEvent> audioEventsFor(int textureId) {
    return _audioPlayers[textureId].eventController.stream;
  }

  @override
  Widget buildView(int textureId) {
    return HtmlElementView(viewType: 'audioPlayer-$textureId');
  }

  @override
  Future<void> play(int textureId,
  // String url, {
  //   bool isLocal = false,
  //   double volume = 1.0,
  //   // position must be null by default to be compatible with radio streams
  //   Duration position,
  //   bool respectSilence = false,
  //   bool stayAwake = false,}
    ) async {
    return _audioPlayers[textureId].play();
  }

  @override
  Future<void> pause(int textureId) async {
    return _audioPlayers[textureId].pause();
  }

  @override
  Future<void> setVolume(int textureId, double volume) async {
    return _audioPlayers[textureId].setVolume(volume);
  }

  @override
  Future<void> seekTo(int textureId, Duration position) async {
    return _audioPlayers[textureId].seekTo(position);
  }

  @override
  Future<Duration> getPosition(int textureId) async {
    _audioPlayers[textureId].sendBufferingUpdate();
    return _audioPlayers[textureId].getPosition();
  }
}



class _AudioPlayer {
  _AudioPlayer({this.uri, this.textureId});

  final StreamController<AudioEvent> eventController =
      StreamController<AudioEvent>();

  final Uri uri;
  final int textureId;
  AudioElement audioElement;
  bool isInitialized = false;

  void initialize() {
    audioElement = AudioElement()
      ..src = uri.toString()
      ..autoplay = false
      ..controls = false
      ..style.border = 'none';

    // TODO(hterkelsen): Use initialization parameters once they are available
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        'audioPlayer-$textureId', (int viewId) => audioElement);

    audioElement.onCanPlay.listen((dynamic _) {
      if (!isInitialized) {
        isInitialized = true;
        sendInitialized();
      }
    });
    audioElement.onError.listen((dynamic error) {
      eventController.addError(error);
    });
    audioElement.onEnded.listen((dynamic _) {
      eventController.add(AudioEvent(eventType: AudioEventType.completed));
    });
  }

  void sendBufferingUpdate() {
    eventController.add(AudioEvent(
      buffered: _toDurationRange(audioElement.buffered),
      eventType: AudioEventType.bufferingUpdate,
    ));
  }

  void play() {
    audioElement.play();
  }

  void pause() {
    audioElement.pause();
  }

  void setLooping(bool value) {
    audioElement.loop = value;
  }

  void setVolume(double value) {
    audioElement.volume = value;
  }

  void seekTo(Duration position) {
    audioElement.currentTime = position.inMilliseconds.toDouble() / 1000;
  }

  Duration getPosition() {
    return Duration(milliseconds: (audioElement.currentTime * 1000).round());
  }


  void sendInitialized() {
    eventController.add(
      AudioEvent(
        eventType: AudioEventType.initialized,
        duration: Duration(
          milliseconds: (audioElement.duration * 1000).round(),
        ),
      
      ),
    );
  }

  void dispose() {
    audioElement.removeAttribute('src');
    audioElement.load();
  }

  List<DurationRange> _toDurationRange(TimeRanges buffered) {
    final List<DurationRange> durationRange = <DurationRange>[];
    for (int i = 0; i < buffered.length; i++) {
      durationRange.add(DurationRange(
        Duration(milliseconds: (buffered.start(i) * 1000).round()),
        Duration(milliseconds: (buffered.end(i) * 1000).round()),
      ));
    }
    return durationRange;
  }
}