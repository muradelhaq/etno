import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
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

class BackgroundAudioNotifier extends StateNotifier<BackgroundAudioState>
    with WidgetsBindingObserver {
  final SharedPreferences? _prefs;
  final AudioPlayer _player;
  StreamSubscription<PlayerState>? _playerSubscription;
  Future<void> _pending = Future.value();
  bool _isAudioLoaded = false;
  bool _wantsPlayback = true;
  bool _mediaActive = false;
  bool _isForeground = false;
  bool _disposed = false;

  BackgroundAudioNotifier(this._prefs, {AudioPlayer? player})
      : _player = player ?? AudioPlayer(),
        super(BackgroundAudioState(
          isPlaying: false,
          isMuted: _prefs?.getBool('bg_audio_muted') ?? false,
          volume: _prefs?.getDouble('bg_audio_volume') ?? 0.35,
        )) {
    final binding = WidgetsBinding.instance;
    _isForeground = binding.lifecycleState == AppLifecycleState.resumed;
    binding.addObserver(this);
    _playerSubscription = _player.onPlayerStateChanged.listen((playerState) {
      if (!_disposed) {
        state = state.copyWith(
          isPlaying: playerState == PlayerState.playing && _shouldPlay,
        );
      }
    });
    unawaited(_syncPlayback());
  }

  bool get _shouldPlay =>
      !_disposed &&
      _isForeground &&
      _wantsPlayback &&
      !_mediaActive &&
      !state.isMuted;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isForeground = state == AppLifecycleState.resumed;
    unawaited(_syncPlayback());
  }

  // Serialize commands and re-check lifecycle after asynchronous asset loading.
  Future<void> _syncPlayback() {
    _pending = _pending.then((_) async {
      if (_disposed) return;
      try {
        if (!_shouldPlay) {
          await _player.pause();
          if (!_disposed) state = state.copyWith(isPlaying: false);
          return;
        }
        await _player.setReleaseMode(ReleaseMode.loop);
        if (!_shouldPlay) return;
        await _player.setVolume(state.volume);
        if (!_shouldPlay) return;
        if (!_isAudioLoaded) {
          await _player.setSource(
            AssetSource('audio/ssstik.io_1787630984112.mp3'),
          );
          _isAudioLoaded = true;
        }
        if (!_shouldPlay) return;
        await _player.resume();
        if (!_shouldPlay) {
          await _player.pause();
        }
        if (!_disposed) state = state.copyWith(isPlaying: _shouldPlay);
      } catch (e) {
        if (!_disposed) state = state.copyWith(isPlaying: false);
        debugPrint('Background audio error: $e');
      }
    });
    return _pending;
  }

  Future<void> startMusic() => resume();

  Future<void> togglePlay() => state.isPlaying ? pause() : resume();

  Future<void> pause() {
    _wantsPlayback = false;
    return _syncPlayback();
  }

  Future<void> resume() {
    _wantsPlayback = true;
    if (state.isMuted) {
      state = state.copyWith(isMuted: false);
      _prefs?.setBool('bg_audio_muted', false);
    }
    return _syncPlayback();
  }

  /// Video and lifecycle pauses preserve the user's playback preference.
  Future<void> pauseForMedia() {
    _mediaActive = true;
    return _syncPlayback();
  }

  Future<void> resumeFromMedia() {
    _mediaActive = false;
    return _syncPlayback();
  }

  Future<void> setMuted(bool muted) {
    state = state.copyWith(isMuted: muted);
    _prefs?.setBool('bg_audio_muted', muted);
    if (!muted) _wantsPlayback = true;
    return _syncPlayback();
  }

  Future<void> setVolume(double volume) {
    final clamped = volume.clamp(0.0, 1.0);
    state = state.copyWith(volume: clamped);
    _prefs?.setDouble('bg_audio_volume', clamped);
    return _syncPlayback();
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_playerSubscription?.cancel());
    unawaited(_pending.then((_) => _player.dispose()).catchError((Object e) {
      debugPrint('Background audio dispose error: $e');
    }));
    super.dispose();
  }
}

final backgroundAudioProvider =
    StateNotifierProvider<BackgroundAudioNotifier, BackgroundAudioState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BackgroundAudioNotifier(prefs);
});
