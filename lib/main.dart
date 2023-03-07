import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/landing/screen/landing_screen.dart';
import 'package:whatsapp/routet.dart';
import 'package:whatsapp/screens/mobile_layout.dart';
import 'package:whatsapp/screens/web_layout.dart';
import 'package:whatsapp/utils/constant/app_color.dart';
import 'package:whatsapp/utils/layout/responsive_layout.dart';

import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      onGenerateRoute: (setting)=>generateRoute(setting),
      home: LandingScreen(),
    );
  }
}