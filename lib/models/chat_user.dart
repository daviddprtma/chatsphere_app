import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  late DateTime lastSeen;

  ChatUser(
      {required this.uid,
      required this.name,
      required this.email,
      required this.imageUrl,
      required this.lastSeen});

  factory ChatUser.fromJSON(Map<String, dynamic> json) {
    return ChatUser(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        imageUrl: json['imageUrl'],
        lastSeen: (json['lastSeen'] as Timestamp).toDate());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'lastSeen': lastSeen
    };
  }

  String lastSeenActive() {
    return "${lastSeen.day}/${lastSeen.month}/${lastSeen.year} at ${lastSeen.hour}:${lastSeen.minute.toString().padLeft(2, '0')}";
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastSeen).inMinutes < 5;
  }
}
