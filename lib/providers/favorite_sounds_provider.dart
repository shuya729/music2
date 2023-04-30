import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/userdata_model.dart';
import 'audio_system_providers.dart';
import '../models/sound.dart';
import 'current_user_provider.dart';

final favoriteSoundsProvider = FutureProvider<List<Sound>>((ref) async {
  final firestore = FirebaseFirestore.instance;
  final currentUserId = ref.watch(currentUserProvider).userId;

  final List<Sound> sounds = [];
  // Firestoreからユーザーのドキュメントを取得
  await firestore
      .collection('users')
      .doc(currentUserId)
      .get()
      .then((userDoc) async {
    final List<String> favoriteSounds =
        List<String>.from(userDoc.get('favoriteSounds') ?? []);
    for (final String soundId in favoriteSounds) {
      await firestore.collection('sounds').doc(soundId).get().then((soundDoc) {
        final Map<String, dynamic>? soundData = soundDoc.data();
        if (soundData != null) {
          final Sound sound = Sound.fromMap(soundData, soundId);
          sounds.add(sound);
        }
      });
    }
  });

  return sounds;
});

final favoriteSoundStateProvider =
    StateNotifierProvider<FavoriteSoundStateNotifier, bool>((ref) {
  return FavoriteSoundStateNotifier(
    ref.watch(currentUserProvider),
    ref.watch(currentSoundProvider),
  );
});

class FavoriteSoundStateNotifier extends StateNotifier<bool> {
  Userdata currentUser;
  Sound currentSound;
  FavoriteSoundStateNotifier(this.currentUser, this.currentSound)
      : super(
          currentUser.favoriteSounds
              .any((element) => element == currentSound.soundId),
        );

  Future<void> changeFavoriteState() async {
    // Firestoreからユーザーのドキュメントを取得
    final DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.userId);

    // ユーザーデータを更新
    final List favoriteSounds = currentUser.favoriteSounds;
    final String soundId = currentSound.soundId;
    if (favoriteSounds.any((element) => element == soundId)) {
      favoriteSounds.remove(soundId);
      state = false;
    } else {
      favoriteSounds.add(soundId);
      state = true;
    }
    await userDocRef.update({
      'favoriteSounds': favoriteSounds,
    });
  }
}
