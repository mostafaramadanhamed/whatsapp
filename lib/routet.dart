import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp/common/widgets/error.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';
import 'package:whatsapp/features/auth/screens/otb_screen.dart';
import 'package:whatsapp/features/auth/screens/user_info.dart';
import 'package:whatsapp/features/select_contact/screens/select_contact_screen.dart';
import 'package:whatsapp/features/chat/screens/mobile_chat.dart';
import 'package:whatsapp/features/status/screens/confirm_status.dart';
import 'package:whatsapp/features/status/screens/status_screen.dart';
import 'package:whatsapp/models/status_model.dart';

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
      });   case StatusScreen.routeName:
      return MaterialPageRoute(builder: (context){
        final status=settings.arguments as StatusModel;
        return   StatusScreen(status: status);
      });
      case  MobileChatScreen.routeName:
      return MaterialPageRoute(builder: (context){
        final arguments=settings.arguments as Map<String,dynamic>;
        final name=arguments['name'];
        final uid=arguments['uid'];
        return  MobileChatScreen(name: name,uid: uid,);
      });
      case  ConfirmStatusScreen.routeName:
      return MaterialPageRoute(builder: (context){
        final file=settings.arguments as File;
        return  ConfirmStatusScreen(file: file,);
      });
    default:
  return MaterialPageRoute(builder: (context){
  return const Scaffold(
    body: ErrorScreen(error: 'page dose n\'t exist'),
  );
  });
  }
}