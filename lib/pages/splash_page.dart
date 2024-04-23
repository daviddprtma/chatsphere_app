import 'package:chatsphere_app/services/cloud_storage_service.dart';
import 'package:chatsphere_app/services/database_service.dart';
import 'package:chatsphere_app/services/media_service.dart';
import 'package:chatsphere_app/services/navigation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
    Future.delayed(Duration(seconds: 1)).then((_) {
      _setup().then((_) => widget.onInitializationComplete());
    });
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: 'AIzaSyAz4Ay7sCEs9hYK4-jzGlGPbLOCzgV3udY',
            appId: '1:53274546565:android:d5c31c4effed45d5f1f4ec',
            messagingSenderId: 'sendid',
            projectId: 'chatsphere-705fb',
            storageBucket: 'chatsphere-705fb.appspot.com'));
    _registerServices();
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    GetIt.instance.registerSingleton<MediaService>(MediaService());
    GetIt.instance
        .registerSingleton<CloudStorageService>(CloudStorageService());
    GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
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
