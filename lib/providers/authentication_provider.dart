import 'package:chatsphere_app/services/database_service.dart';
import 'package:chatsphere_app/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _firebaseAuth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  AuthenticationProvider() {
    _firebaseAuth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
  }

  Future<void> loginUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print(_firebaseAuth.currentUser);
    } on FirebaseAuthException {
      print("Error login user into firebase");
    }
    catch (e) {
      print(e);
    }
  }
}
