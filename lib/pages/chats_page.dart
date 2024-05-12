import 'package:chatsphere_app/models/chat.dart';
import 'package:chatsphere_app/models/chat_message.dart';
import 'package:chatsphere_app/providers/authentication_provider.dart';
import 'package:chatsphere_app/providers/chat_page_provider.dart';
import 'package:chatsphere_app/widgets/custom_list_view_tiles.dart';
import 'package:chatsphere_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late ChatPageProvider _chatPageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
  }

  Widget _buildUI() {
    return Builder(builder: (_context) {
      _chatPageProvider = _context.watch<ChatPageProvider>();
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.03,
              vertical: _deviceHeight * 0.02,
            ),
            height: _deviceHeight,
            width: _deviceWidth * 0.97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopBar(this.widget.chat.title(),
                    fontSize: 15,
                    primaryAction: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete),
                      color: Color.fromRGBO(0, 82, 210, 1.0),
                    ),
                    secondaryAction: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_back),
                      color: Color.fromRGBO(0, 82, 210, 1.0),
                    )),
                _messagesListView()
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _messagesListView() {
    if (_chatPageProvider.message != null) {
      if (_chatPageProvider.messages?.isNotEmpty ?? false) {
        return Container(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
            itemCount: _chatPageProvider.messages!.length,
            itemBuilder: (BuildContext _context, int _index) {
              ChatMessage _message = _chatPageProvider.messages![_index];
              bool _isOwnMessage =
                  _message.senderID == _authenticationProvider.user.uid;
              return Container(
                child: CustomChatListViewTile(
                    width: _deviceWidth * 0.80,
                    deviceHeight: _deviceHeight,
                    isOwnMessage: _isOwnMessage,
                    message: _message,
                    sender: this
                        .widget
                        .chat
                        .members
                        .where((_m) => _m.uid == _message.senderID)
                        .first),
              );
            },
          ),
        );
      } else {
        return Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first to say Hi!",
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
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(providers: [
      ChangeNotifierProvider<ChatPageProvider>(
        create: (_) => ChatPageProvider(widget.chat.uid,
            _authenticationProvider, _messagesListViewController),
      ),
    ], child: _buildUI());
  }
}
