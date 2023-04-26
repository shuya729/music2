import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/userdata_model.dart';
import '../../providers/favorite_sounds_provider.dart';
import '../../models/sound.dart';
import '../../providers/audio_system_providers.dart';
import '../../providers/current_user_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/selected_user_provider.dart';

class NowPlayingPage extends ConsumerWidget {
  const NowPlayingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final audioPlayerState = ref.watch(audioPlayerStateProvider);
    final audioPlayer = ref.watch(audioPlayerProvider);
    final currentSound = ref.watch(currentSoundProvider);
    final favoriteSoundState = ref.watch(favoriteSoundStateProvider);
    final favoriteSoundStateNotifier =
        ref.watch(favoriteSoundStateProvider.notifier);

    return (currentSound != Sound.emputy)
        ? Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 80,
                  color: Theme.of(context).colorScheme.onPrimary,
                  margin: const EdgeInsets.only(top: 10),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      currentSound.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSound.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          ref
                              .watch(selectedUserDataProvider.notifier)
                              .setSelecteUser(currentSound.posterId);
                          ref.read(navigationProvider.notifier).select(5);
                        },
                        child: Text(
                          currentSound.posterName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ProgressBar(
                        progress: audioPlayerState.position,
                        total: audioPlayerState.duration,
                        onSeek: (position) {
                          audioPlayer.seek(position);
                        },
                        baseBarColor: Theme.of(context)
                            .colorScheme
                            .error
                            .withOpacity(0.7),
                        progressBarColor: Theme.of(context).colorScheme.surface,
                        thumbColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (audioPlayer.loopMode == LoopMode.all) {
                          audioPlayer.setLoopMode(LoopMode.off);
                        } else if (audioPlayer.loopMode == LoopMode.off) {
                          audioPlayer.setLoopMode(LoopMode.all);
                        }
                      },
                      icon: (audioPlayerState.loopMode == LoopMode.all)
                          ? Icon(
                              Icons.repeat,
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          : Icon(
                              Icons.repeat,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (audioPlayerState.position == Duration.zero) {
                          audioPlayer.seekToPrevious();
                        } else {
                          audioPlayer.seek(Duration.zero);
                        }
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    IconButton(
                      onPressed: () {
                        if (audioPlayerState.isPlaying) {
                          audioPlayer.pause();
                        } else {
                          audioPlayer.play();
                        }
                      },
                      icon: Icon(audioPlayerState.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                    ),
                    IconButton(
                      onPressed: () {
                        audioPlayer.seekToNext();
                      },
                      icon: const Icon(Icons.skip_next),
                    ),
                    (currentUser != Userdata.emputy)
                        ? IconButton(
                            onPressed: () {
                              favoriteSoundStateNotifier.changeFavoriteState();
                            },
                            icon: (favoriteSoundState)
                                ? Icon(
                                    Icons.favorite,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  )
                                : Icon(
                                    Icons.favorite,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                          )
                        : const CircularProgressIndicator(),
                  ],
                ),
                const Spacer(),
              ],
            ),
          )
        : const CircularProgressIndicator();
  }
}
