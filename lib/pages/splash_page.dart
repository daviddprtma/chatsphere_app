import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  SplashPage({required Key key, required this.onInitializationComplete})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    widget.onInitializationComplete();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ChatSphere',
        theme: ThemeData(
            backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
            scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0)),
        home: Scaffold(
          body: Center(
            child: Text(
              'ChatSphere',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
        ));
  }
}
