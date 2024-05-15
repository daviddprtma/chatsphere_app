import 'package:chatsphere_app/models/chat_user.dart';
import 'package:chatsphere_app/providers/authentication_provider.dart';
import 'package:chatsphere_app/providers/user_page_provider.dart';
import 'package:chatsphere_app/widgets/custom_input_field.dart';
import 'package:chatsphere_app/widgets/custom_list_view_tiles.dart';
import 'package:chatsphere_app/widgets/rounded_button.dart';
import 'package:chatsphere_app/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _authenticationProvider;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  late UserPageProvider _pageProvider;

  String get _currentUserUid => _authenticationProvider.user.uid;

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<UserPageProvider>();
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
              "Users",
              primaryAction: IconButton(
                onPressed: () {
                  _authenticationProvider.logout();
                },
                icon: Icon(Icons.logout),
                color: Color.fromRGBO(0, 82, 218, 1.0),
              ),
            ),
            CustomTextField(
              onEditingComplete: (_value) {
                _pageProvider.getUsers(name: _value);
                FocusScope.of(_context).unfocus();
              },
              hintText: "Search...",
              obscureText: false,
              controller: _searchFieldTextEditingController,
              icon: Icons.search,
            ),
            _usersList(),
            _createChatButton(),
          ],
        ),
      );
    });
  }

  Widget _usersList() {
    List<ChatUser>? _users = _pageProvider.users;
    return Expanded(child: () {
      if (_users != null) {
        if (_users.length != 0) {
          return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (BuildContext context, int index) {
                if (_users[index].uid == _currentUserUid) {
                  return Container();
                } else {
                  return CustomListViewTile(
                      height: _deviceHeight * 0.10,
                      title: _users[index].name,
                      subtitle:
                          "Last Active: ${_users[index].lastSeenActive()}",
                      imagePath: _users[index].imageUrl,
                      isActive: _users[index].wasRecentlyActive(),
                      isActivity: _pageProvider.selectedUsers.contains(
                        _users[index],
                      ),
                      onTap: () {
                        _pageProvider.updateSelectedUsers(_users[index]);
                      });
                }
              });
        } else {
          return Center(
            child: Text(
              "No users found",
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
    }());
  }

  Widget _createChatButton() {
    return Visibility(
        visible: _pageProvider.selectedUsers.isNotEmpty,
        child: RoundedButton(
            name: _pageProvider.selectedUsers.length == 1
                ? "Chat with ${_pageProvider.selectedUsers.first.name}"
                : "Create Group Chat",
            height: _deviceHeight * 0.08,
            width: _deviceWidth * 0.80,
            onPressed: () {
              _pageProvider.createChat();
            }));
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(providers: [
      ChangeNotifierProvider<UserPageProvider>(
        create: (_) => UserPageProvider(_authenticationProvider),
      ),
    ], child: _buildUI());
  }
}
