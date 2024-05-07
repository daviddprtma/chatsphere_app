import 'package:chatsphere_app/models/chat.dart';
import 'package:chatsphere_app/providers/authentication_provider.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  final Chat chat;
  const ChatsPage({required this.chat});

  @override
  State<StatefulWidget> createState() {
    return _chatsPageState();
  }
}

class _chatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _authenticationProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  Widget _buildUI() {
    return Scaffold(
      
    );
  }
  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }
}
