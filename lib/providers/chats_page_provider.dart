import 'dart:async';

import 'package:chatsphere_app/models/chat.dart';
import 'package:chatsphere_app/models/chat_message.dart';
import 'package:chatsphere_app/models/chat_user.dart';
import 'package:chatsphere_app/providers/authentication_provider.dart';
import 'package:chatsphere_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late DatabaseService _databaseService;

  List<Chat>? chats;

  late StreamSubscription _chatSubscription;

  ChatPageProvider(this._auth) {
    _databaseService = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    _chatSubscription.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatSubscription =
          _databaseService.getChats(_auth.user.uid).listen((_snapshot) async {
        chats = await Future.wait(_snapshot.docs.map((_d) async {
          Map<String, dynamic> _chatSubscription =
              _d.data() as Map<String, dynamic>;

          // Get users in chat
          List<ChatUser> _members = [];
          for (var _uid in _chatSubscription['members']) {
            DocumentSnapshot _userSnapshot =
                await _databaseService.getUser(_uid);
            Map<String, dynamic> _user =
                _userSnapshot.data() as Map<String, dynamic>;
            _user['uid'] = _userSnapshot.id;
            _members.add(ChatUser.fromJSON(_user));
          }

          // Get last msg chat
          List<ChatMessage> _messages = [];
          QuerySnapshot _messagesSnapshot =
              await _databaseService.getLastMessageForChat(_d.id);
          if (_messagesSnapshot.docs.isNotEmpty) {
            Map<String, dynamic> _message =
                _messagesSnapshot.docs.first.data()! as Map<String, dynamic>;
            ChatMessage _chatMessage = ChatMessage.fromJSON(_message);
            _messages.add(_chatMessage);
          }

          return Chat(
              uid: _d.id,
              currentUser: _auth.user.uid,
              activity: _chatSubscription['activity'],
              group: _chatSubscription['group'],
              members: _members,
              messages: _messages);
        }).toList());
          notifyListeners();
      });
    } catch (e) {
      print("error getting chats");
      print(e);
    }
  }
}
