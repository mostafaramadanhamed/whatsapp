import 'package:flutter/material.dart';
import 'package:whatsapp/common/widgets/error.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';
import 'package:whatsapp/features/auth/screens/otb_screen.dart';

Route<dynamic>generateRoute(RouteSettings settings){
  switch(settings.name){
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context){
        return const LoginScreen();
      });
      case OtbScreen.routeName:
        final String verificationId=settings.arguments as String;
      return MaterialPageRoute(builder: (context){
        return  OtbScreen(verificationId: verificationId,);
      });
    default:
  return MaterialPageRoute(builder: (context){
  return const Scaffold(
    body: ErrorScreen(error: 'page dose n\'t exist'),
  );
  });
  }
}