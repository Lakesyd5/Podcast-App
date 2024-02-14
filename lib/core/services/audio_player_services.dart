import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast_search/podcast_search.dart';

final audioPlayerServiceProvider =
    ChangeNotifierProvider<AudioPlayerNotifier>((ref) => AudioPlayerNotifier());

class AudioPlayerNotifier extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  String? _currentUrl;
  double _progress = 0.0;

  double get progress => _progress;
  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> play(Episode episode) async {
    if (_currentUrl != episode.contentUrl) {
      _currentUrl = episode.contentUrl;

      final audioSource = AudioSource.uri(
        Uri.parse(episode.contentUrl!),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: Key(episode.guid).toString(),
          // Metadata to display in the notification:
          album: episode.title,
          title: episode.title,
          artUri: Uri.parse(episode.imageUrl ??
              'https://icon-library.com/images/found-icon/found-icon-20.jpg'),
        ),
      );

      await _audioPlayer.setAudioSource(audioSource);
    }

    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Stream<Duration?> get positionStream => _audioPlayer.positionStream;

  AudioPlayerNotifier() {
    _audioPlayer.positionStream.listen((position) {
      final currentPosition = position.inMilliseconds.toDouble();
      final totalDuration = _audioPlayer.duration?.inMilliseconds.toDouble() ?? 0.0;

      if (totalDuration > 0 && currentPosition.isFinite && totalDuration.isFinite) {
        _progress = currentPosition / totalDuration;
        notifyListeners();
      }
    });
  }
}
