import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/utils/constant/app_string.dart';

class ContactScreen extends ConsumerWidget {
  static const String routeName='/select-contact';
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(AppString.contactScreenAppbarTitle),
      ),
      body: ListView.separated(
          itemBuilder: (context,index)=>Text('data'),
          separatorBuilder: (context,index)=>SizedBox(height: 10,),
          itemCount: 5),
    );
  }
}
