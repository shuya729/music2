import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/userdata_model.dart';
import '../models/sound.dart';

final selectedUserDataProvider =
    StateNotifierProvider.autoDispose<SelectedUserDataNotifier, Userdata>(
        (ref) => SelectedUserDataNotifier());

class SelectedUserDataNotifier extends StateNotifier<Userdata> {
  SelectedUserDataNotifier()
      : super(Userdata(
          userId: '',
          userEmail: '',
          userName: '',
          userImageUrl: '',
          favoriteSounds: [],
        ));

  Future<void> setSelecteUser(String selectedUserId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(selectedUserId).get().then((value) {
      state = Userdata.fromFirestore(value);
    });
  }
}

final selectedUserSoundsProvider =
    StreamProvider.autoDispose<List<Sound>>((ref) {
  final selectedUserId = ref.watch(selectedUserDataProvider).userId;
  if (selectedUserId == '') {
    return const Stream.empty();
  }
  final soundRef = FirebaseFirestore.instance.collection('sounds');
  return soundRef.where('posterId', isEqualTo: selectedUserId).snapshots().map(
      (querySnapshot) => querySnapshot.docs
          .map((doc) => Sound.fromMap(doc.data(), doc.id))
          .toList());
});
