import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/userdata_model.dart';
import '../models/sound.dart';
import 'current_user_provider.dart';

final mySoundsProvider = StreamProvider.autoDispose<List<Sound>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == Userdata.emputy) {
    return const Stream.empty();
  }
  final soundRef = FirebaseFirestore.instance.collection('sounds');
  return soundRef
      .where('posterId', isEqualTo: currentUser.userId)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs
          .where((doc) => doc.exists)
          .map((doc) => Sound.fromMap(doc.data()!, doc.id))
          .toList());
});
