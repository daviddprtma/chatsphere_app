import 'package:chatsphere_app/models/chat_user.dart';
import 'package:chatsphere_app/providers/authentication_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/navigation_service.dart';

class ProfilePageProvider extends ChangeNotifier {
  late AuthenticationProvider _auth;
  late NavigationService _navigation;

  ProfilePageProvider(this._auth, this._navigation);

  ChatUser get user => _auth.user;

}
