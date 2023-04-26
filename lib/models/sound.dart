import 'package:uuid/uuid.dart';

class Sound {
  final String soundId;
  final String title;
  final String soundUrl;
  final String imageUrl;
  final String posterId;
  final String posterName;

  Sound({
    required this.soundId,
    required this.title,
    required this.soundUrl,
    required this.imageUrl,
    required this.posterId,
    required this.posterName,
  });

  factory Sound.fromMap(Map<String, dynamic> data, String documentId) {
    return Sound(
      soundId: documentId,
      title: data['title'],
      soundUrl: data['soundUrl'],
      imageUrl: data['imageUrl'],
      posterId: data['posterId'],
      posterName: data['posterName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'soundId': soundId,
      'title': title,
      'soundUrl': soundUrl,
      'imageUrl': imageUrl,
      'posterId': posterId,
      'posterName': posterName,
    };
  }

  static String generateSoundId() {
    const uuid = Uuid();
    return uuid.v4();
  }

  static Sound emputy = Sound(
    soundId: '',
    title: '',
    soundUrl: '',
    imageUrl: '',
    posterId: '',
    posterName: '',
  );
}
