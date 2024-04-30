import 'package:chatsphere_app/models/chat_user.dart';
import 'package:chatsphere_app/services/database_service.dart';
import 'package:chatsphere_app/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _firebaseAuth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  late ChatUser user;

  AuthenticationProvider() {
    _firebaseAuth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    // _firebaseAuth.signOut();
    _firebaseAuth.authStateChanges().listen((User? _user) {
      if (_user != null) {
        _databaseService.updateUserLastSeen(_user.uid);
        _databaseService.getUser(_user.uid).then((_snapshot) {
          if (_snapshot.data() != null) {
            Map<String, dynamic> _userData =
                _snapshot.data()! as Map<String, dynamic>;
            user = ChatUser.fromJSON({
              "uid": _user.uid,
              "name": _userData['name'],
              "email": _userData['email'],
              "imageUrl": _userData['imageUrl'],
              "lastSeen": _userData['lastSeen']
            });
            _navigationService.removeAndNavigateToRoute('/home');
          }
        });
      } else {
        _navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print(_firebaseAuth.currentUser);
    } on FirebaseAuthException {
      print("Error login user into firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserEmailAndPassword(
      String _email, String _password) async {
    try {
      UserCredential _credentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: _email, password: _password);
      return _credentials.user!.uid;
    } on FirebaseAuthException {
      print("Error registering user into firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
