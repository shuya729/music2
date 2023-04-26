import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/providers.dart';
import 'signup_load_page.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  late String _displayName;

  @override
  void initState() {
    super.initState();
    _email = '';
    _password = '';
    _displayName = '';
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ref.read(imageStateProvider.notifier).state = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final File? imageFile = ref.watch(imageStateProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter email';
                  }
                  return null;
                },
                onChanged: (value) {
                  _email = value;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null) {
                    return 'Please enter password';
                  }
                  return null;
                },
                onChanged: (value) {
                  _password = value;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter display name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _displayName = value;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        imageFile != null ? FileImage(imageFile) : null,
                    child: imageFile == null
                        ? const Icon(
                            Icons.camera_alt,
                            size: 50,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: imageFile != null
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupLoadPage(
                                  email: _email,
                                  password: _password,
                                  displayName: _displayName,
                                  imageFile: imageFile,
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                  child: Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
