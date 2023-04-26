import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/userdata_model.dart';

final currentUserProvider =
    StateNotifierProvider<CurrentUserStateNotifier, Userdata>((ref) {
  return CurrentUserStateNotifier();
});

class CurrentUserStateNotifier extends StateNotifier<Userdata> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late StreamSubscription<User?> _authStateChangesSubscription;
  CurrentUserStateNotifier() : super(Userdata.emputy) {
    _authStateChangesSubscription =
        _auth.authStateChanges().listen((user) async {
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).get().then((doc) {
          state = Userdata.fromFirestore(doc);
        });
      } else {
        state = Userdata.emputy;
      }
    });
  }
  @override
  void dispose() {
    _authStateChangesSubscription.cancel();
    super.dispose();
  }
}
