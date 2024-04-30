import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  Widget _buildUI(){
    return Scaffold(
      backgroundColor: Colors.green,
    );
  }
  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }
}
