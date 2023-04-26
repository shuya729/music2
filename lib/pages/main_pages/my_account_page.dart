import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/audio_system_providers.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/providers.dart';
import '../../models/sound.dart';
import '../../models/userdata_model.dart';
import '../../providers/current_user_provider.dart';
import '../../providers/my_sounds_provider.dart';

class MyAccountPage extends ConsumerStatefulWidget {
  const MyAccountPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends ConsumerState<MyAccountPage> {
  @override
  Widget build(BuildContext contexRt) {
    final AsyncValue<List<Sound>> mySoundList = ref.watch(mySoundsProvider);
    final Userdata userdata = ref.watch(currentUserProvider);
    final currentSoundListNotifier =
        ref.watch(currentSoundListProvider.notifier);
    final audioPlayer = ref.watch(audioPlayerProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Account Page',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              (userdata != Userdata.emputy)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(userdata.userImageUrl),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userdata.userName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userdata.userEmail,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        ElevatedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                            },
                            child: Text(
                              'Log Out',
                              style: Theme.of(context).textTheme.labelLarge,
                            )),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'My Sounds',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ref
                                          .watch(navigationProvider.notifier)
                                          .select(3);
                                    },
                                    child: Text(
                                      'New Post',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 400,
                                child: mySoundList.when(
                                  data: (sounds) => ListView.builder(
                                    itemCount: sounds.length,
                                    itemBuilder: (context, index) {
                                      final sound = sounds[index];
                                      return ListTile(
                                        title: Text(
                                          sound.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        subtitle: Text(
                                          sound.posterName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
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
                                            ref
                                                .watch(editingSoundProvider
                                                    .notifier)
                                                .state = sound;
                                            ref
                                                .read(
                                                    navigationProvider.notifier)
                                                .select(4);
                                          },
                                          icon: const Icon(Icons.edit),
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
                                      child: CircularProgressIndicator()),
                                  error: (error, stackTrace) =>
                                      Text('Error: $error'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
