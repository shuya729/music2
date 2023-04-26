import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/sound.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/providers.dart';

class EditSoundPage extends ConsumerStatefulWidget {
  const EditSoundPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditSoundPageState();
}

class _EditSoundPageState extends ConsumerState<EditSoundPage> {
  final _firestore = FirebaseFirestore.instance;
  final _strage = FirebaseStorage.instance;
  late TextEditingController _titleController;
  late File? _imageFile;

  @override
  void initState() {
    super.initState();
    _imageFile = null;
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

  Future<void> _updateSound(String soundId) async {
    final storeSoundRef = _firestore.collection('sounds').doc(soundId);
    final strageSoundRef = _strage.ref('sounds/$soundId/image');
    Future<void> strageSoundImageRef =
        strageSoundRef.child('image').listAll().then((value) {
      for (var element in value.items) {
        element.delete();
      }
    });
    Future<void> strageSoundSoundRef =
        strageSoundRef.child('sound').listAll().then((value) {
      for (var element in value.items) {
        element.delete();
      }
    });

    if (_imageFile == null) {
      await storeSoundRef.update({
        'title': _titleController.text.trim(),
      }).whenComplete(
        () => ref.watch(navigationProvider.notifier).select(2),
      );
    } else {
      final strageNewImageRef = _strage
          .ref('sounds/$soundId/image/${_imageFile!.path.split('/').last}');
      Future.wait<void>([strageSoundImageRef, strageSoundSoundRef])
          .then((value) async {
        await strageNewImageRef.putFile(_imageFile!).whenComplete(() async {
          await strageNewImageRef.getDownloadURL().then((imageUrl) async {
            await storeSoundRef.update({
              'title': _titleController.text,
              'imageUrl': imageUrl,
            }).whenComplete(
              () => ref.watch(navigationProvider.notifier).select(2),
            );
          });
        });
      });
    }
  }

  Future<void> _deleteSound(String soundId) async {
    final storeSoundRef = _firestore.collection('sounds').doc(soundId);
    final strageSoundRef = _strage.ref('sounds/$soundId/image');
    Future<void> strageSoundImageRef =
        strageSoundRef.child('image').listAll().then((value) {
      for (var element in value.items) {
        element.delete();
      }
    });
    Future<void> strageSoundSoundRef =
        strageSoundRef.child('sound').listAll().then((value) {
      for (var element in value.items) {
        element.delete();
      }
    });

    Future.wait<void>([strageSoundImageRef, strageSoundSoundRef])
        .then((value) async {
      await storeSoundRef.delete().whenComplete(
            () => ref.watch(navigationProvider.notifier).select(2),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final editingSound = ref.watch(editingSoundProvider);
    _titleController = TextEditingController(text: editingSound.title);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Edit Your Sound',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            (editingSound != Sound.emputy)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sound Name:',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'タイトル',
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              'Sound Image:',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            ElevatedButton(
                              onPressed: _selectImageFile,
                              child: Text(
                                '写真ファイルを選択',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        (_imageFile != null)
                            ? Container(
                                padding: const EdgeInsets.all(10),
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.7),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image(
                                    image: FileImage(_imageFile!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(10),
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.7),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image(
                                    image: NetworkImage(editingSound.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _updateSound(editingSound.soundId),
                          child: Text(
                            'Update Sound',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          height: 2,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () => _deleteSound(editingSound.soundId),
                            child: Text(
                              'Delete Sound',
                              style: Theme.of(context).textTheme.labelLarge,
                            )),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
