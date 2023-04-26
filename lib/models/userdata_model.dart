import 'package:cloud_firestore/cloud_firestore.dart';

class Userdata {
  final String userId;
  final String userEmail;
  final String userName;
  final String userImageUrl;
  final List favoriteSounds;

  Userdata({
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userImageUrl,
    required this.favoriteSounds,
  });

  factory Userdata.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Userdata(
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userName: data['userName'] ?? '',
      userImageUrl: data['userImageUrl'] ?? '',
      favoriteSounds: data['favoriteSounds'] ?? [],
    );
  }

  static Userdata emputy = Userdata(
    userId: '',
    userEmail: '',
    userName: '',
    userImageUrl: '',
    favoriteSounds: [],
  );
}
