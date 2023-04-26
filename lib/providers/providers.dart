import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sound.dart';

final authProvider = StreamProvider.autoDispose<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final isExpandedProvider = StateProvider<bool>((ref) => false);

final imageStateProvider = StateProvider.autoDispose<File?>((ref) {
  return null;
});

final editingSoundProvider = StateProvider.autoDispose<Sound>((ref) {
  return Sound.emputy;
});
