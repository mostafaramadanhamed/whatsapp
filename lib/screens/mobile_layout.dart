import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/select_contact/screens/select_contact_screen.dart';
import 'package:whatsapp/features/status/screens/confirm_status.dart';
import 'package:whatsapp/features/status/screens/status_contact_screen.dart';
import '../features/auth/controller/auth_controller.dart';
import '../utils/constant/app_color.dart';
import '../features/chat/widgets/contact_list.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen> with WidgetsBindingObserver,TickerProviderStateMixin{
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController=TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
       break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {},
            ),
          ],
          bottom:  TabBar(
            controller: tabController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            onTap: (val){
              setState((){
                tabController.index=val;
              });
            },
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const[
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children:const [ ContactsList(), StatusContactScreen(),Text('Calls')], ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
           if(tabController.index==0){
             Navigator.pushNamed(context, ContactScreen.routeName);
           } else if(tabController.index==1){
             File?pickedImage=await pickImageFromGallery(context);
             if(pickedImage != null){
               Navigator.pushNamed(context, ConfirmStatusScreen.routeName,arguments: pickedImage);

             }
           }else{
             Navigator.pushNamed(context, ContactScreen.routeName);
           }
          },
          backgroundColor: tabColor,
          child: tabController.index==0?
          const Icon(
             Icons.comment,            color: Colors.white,
          ):tabController.index==1?
          const Icon(Icons.camera_alt_rounded,color: Colors.white,):
          const Icon(Icons.call,color: Colors.white,),

        ),
      ),
    );
  }
}