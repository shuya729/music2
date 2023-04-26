import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/sound.dart';
import '../../providers/audio_system_providers.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/providers.dart';
import '../../providers/selected_user_provider.dart';

class NowPlayingBar extends ConsumerWidget {
  const NowPlayingBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSound = ref.watch(currentSoundProvider);
    final audioPlayer = ref.watch(audioPlayerProvider);
    final audioPlayerState = ref.watch(audioPlayerStateProvider);

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
      ),
      height: ref.watch(isExpandedProvider) ? null : 60.0,
      child: (currentSound != Sound.emputy)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  margin: const EdgeInsets.only(left: 5),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                      currentSound.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        currentSound.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
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
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (audioPlayerState.isPlaying) {
                      audioPlayer.pause();
                    } else {
                      audioPlayer.play();
                    }
                  },
                  icon: Icon(
                    audioPlayerState.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                ),
              ],
            )
          : const SizedBox(
              height: 60,
              child: LinearProgressIndicator(),
            ),
    );
  }
}
