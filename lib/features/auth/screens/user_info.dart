import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/utils/constant/app_assets.dart';
import 'package:whatsapp/utils/constant/app_color.dart';
import 'package:whatsapp/utils/constant/app_string.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({Key? key}) : super(key: key);
  static const String routeName='/user-info';

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  File ? image;
  final TextEditingController nameController=TextEditingController();
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }
  void selectImage()async{
    image=await pickImageFromGallery(context);
    setState((){});
  }

  void storeUserData()async{
    String name=nameController.text.trim();
   if(name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name,
            image,
          );
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
        image==null?  const CircleAvatar(
                     backgroundImage: NetworkImage(AppAssets.oTBProfileImage),
                    radius: 65,
                  ):CircleAvatar(
          backgroundImage: FileImage(image!),
          radius: 65,
        ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: tabColor,
                        child: IconButton(
                            onPressed: (){
                              selectImage();
                            },
                            icon: const Icon(Icons.add_a_photo,color: textColor,),
                        ),
                      ),),
                ],
              ),
              Row(
                children: [
                  Container(
                    width:size.width*0.85 ,
                    padding:const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: AppString.userInfoHintName,
                      ),
                    )
                  ),
                  CircleAvatar(
                    backgroundColor: tabColor,
                    foregroundColor: Colors.white,
                    child: IconButton(
                        onPressed: storeUserData,
                     icon: const Icon(Icons.done)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
