import 'package:chatsphere_app/models/chat.dart';
import 'package:chatsphere_app/models/chat_message.dart';
import 'package:chatsphere_app/models/chat_user.dart';
import 'package:chatsphere_app/pages/chats_page.dart';
import 'package:chatsphere_app/providers/chats_page_provider.dart';
import 'package:chatsphere_app/services/navigation_service.dart';
import 'package:chatsphere_app/widgets/custom_list_view_tiles.dart';
import 'package:chatsphere_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../providers/authentication_provider.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _authenticationProvider;

  late NavigationService _navigationService;

  late ChatPageProvider _chatPageProvider;

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _chatPageProvider = _context.watch<ChatPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              'Chats',
              primaryAction: IconButton(
                  onPressed: () {
                    _authenticationProvider.logout();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  )),
            ),
            _chatsList(),
          ],
        ),
      );
    });
  }

  Widget _chatsList() {
    List<Chat>? _chats = _chatPageProvider.chats;

    return Expanded(
      child: (() {
        if (_chats != null) {
          if (_chats.length != 0) {
            return ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (BuildContext _context, int _index) {
                  return _chatTile(_chats[_index]);
                });
          } else {
            return Center(
              child: Text(
                "No chats found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }

  Widget _chatTile(Chat _chat) {
    List<ChatUser> _recipients = _chat.recipients();
    bool _isActive = _recipients.any((_d) => _d.wasRecentlyActive());
    String _subtitle = "";

    if (_chat.messages.isNotEmpty) {
      _subtitle = _chat.messages.first.type != MessageType.TEXT
          ? "Media Attachment"
          : _chat.messages.first.content;
    }
    return CustomListViewTilesWithActivity(
        height: _deviceHeight * 0.10,
        title: _chat.title(),
        subtitle: _subtitle,
        imagePath: _chat.imageUrl(),
        isActive: _isActive,
        isActivity: _chat.activity,
        onTap: () {
          _navigationService.navigateToPage(ChatsPage(chat: _chat));
        });
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _navigationService = GetIt.instance.get<NavigationService>();
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
            create: (_) => ChatPageProvider(_authenticationProvider))
      ],
      child: _buildUI(),
    );
  }
}
