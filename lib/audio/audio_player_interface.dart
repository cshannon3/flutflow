import 'dart:async';
import 'dart:io';

import 'package:flutflow/audio/audio_player_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

// Required for PluginUtilities.
import 'dart:ui';
import 'package:flutter/material.dart';
//https://github.com/luanpotter/audioplayers/blob/master/lib/audioplayers.dart


/// This represents a single AudioPlayer, which can play one audio at a time.
/// To play several audios at the same time, you must create several instances
/// of this class.
///
/// It holds methods to play, loop, pause, stop, seek the audio, and some useful
/// hooks for handlers and callbacks.
abstract class AudioPlayerPlatform {

  static AudioPlayerPlatform _instance = AudioPlayerWeb();

  /// The default instance of [VideoPlayerPlatform] to use.
  ///
  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [VideoPlayerPlatform] when they
  /// register themselves.
  ///
  /// Defaults to [MethodChannelVideoPlayer].
  static AudioPlayerPlatform get instance => _instance;
  static set instance(AudioPlayerPlatform instance) {
    
      try {
        instance._verifyProvidesDefaultImplementations();
      } on NoSuchMethodError catch (_) {
        throw AssertionError(
            'Platform interfaces must not be implemented with `implements`');
      
    }
    _instance = instance;
  }
    // This method makes sure that VideoPlayer isn't implemented with `implements`.
  //
  // See class doc for more details on why implementing this class is forbidden.
  //
  // This private method is called by the instance setter, which fails if the class is
  // implemented with `implements`.
   void _verifyProvidesDefaultImplementations() {}

  /// An unique ID generated for this instance of [AudioPlayer].
  ///
  /// This is used to properly exchange messages with the [MethodChannel].
  String playerId;

  /// Current mode of the audio player. Can be updated at any time, but is going
  /// to take effect only at the next time you play the audio.
  PlayerMode mode;

  /// Creates a new instance and assigns an unique id to it.
  Future<void> init() {
    throw UnimplementedError('init() has not been implemented.');
  }
  /// Plays an audio.
  ///
  /// If [isLocal] is true, [url] must be a local file system path.
  /// If [isLocal] is false, [url] must be a remote URL.
  
  
  Future<void> play(int textureId,
    // String url, {
    // bool isLocal = false,
    // double volume = 1.0,
    // // position must be null by default to be compatible with radio streams
    // Duration position,
    // bool respectSilence = false,
    // bool stayAwake = false, }
    ) async {
    throw UnimplementedError('play() has not been implemented.');
  }
  /// Pauses the audio that is currently playing.
  ///
  /// If you call [resume] later, the audio will resume from the point that it
  /// has been paused.
  Future<void> pause(int textureId) async {
    throw UnimplementedError('pause() has not been implemented.');
  }
  /// Stops the audio that is currently playing.
  ///
  /// The position is going to be reset and you will no longer be able to resume
  /// from the last point.
  Future<int> stop() async {
    throw UnimplementedError('pause() has not been implemented.');
  }
   Future<void> setLooping(int textureId, bool looping) async {
    throw UnimplementedError('setLooping() has not been implemented.');
  }

  /// Resumes the audio that has been paused or stopped, just like calling
  /// [play], but without changing the parameters.
  Future<int> resume() async {
   throw UnimplementedError('resume() has not been implemented.');
  }
  /// Releases the resources associated with this media player.
  ///
  /// The resources are going to be fetched or buffered again as soon as you
  /// call [play] or [setUrl].
  Future<int> release() async {
    throw UnimplementedError('release() has not been implemented.');
  }

  /// Moves the cursor to the desired position.
  Future<void> seekTo(int textureId,Duration position) {
     throw UnimplementedError('seekTo() has not been implemented.');
  }

  /// Sets the volume (amplitude).
  ///
  /// 0 is mute and 1 is the max volume. The values between 0 and 1 are linearly
  /// interpolated.
  Future<void> setVolume(int textureId,double volume) {
    throw UnimplementedError('setVolume() has not been implemented.');
  }

  /// Sets the release mode.
  ///
  /// Check [ReleaseMode]'s doc to understand the difference between the modes.
  Future<int> setReleaseMode(ReleaseMode releaseMode) {
    throw UnimplementedError('setReleaseMode() has not been implemented.');
  }

