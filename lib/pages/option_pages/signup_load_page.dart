import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'authentication.dart';

class SignupLoadPage extends ConsumerWidget {
  final String email;
  final String password;
  final String displayName;
  final File imageFile;
  SignupLoadPage({
    super.key,
    required this.email,
    required this.password,
    required this.displayName,
    required this.imageFile,
  });

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> _signUp() async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((userCredential) async {
        final User user = userCredential.user!;

        await _storage
            .ref()
            .child('images/${user.uid}/${imageFile.path.split('/').last}')
            .putFile(imageFile)
            .then((taskSnapshot) async {
          await taskSnapshot.ref.getDownloadURL().then((imageUrl) async {
            await _firestore.collection('users').doc(user.uid).set({
              'userId': user.uid,
              'userEmail': user.email,
              'userName': displayName,
              'userImageUrl': imageUrl,
              'favoriteSounds': [],
            });
          });
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _signUp().whenComplete(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthenticationWrapper(),
        ),
      );
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
