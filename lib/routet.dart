import 'package:flutter/material.dart';
import 'package:whatsapp/common/widgets/error.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';

Route<dynamic>generateRoute(RouteSettings settings){
  switch(settings.name){
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context){
        return const LoginScreen();
      });
    default:
  return MaterialPageRoute(builder: (context){
  return const Scaffold(
    body: ErrorScreen(error: 'page dosen\'t exist'),
  );
  });
  }
}