import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_storage_service.dart';

class BackgroundAudioState {
  final bool isPlaying;
  final bool isMuted;
  final double volume; // 0.0 to 1.0

  const BackgroundAudioState({
    this.isPlaying = true,
    this.isMuted = false,
    this.volume = 0.50,
  });

  BackgroundAudioState copyWith({
    bool? isPlaying,
    bool? isMuted,
    double? volume,
  }) {
    return BackgroundAudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
      volume: volume ?? this.volume,
    );
  }
}

class BackgroundAudioNotifier extends StateNotifier<BackgroundAudioState> {
  final SharedPreferences? _prefs;
  final AudioPlayer _player = AudioPlayer();
  bool _isAudioLoaded = false;

  BackgroundAudioNotifier(this._prefs) : super(const BackgroundAudioState()) {
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      final savedMuted = _prefs?.getBool('bg_audio_muted') ?? false;
      final savedVolume = _prefs?.getDouble('bg_audio_volume') ?? 0.35;
      state = state.copyWith(isMuted: savedMuted, volume: savedVolume);

      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(savedMuted ? 0.0 : savedVolume);

      // Listen to player state changes
      _player.onPlayerStateChanged.listen((pState) {
        state = state.copyWith(isPlaying: pState == PlayerState.playing);
      });

      if (!savedMuted) {
        await startMusic();
      }
    } catch (e) {
      debugPrint('Background audio init error: $e');
    }
  }

  Future<void> startMusic() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(state.isMuted ? 0.0 : state.volume);
      await _player.play(AssetSource('audio/ssstik.io_1787630984112.mp3'));
      _isAudioLoaded = true;
      state = state.copyWith(isPlaying: true);
    } catch (e) {
      debugPrint('Error playing background audio: $e');
    }
  }

  Future<void> togglePlay() async {
    if (state.isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
      state = state.copyWith(isPlaying: false);
    } catch (e) {
      debugPrint('Audio pause error: $e');
    }
  }

  bool _wasPlayingBeforeMedia = false;

  /// Temporarily pauses background audio for video playback without resetting user preferences
  Future<void> pauseForMedia() async {
    if (state.isPlaying && !state.isMuted) {
      _wasPlayingBeforeMedia = true;
      await pause();
    }
  }

  /// Resumes background audio when video finishes or stops playing
  Future<void> resumeFromMedia() async {
    if (_wasPlayingBeforeMedia && !state.isMuted) {
      _wasPlayingBeforeMedia = false;
      await resume();
    }
  }

  Future<void> resume() async {
    try {
      if (state.isMuted) {
        await setMuted(false);
      }
      if (!_isAudioLoaded) {
        await startMusic();
      } else {
        await _player.resume();
        state = state.copyWith(isPlaying: true);
      }
    } catch (e) {
      await startMusic();
    }
  }

  Future<void> setMuted(bool muted) async {
    state = state.copyWith(isMuted: muted);
    _prefs?.setBool('bg_audio_muted', muted);
    try {
      await _player.setVolume(muted ? 0.0 : state.volume);
      if (muted) {
        await _player.pause();
        state = state.copyWith(isPlaying: false);
      } else {
        await resume();
      }
    } catch (e) {
      debugPrint('Audio mute error: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    final clamped = volume.clamp(0.0, 1.0);
    state = state.copyWith(volume: clamped);
    _prefs?.setDouble('bg_audio_volume', clamped);
    try {
      if (!state.isMuted) {
        await _player.setVolume(clamped);
      }
    } catch (e) {
      debugPrint('Audio setVolume error: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

final backgroundAudioProvider =
    StateNotifierProvider<BackgroundAudioNotifier, BackgroundAudioState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BackgroundAudioNotifier(prefs);
});