  /// Sets the playback rate - call this after first calling play() or resume(). Works only on iOS for now
  ///
  /// iOS has limits between 0.5 and 2x
  /// not sure if that's changed recently.
  Future<int> setPlaybackRate({double playbackRate = 1.0}) {
    throw UnimplementedError('setPlaybackRate() has not been implemented.');
  }

  /// Sets the notification bar for lock screen and notification area in iOS for now.
  ///
  /// Specify atleast title
  Future<dynamic> setNotification(
      {String title,
      String albumTitle = '',
      String artist = '',
      String imageUrl = '',
      Duration forwardSkipInterval = const Duration(seconds: 30),
      Duration backwardSkipInterval = const Duration(seconds: 30),
      Duration duration,
      Duration elapsedTime}) {
        throw UnimplementedError('setNotifications() has not been implemented.');
  }

  /// Sets the URL.
  ///
  /// Unlike [play], the playback will not resume.
  ///
  /// The resources will start being fetched or buffered as soon as you call
  /// this method.
  Future<int> setUrl(String url,
      {bool isLocal: false, bool respectSilence = false}) {
        throw UnimplementedError('setUrl() has not been implemented.');
  }
   Stream<AudioEvent> audioEventsFor(int textureId) {
    throw UnimplementedError('videoEventsFor() has not been implemented.');
  }

  /// Get audio duration after setting url.
  /// Use it in conjunction with setUrl.
  ///
  /// It will be available as soon as the audio duration is available
  /// (it might take a while to download or buffer it if file is not local).
  Future<int> getDuration() {
    throw UnimplementedError('getDuration() has not been implemented.');
  }

  // Gets audio current playing position
  Future<Duration> getPosition(int textureId) async {
    throw UnimplementedError('getCurrentPosition() has not been implemented.');
  }

  static Future<void> platformCallHandler(MethodCall call) async {
    try {
      _doHandlePlatformCall(call);
    } catch (ex) {
      print('Unexpected error: $ex');
    }
  }

  static Future<void> _doHandlePlatformCall(MethodCall call) async {
    throw UnimplementedError('_doHandlePlatformCall() has not been implemented.');
 
  }
  Future<void> dispose(int textureId) {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  /// Creates an instance of a video player and returns its textureId.
  Future<int> create(DataSource dataSource) {
    throw UnimplementedError('create() has not been implemented.');
  }


}



enum AudioEventType {
  /// The video has been initialized.
  initialized,

  /// The playback has ended.
  completed,

  /// Updated information on the buffering state.
  bufferingUpdate,

  /// The video started to buffer.
  bufferingStart,

  /// The video stopped to buffer.
  bufferingEnd,

  /// An unknown event has been received.
  unknown,
}
class AudioEvent {
  /// Creates an instance of [VideoEvent].
  ///
  /// The [eventType] argument is required.
  ///
  /// Depending on the [eventType], the [duration], [size] and [buffered]
  /// arguments can be null.
  AudioEvent({
    @required this.eventType,
    this.duration,
    this.size,
    this.buffered,
  });

  /// The type of the event.
  final AudioEventType eventType;

  /// Duration of the video.
  ///
  /// Only used if [eventType] is [VideoEventType.initialized].
  final Duration duration;
  final Size size;
  /// Size of the video.
  ///
  /// Only used if [eventType] is [VideoEventType.initialized].
 // final Size size;

  /// Buffered parts of the video.
  ///
  /// Only used if [eventType] is [VideoEventType.bufferingUpdate].
  final List<DurationRange> buffered;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AudioEvent &&
            runtimeType == other.runtimeType &&
            eventType == other.eventType &&
            duration == other.duration &&
          //  size == other.size &&
            listEquals(buffered, other.buffered);
  }

  @override
  int get hashCode =>
      eventType.hashCode ^
      duration.hashCode ^
     // size.hashCode ^
      buffered.hashCode;
}

/// This enum is meant to be used as a parameter of the [AudioPlayer]'s
/// constructor. It represents the general mode of the [AudioPlayer].
///



class DurationRange {
  /// Trusts that the given [start] and [end] are actually in order. They should
  /// both be non-null.
  DurationRange(this.start, this.end);

  /// The beginning of the segment described relative to the beginning of the
  /// entire video. Should be shorter than or equal to [end].
  ///
  /// For example, if the entire video is 4 minutes long and the range is from
  /// 1:00-2:00, this should be a `Duration` of one minute.
  final Duration start;

