import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp/models/status_model.dart';

import '../../../common/widgets/loader.dart';

class StatusScreen extends StatefulWidget {
  static const routeName='/status-screen';
  final StatusModel status;
  const StatusScreen({Key? key, required this.status}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController controller=StoryController();
  List<StoryItem>storyItems=[];
 void initStoryPage(){
    for(int i=0;i<widget.status.photoUrl.length;i++){

      storyItems.add(
        StoryItem.pageImage(url: widget.status.photoUrl[i], controller: controller),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    initStoryPage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty? const Loader():StoryView(
        storyItems: storyItems, controller: controller,
        onVerticalSwipeComplete: (direction){
          if(direction==Direction.down){
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
