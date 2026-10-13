import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:e_modul_etnosains/shared/services/app_audio_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAudioPlayer implements AudioPlayer {
  bool playing = false;
  bool disposed = false;
  int resumes = 0;
  Completer<void>? loading;

  @override
  Stream<PlayerState> get onPlayerStateChanged => const Stream.empty();
  @override
  Future<void> setReleaseMode(ReleaseMode mode) async {}
  @override
  Future<void> setVolume(double volume) async {}
  @override
  Future<void> setSource(Source source) async {
    await loading?.future;
  }

  @override
  Future<void> pause() async => playing = false;
  @override
  Future<void> resume() async {
    resumes++;
    playing = true;
  }

  @override
  Future<void> dispose() async {
    disposed = true;
    playing = false;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> flushAudio() => Future<void>.delayed(Duration.zero);

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  late FakeAudioPlayer player;
  late BackgroundAudioNotifier notifier;

  setUp(() async {
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    player = FakeAudioPlayer();
    notifier = BackgroundAudioNotifier(null, player: player);
    await flushAudio();
  });
  tearDown(() async {
    if (!player.disposed) notifier.dispose();
    await flushAudio();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  });

  test('background and detached states pause; returning resumes', () async {
    expect(player.playing, isTrue);
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.detached,
    ]) {
      binding.handleAppLifecycleStateChanged(state);
      await flushAudio();
      expect(player.playing, isFalse, reason: state.name);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await flushAudio();
      expect(player.playing, isTrue);
    }
  });

  test('manual pause and mute survive leaving and returning', () async {
    await notifier.pause();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await flushAudio();
    expect(player.playing, isFalse);
    await notifier.resume();
    await notifier.setMuted(true);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await flushAudio();
    expect(player.playing, isFalse);
    expect(notifier.state.isMuted, isTrue);
  });

  test('video ending in background does not resume music until foreground',
      () async {
    await notifier.pauseForMedia();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await notifier.resumeFromMedia();
    expect(player.playing, isFalse);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await flushAudio();
    expect(player.playing, isTrue);
  });

  test('returning while video is active keeps music paused', () async {
    await notifier.pauseForMedia();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await flushAudio();
    expect(player.playing, isFalse);
    await notifier.resumeFromMedia();
    expect(player.playing, isTrue);
  });

  test('leaving while asset loads never starts background playback', () async {
    notifier.dispose();
    await flushAudio();
    player = FakeAudioPlayer()..loading = Completer<void>();
    notifier = BackgroundAudioNotifier(null, player: player);
    await flushAudio();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    player.loading!.complete();
    await flushAudio();
    expect(player.resumes, 0);
    expect(player.playing, isFalse);
  });

  test('dispose during asset loading prevents late playback', () async {
    notifier.dispose();
    await flushAudio();
    player = FakeAudioPlayer()..loading = Completer<void>();
    notifier = BackgroundAudioNotifier(null, player: player);
    await flushAudio();
    notifier.dispose();
    player.loading!.complete();
    await flushAudio();
    expect(player.resumes, 0);
    expect(player.disposed, isTrue);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await flushAudio();
    expect(player.playing, isFalse);
  });
}