  /// The end of the segment described as a duration relative to the beginning of
  /// the entire video. This is expected to be non-null and longer than or equal
  /// to [start].
  ///
  /// For example, if the entire video is 4 minutes long and the range is from
  /// 1:00-2:00, this should be a `Duration` of two minutes.
  final Duration end;

  /// Assumes that [duration] is the total length of the video that this
  /// DurationRange is a segment form. It returns the percentage that [start] is
  /// through the entire video.
  ///
  /// For example, assume that the entire video is 4 minutes long. If [start] has
  /// a duration of one minute, this will return `0.25` since the DurationRange
  /// starts 25% of the way through the video's total length.
  double startFraction(Duration duration) {
    return start.inMilliseconds / duration.inMilliseconds;
  }

  /// Assumes that [duration] is the total length of the video that this
  /// DurationRange is a segment form. It returns the percentage that [start] is
  /// through the entire video.
  ///
  /// For example, assume that the entire video is 4 minutes long. If [end] has a
  /// duration of two minutes, this will return `0.5` since the DurationRange
  /// ends 50% of the way through the video's total length.
  double endFraction(Duration duration) {
    return end.inMilliseconds / duration.inMilliseconds;
  }

  @override
  String toString() => '$runtimeType(start: $start, end: $end)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DurationRange &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}


/// the video player.
class DataSource {
  /// Constructs an instance of [DataSource].
  ///
  /// The [sourceType] is always required.
  ///
  /// The [uri] argument takes the form of `'https://example.com/video.mp4'` or
  /// `'file://${file.path}'`.
  ///
  /// The [formatHint] argument can be null.
  ///
  /// The [asset] argument takes the form of `'assets/video.mp4'`.
  ///
  /// The [package] argument must be non-null when the asset comes from a
  /// package and null otherwise.
  DataSource({
    @required this.sourceType,
    this.uri,
    this.formatHint,
    this.asset,
    this.package,
  });

  /// The way in which the video was originally loaded.
  ///
  /// This has nothing to do with the video's file type. It's just the place
  /// from which the video is fetched from.
  final DataSourceType sourceType;

  /// The URI to the video file.
  ///
  /// This will be in different formats depending on the [DataSourceType] of
  /// the original video.
  final String uri;

  /// **Android only**. Will override the platform's generic file format
  /// detection with whatever is set here.
  final VideoFormat formatHint;

  /// The name of the asset. Only set for [DataSourceType.asset] videos.
  final String asset;

  /// The package that the asset was loaded from. Only set for
  /// [DataSourceType.asset] videos.
  final String package;
}

/// The way in which the video was originally loaded.
///
/// This has nothing to do with the video's file type. It's just the place
/// from which the video is fetched from.
enum DataSourceType {
  /// The video was included in the app's asset files.
  asset,

  /// The video was downloaded from the internet.
  network,

  /// The video was loaded off of the local filesystem.
  file
}

/// The file format of the given video.
enum VideoFormat {
  /// Dynamic Adaptive Streaming over HTTP, also known as MPEG-DASH.
  dash,

  /// HTTP Live Streaming.
  hls,

  /// Smooth Streaming.
  ss,

  /// Any format other than the other ones defined in this enum.
  other
}


enum ReleaseMode {
  /// Releases all resources, just like calling [release] method.
  ///
  /// In Android, the media player is quite resource-intensive, and this will
  /// let it go. Data will be buffered again when needed (if it's a remote file,
  /// it will be downloaded again).
  /// In iOS, works just like [stop] method.
  ///
  /// This is the default behaviour.
  RELEASE,

  /// Keeps buffered data and plays again after completion, creating a loop.
  /// Notice that calling [stop] method is not enough to release the resources
  /// when this mode is being used.
  LOOP,

  /// Stops audio playback but keep all resources intact.
  /// Use this if you intend to play again later.
  STOP
}
// In iOS, both modes have the same backend implementation.
enum PlayerMode {
  /// Ideal for long media files or streams.
  MEDIA_PLAYER,

  LOW_LATENCY
}
/// Self explanatory. Indicates the state of the audio player.
enum AudioPlayerState {
  STOPPED,
  PLAYING,
  PAUSED,
  COMPLETED,
}