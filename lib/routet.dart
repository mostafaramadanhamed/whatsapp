import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/common/widgets/error.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';
import 'package:whatsapp/features/auth/screens/otb_screen.dart';
import 'package:whatsapp/features/auth/screens/user_info.dart';
import 'package:whatsapp/features/select_contact/screens/select_contact_screen.dart';

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
      case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context){
        return  const UserInformationScreen();
      });
      case ContactScreen.routeName:
      return MaterialPageRoute(builder: (context){
        return  const ContactScreen();
      });
    default:
  return MaterialPageRoute(builder: (context){
  return const Scaffold(
    body: ErrorScreen(error: 'page dose n\'t exist'),
  );
  });
  }
}