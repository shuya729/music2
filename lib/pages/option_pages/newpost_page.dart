import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/current_user_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../models/sound.dart';

class NewPostPage extends ConsumerStatefulWidget {
  const NewPostPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPostPageState();
}

class _NewPostPageState extends ConsumerState<NewPostPage> {
  final TextEditingController _titleController = TextEditingController();
  File? _imageFile;
  File? _soundFile;
  String? _imageUrl;
  String? _soundUrl;

  Future<void> _selectSoundFile() async {
    // Only allow file selection if previous selection has been completed
    if (_soundFile == null) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );

      if (result != null) {
        setState(() {
          _soundFile = File(result.files.single.path!);
        });
      }
    }
  }

  Future<void> _selectImageFile() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadStrage() async {
    // Generate sound ID
    final soundId = Sound.generateSoundId();
    final storageRef = FirebaseStorage.instance.ref().child('sounds/$soundId');
    final strageImageRef =
        storageRef.child('image/${_imageFile!.path.split('/').last}');
    final strageSoundRef =
        storageRef.child('sound/${_soundFile!.path.split('/').last}');
    Future<TaskSnapshot> futureImage = strageImageRef.putFile(_imageFile!);
    Future<TaskSnapshot> futureSound = strageSoundRef.putFile(_soundFile!);
    Future.wait<TaskSnapshot>([futureImage, futureSound]).then(
      (result) => Future.wait<String>([
        result[0].ref.getDownloadURL(),
        result[1].ref.getDownloadURL(),
      ]).then(
        (value) {
          _imageUrl = value[0];
          _soundUrl = value[1];
          _uploadFirestore(soundId);
        },
      ),
    );
  }

  Future<void> _uploadFirestore(String soundId) async {
    if (_imageUrl != null && _soundUrl != null) {
      final userdata = ref.watch(currentUserProvider);

      // Create sound data and post to Firestore
      final sound = Sound(
        soundId: soundId,
        title: _titleController.text.trim(),
        soundUrl: _soundUrl!,
        imageUrl: _imageUrl!,
        posterId: userdata.userId,
        posterName: userdata.userName,
      );

      final soundRef = FirebaseFirestore.instance.collection('sounds');
      await soundRef.doc(sound.soundId).set(sound.toMap());

      // Navigate back to home screen
      ref.watch(navigationProvider.notifier).select(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'タイトル',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _selectSoundFile,
              child: Text(
                '音声ファイルを選択',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            ElevatedButton(
              onPressed: _selectImageFile,
              child: Text(
                '写真ファイルを選択',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 16.0),
            if (_soundFile != null) ...[
              Text(_soundFile!.path),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: (_imageFile != null && _soundFile != null)
                    ? () {
                        _uploadStrage();
                      }
                    : null,
                child: Text(
                  '投稿',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
