import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = 'Users';
const String CHAT_COLLECTION = 'Chats';
const String MESSAGE_COLLECTION = 'Messages';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DatabaseService() {}

  Future<DocumentSnapshot> getUser(String _uuid) {
    return _db.collection(USER_COLLECTION).doc(_uuid).get();
  }

  Future<void> updateUserLastSeen(String _uid) async {
    try {
      await _db
          .collection(USER_COLLECTION)
          .doc(_uid)
          .update({'lastSeen': DateTime.now().toUtc()});
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUser(
      String _uid, String _email, String _name, String _imageUrl) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set({
        'email': _email,
        'name': _name,
        'imageUrl': _imageUrl,
        'lastSeen': DateTime.now().toUtc()
      });
    } catch (e) {
      print(e);
    }
  }
}
