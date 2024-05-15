import 'package:chatsphere_app/models/chat.dart';
import 'package:chatsphere_app/models/chat_user.dart';

import 'package:chatsphere_app/pages/chats_page.dart';
import 'package:chatsphere_app/providers/authentication_provider.dart';
import 'package:chatsphere_app/services/database_service.dart';
import 'package:chatsphere_app/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UserPageProvider extends ChangeNotifier {
  AuthenticationProvider _authenticationProvider;
  late DatabaseService _databaseService;
  late NavigationService _navigationService;

  List<ChatUser>? users;
  late List<ChatUser>? _selectedUser;

  List<ChatUser> get selectedUsers {
    return _selectedUser!;
  }

  void getUsers({String? name}) async {
    _selectedUser = [];

    try {
      _databaseService.getUsers(name: name).then((_snapshot) {
        users = _snapshot.docs.map((_doc) {
          Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
          _data["uid"] = _doc.id;
          return ChatUser.fromJSON(_data);
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      print("Error getting users");
      print(e);
    }
  }

  UserPageProvider(this._authenticationProvider) {
    _databaseService = GetIt.instance<DatabaseService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    _selectedUser = [];
    getUsers();
  }

  void updateSelectedUsers(ChatUser user) {
    if (_selectedUser!.contains(user)) {
      _selectedUser!.remove(user);
    } else {
      _selectedUser!.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      List<String> _membersId =
          _selectedUser!.map((_user) => _user.uid).toList();

      _membersId.add(_authenticationProvider.user.uid);
      bool _isGroup = _selectedUser!.length > 1;
      DocumentReference? _chatRef = await _databaseService.createChat(
          {"group": _isGroup, "activity": false, "members": _membersId});
      // Navigate to chat page
      List<ChatUser> _members = [];
      for (var _uid in _membersId) {
        DocumentSnapshot _user = await _databaseService.getUser(_uid);
        Map<String, dynamic> _data = _user.data() as Map<String, dynamic>;
        _data["uid"] = _user.id;
        _members.add(ChatUser.fromJSON(_data));
      }

      ChatsPage _chatPage = ChatsPage(
        chat: Chat(
            uid: _chatRef!.id,
            currentUser: _authenticationProvider.user.uid,
            activity: false,
            group: _isGroup,
            members: _members,
            messages: []),
      );
      _selectedUser = [];
      notifyListeners();
      _navigationService.navigateToPage(_chatPage);
    } catch (e) {
      print("Error creating chat");
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
