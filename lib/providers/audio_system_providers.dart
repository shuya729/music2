import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../models/audio_player_state.dart';
import '../models/sound.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());

final concatPlaylistProvider = StateProvider<ConcatenatingAudioSource>((ref) {
  return ConcatenatingAudioSource(children: []);
});

final currentSoundProvider = Provider<Sound>((ref) {
  final currentIndex = ref.watch(audioPlayerStateProvider).currentIndex;
  final soundList = ref.watch(currentSoundListProvider);
  if (soundList.isNotEmpty) {
    return soundList[currentIndex];
  } else {
    return Sound.emputy;
  }
});

final currentSoundListProvider =
    StateNotifierProvider<CurrentSoundListNotifier, List<Sound>>(
        (ref) => CurrentSoundListNotifier(
              ref.watch(audioPlayerProvider),
              ref.watch(concatPlaylistProvider),
            ));

class CurrentSoundListNotifier extends StateNotifier<List<Sound>> {
  final AudioPlayer audioPlayer;
  final ConcatenatingAudioSource concatPlaylist;
  CurrentSoundListNotifier(this.audioPlayer, this.concatPlaylist,
      [List<Sound>? initialSounds])
      : super(initialSounds ?? []);

  Future<void> addSound(Sound sound) async {
    await concatPlaylist
        .add(AudioSource.uri(Uri.parse(sound.soundUrl)))
        .whenComplete(() {
      state = [...state, sound];
    });
  }

  Future<void> removeSound(Sound sound) async {
    await concatPlaylist.removeAt(state.indexOf(sound)).whenComplete(() {
      state = state.where((item) => item.soundId != sound.soundId).toList();
    });
  }

  Future<void> clear() async {
    await concatPlaylist.clear().whenComplete(() {
      state = [];
    });
  }

  Future<void> updateSounds(List<Sound> sounds) async {
    await concatPlaylist.clear().whenComplete(() async {
      final audioSources = sounds
          .map((sound) => AudioSource.uri(Uri.parse(sound.soundUrl)))
          .toList();
      await concatPlaylist.addAll(audioSources).whenComplete(() {
        state = sounds;
      });
    });
  }
}

final audioPlayerStateProvider =
    StateNotifierProvider<AudioPlayerStateNotifier, AudioPlayerState>((ref) {
  final playlistState = ref.watch(audioPlayerProvider);
  return AudioPlayerStateNotifier(playlistState);
});

class AudioPlayerStateNotifier extends StateNotifier<AudioPlayerState> {
  final AudioPlayer audioPlayer;
  late StreamSubscription<int?> _currentIndexSubscription;
  late StreamSubscription<bool> _playingSubscription;
  late StreamSubscription<LoopMode> _loopModeSubscription;
  late StreamSubscription<Duration?> _durationSubscription;
  late StreamSubscription<Duration> _positionSubscription;

  AudioPlayerStateNotifier(this.audioPlayer)
      : super(AudioPlayerState.initial()) {
    _currentIndexSubscription =
        audioPlayer.currentIndexStream.listen((currentIndex) {
      state = state.copyWith(currentIndex: currentIndex);
    });
    _playingSubscription = audioPlayer.playingStream.listen((isPlaying) {
      state = state.copyWith(isPlaying: isPlaying);
    });
    _loopModeSubscription = audioPlayer.loopModeStream.listen((loopMode) {
      state = state.copyWith(loopMode: loopMode);
    });
    _durationSubscription = audioPlayer.durationStream.listen((duration) {
      state = state.copyWith(duration: duration);
    });
    _positionSubscription = audioPlayer.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });
  }

  @override
  void dispose() {
    _currentIndexSubscription.cancel();
    _playingSubscription.cancel();
    _loopModeSubscription.cancel();
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    super.dispose();
  }
}
