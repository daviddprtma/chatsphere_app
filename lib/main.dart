import 'package:chatsphere_app/pages/home_page.dart';
import 'package:chatsphere_app/pages/login_page.dart';
import 'package:chatsphere_app/pages/register_page.dart';
import 'package:chatsphere_app/providers/authentication_provider.dart';
import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import './pages/splash_page.dart';

import './services/navigation_service.dart';

void main() {
  runApp(SplashPage(
    key: UniqueKey(),
    onInitializationComplete: () {
      runApp(const MainApp());
    },
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthenticationProvider>(
              create: (BuildContext _context) {
            return AuthenticationProvider();
          }),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ChatSphere',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
            ),
          ),
          navigatorKey: NavigationService.navigatorKey,
          initialRoute: '/login',
          routes: {
            '/login': (BuildContext _context) => LoginPage(),
            '/register': (BuildContext _context) => RegisterPage(),
            '/home': (BuildContext _context) => HomePage(),
          },
        ));
  }
}
