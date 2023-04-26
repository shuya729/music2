import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/audio_system_providers.dart';
import '../../models/sound.dart';
import '../../providers/favorite_sounds_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/selected_user_provider.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  @override
  void initState() {
    super.initState();
    ref.read(favoriteSoundsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final favoriteSoundsAsyncValue = ref.watch(favoriteSoundsProvider);
    final currentSoundListNotifier =
        ref.watch(currentSoundListProvider.notifier);
    final audioPlayer = ref.watch(audioPlayerProvider);
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Favorite Sounds',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: favoriteSoundsAsyncValue.when(
              data: (favoriteSounds) {
                return ListView.builder(
                  itemCount: favoriteSounds.length,
                  itemBuilder: (context, index) {
                    Sound sound = favoriteSounds[index];
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sound.title,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              ref
                                  .watch(selectedUserDataProvider.notifier)
                                  .setSelecteUser(sound.posterId);
                              ref.read(navigationProvider.notifier).select(5);
                            },
                            child: Text(
                              sound.posterName,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(2),
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.7),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: CachedNetworkImage(
                            imageUrl: sound.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          currentSoundListNotifier.addSound(sound);
                        },
                        icon: const Icon(Icons.playlist_add),
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      shape: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          style: BorderStyle.solid,
                        ),
                      ),
                      onTap: () {
                        currentSoundListNotifier.updateSounds(
                            [sound]).whenComplete(() => audioPlayer.play());
                      },
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => const Center(
                child: Text('エラーが発生しました'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
