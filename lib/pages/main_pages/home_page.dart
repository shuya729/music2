import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/audio_system_providers.dart';
import '../../models/sound.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/selected_user_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Stream<QuerySnapshot> _soundsStream;
  List<Sound> _sounds = [];

  @override
  void initState() {
    super.initState();
    _soundsStream = FirebaseFirestore.instance.collection('sounds').snapshots();
    _loadSounds();
  }

  void _loadSounds() async {
    var snapshot = await _soundsStream.first;
    _updateSounds(snapshot);
  }

  void _updateSounds(QuerySnapshot snapshot) {
    setState(() {
      _sounds = snapshot.docs.map((doc) {
        return Sound.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  void _filterSounds(String query) {
    if (query.isNotEmpty) {
      var filteredSounds = _sounds.where((sound) {
        return sound.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      setState(() {
        _sounds = filteredSounds;
      });
    } else {
      _loadSounds();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSoundListNotifier =
        ref.watch(currentSoundListProvider.notifier);
    final audioPlayer = ref.watch(audioPlayerProvider);
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'All Sounds',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search sounds',
                border: InputBorder.none,
              ),
              onChanged: (query) {
                _filterSounds(query);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _sounds.length,
              itemBuilder: (context, index) {
                Sound sound = _sounds[index];
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
                      child: Image(
                        image: NetworkImage(sound.imageUrl),
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
                    currentSoundListNotifier.updateSounds([sound]).whenComplete(
                        () => audioPlayer.play());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
