import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import './pages/splash_page.dart';

void main() {
  runApp(SplashPage(
    key: UniqueKey(),
    onInitializationComplete: () {},
  ));
}
