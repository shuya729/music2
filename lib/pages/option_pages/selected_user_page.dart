import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/sound.dart';
import '../../models/userdata_model.dart';
import '../../providers/audio_system_providers.dart';
import '../../providers/selected_user_provider.dart';

class SelectedUserPage extends ConsumerStatefulWidget {
  const SelectedUserPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectedUserPageState();
}

class _SelectedUserPageState extends ConsumerState<SelectedUserPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Sound>> selectedUserSoundList =
        ref.watch(selectedUserSoundsProvider);
    final Userdata selectedUserData = ref.watch(selectedUserDataProvider);
    final currentSoundListNotifier =
        ref.watch(currentSoundListProvider.notifier);
    final audioPlayer = ref.watch(audioPlayerProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: (selectedUserData.userId != '')
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      selectedUserData.userName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(selectedUserData.userImageUrl),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Column(
                            children: [
                              Text(
                                '${selectedUserData.userName} Sounds',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 400,
                                child: selectedUserSoundList.when(
                                  data: (sounds) => ListView.builder(
                                    itemCount: sounds.length,
                                    itemBuilder: (context, index) {
                                      final sound = sounds[index];
                                      return ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              sound.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                            Text(
                                              sound.posterName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                          ],
                                        ),
                                        leading: Container(
                                          padding: const EdgeInsets.all(2),
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.7),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: Image(
                                              image:
                                                  NetworkImage(sound.imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            currentSoundListNotifier
                                                .addSound(sound);
                                          },
                                          icon: const Icon(Icons.playlist_add),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                        shape: Border(
                                          bottom: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        onTap: () {
                                          currentSoundListNotifier
                                              .updateSounds([
                                            sound
                                          ]).whenComplete(
                                                  () => audioPlayer.play());
                                        },
                                      );
                                    },
                                  ),
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  error: (error, stackTrace) =>
                                      Text('Error: $error'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
