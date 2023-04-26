import 'package:just_audio/just_audio.dart';

class AudioPlayerState {
  final int currentIndex;
  final bool isPlaying;
  final LoopMode loopMode;
  final Duration duration;
  final Duration position;

  const AudioPlayerState({
    required this.currentIndex,
    required this.isPlaying,
    required this.loopMode,
    required this.duration,
    required this.position,
  });

  factory AudioPlayerState.initial() => const AudioPlayerState(
        currentIndex: 0,
        isPlaying: false,
        loopMode: LoopMode.off,
        duration: Duration.zero,
        position: Duration.zero,
      );

  AudioPlayerState copyWith({
    int? currentIndex,
    bool? isPlaying,
    LoopMode? loopMode,
    Duration? duration,
    Duration? position,
  }) {
    return AudioPlayerState(
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      loopMode: loopMode ?? this.loopMode,
      duration: duration ?? this.duration,
      position: position ?? this.position,
    );
  }
}
