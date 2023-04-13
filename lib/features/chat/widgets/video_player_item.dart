import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;
  @override
  void initState() {
    super.initState();
    videoPlayerController=CachedVideoPlayerController.network(widget.videoUrl)..initialize().then((value){
      videoPlayerController.setVolume(1);
    });
  }
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16/9,
    child:Stack(
      children: [
        CachedVideoPlayer(videoPlayerController),
        IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow_rounded))

      ],
    ) ,
    );
  }
}
