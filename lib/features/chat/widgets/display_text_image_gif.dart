import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:whatsapp/common/enum/message_enum.dart';
import 'package:whatsapp/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF(
      {Key? key, required this.message, required this.type,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying=false;
    final AudioPlayer audioPlayer=AudioPlayer();

    return type==MessageEnum.text? Text(
      message,
      style: const TextStyle(
        fontSize: 16,
      ),
    ):type==MessageEnum.video? Container( clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight:Radius.circular(16),
              topLeft:Radius.circular(16),
              bottomLeft: Radius.circular(16),
            )
        ),child: VideoPlayerItem(videoUrl: message)):
        type==MessageEnum.gif?Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight:Radius.circular(16),
                  topLeft:Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                )
            ),
            child: CachedNetworkImage(imageUrl: message),):
  type==MessageEnum.audio?  StatefulBuilder(
    builder: ( context, setState) { return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight:Radius.circular(16),
            topLeft:Radius.circular(16),
            bottomLeft: Radius.circular(16),
          )
      ),
      child: IconButton(constraints:BoxConstraints(
        minWidth: MediaQuery.of(context).size.width*0.38,
      ),icon:  Icon(isPlaying?Icons.pause:Icons.play_arrow_rounded,size: 28,),onPressed: ()async{
      if(isPlaying){
      await audioPlayer.pause();
      setState((){
        isPlaying=false;
      });
      }else{
      await audioPlayer.play(UrlSource(message));
      setState((){
        isPlaying=true;
      });

      }
      }),
    );}
  ): Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight:Radius.circular(16),
            topLeft:Radius.circular(16),
            bottomLeft: Radius.circular(16),
          )
        ),
        child: CachedNetworkImage(imageUrl: message));
  }
}
