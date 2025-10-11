import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _player = AudioPlayer();
  String? _currentTrackId;

  void init(Function onComplete) {
    _player.onPlayerComplete.listen((_) {
      _currentTrackId = null;
      onComplete();
    });
  }

  String? get currentTrackId => _currentTrackId;

  Future<void> play(String trackId, String url) async {
    if (_currentTrackId != null && _currentTrackId != trackId) {
      await _player.stop();
    }
    _currentTrackId = trackId;
    await _player.play(UrlSource(url));
  }

  Future<void> stop() async {
    await _player.stop();
    _currentTrackId = null;
  }

  bool isPlaying(String trackId) => _currentTrackId == trackId;
}
