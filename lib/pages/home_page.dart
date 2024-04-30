import 'package:chatsphere_app/pages/chat_page.dart';
import 'package:chatsphere_app/pages/user_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final List<Widget> _pages = [ChatPage(), UserPage()];

  Widget _buildUI() {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (_index) {
          setState(() {
            _currentPage = _index;
          });
        },
        items: [
          BottomNavigationBarItem(
              label: "Chats", icon: Icon(Icons.chat_bubble_sharp)),
          BottomNavigationBarItem(
              label: "Users", icon: Icon(Icons.supervised_user_circle_sharp)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }
}
