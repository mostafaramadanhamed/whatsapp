import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/common/enum/message_enum.dart';
import 'package:whatsapp/common/providers/message_reply_provider.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/chat/widgets/message_reply_preview.dart';
import '../../../utils/constant/app_color.dart';
import '../controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({required this.receiverUserId,
  Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton=false;
  bool isShowEmojiContainer=false;
  bool isRecorderInit=false;
  bool isRecording=false;
  FlutterSoundRecorder? _soundRecorder;
  bool isShowEmojiIcon=true;
  FocusNode focusNode=FocusNode();
  final TextEditingController _messageController=TextEditingController();
  void sendTextMessage()async{
    if(isShowSendButton){

      if(_messageController.text.isNotEmpty) {
        ref.read(chatControllerProvider).sendTextMessage(
              context,
              _messageController.text,
              widget.receiverUserId,
            );
        setState((){
          _messageController.clear();
        });
      }
    }
    else{
      var tempDir=await getTemporaryDirectory();
      var path='${tempDir.path}/flutter_sound.aac';
      if(!isRecorderInit){
        return;
      }
      if(isRecording){
       await _soundRecorder!.stopRecorder();
       sendFileMessage(File(path), MessageEnum.audio);
      }else {
        await _soundRecorder!.startRecorder(toFile: path,);
      }
      setState((){
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
      File file,
      MessageEnum messageEnum,
      ){
    ref.read(chatControllerProvider).sendFileMessage(context, file,
      widget.receiverUserId, messageEnum,);
  }

  void selectImage()async{
    File? image=await pickImageFromGallery(context);
    if(image!=null){
      sendFileMessage(image, MessageEnum.image,);
    }
  }
  void selectVideo()async{
    File? video=await pickVideoFromGallery(context);
    if(video!=null){
      sendFileMessage(video, MessageEnum.video,);
    }
  }  void selectGIF()async{
    final gif=await pickedGIF(context);
    if(gif!=null){
      ref.read(chatControllerProvider).sendGIFMessage(context, gif.url, widget.receiverUserId);
    }
  }
  void hideEmojiContainer(){
    setState((){
      isShowEmojiContainer=false;
    });
  }
  void showEmojiContainer(){
    setState((){
      isShowEmojiContainer=true;
    });
  }
  showKeyboard()=>focusNode.requestFocus();
  hideKeyboard()=>focusNode.unfocus();
  void toggleBetweenKeyboardAndEmoji(){
    if(isShowEmojiContainer){
      showKeyboard();
      hideEmojiContainer();
      setState((){
        isShowEmojiIcon=true;
      });
    }
    else{
      hideKeyboard();
      showEmojiContainer();
      setState((){
        isShowEmojiIcon=false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _soundRecorder=FlutterSoundRecorder();
    openAudio();
  }
  void openAudio()async{
    final status=await Permission.microphone.request();
    if(status!= PermissionStatus.granted){
      throw RecordingPermissionException('Microphone not allowed');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit=true;
  }
  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit=false;
  }
  @override
  Widget build(BuildContext context) {
    final messageReply=ref.watch(messageReplyProvider);
    final isShowMessageReply= messageReply !=null;
    return Column(
      children: [
        isShowMessageReply? const MessageReplyPreview():const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val){
                  if(val.isNotEmpty){
                    setState((){
                      isShowSendButton=true;
                    });
                  }else{
                    setState((){
                      isShowSendButton=false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon:SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: toggleBetweenKeyboardAndEmoji,
                             icon: Icon(isShowEmojiIcon?Icons.emoji_emotions:Icons.keyboard, color: Colors.grey,),
                        ), IconButton(
                            onPressed: selectGIF,
                             icon:const Icon(Icons.gif, color: Colors.grey,),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:  [
                        IconButton(
                          onPressed:selectImage,
                          icon:const Icon(Icons.camera_alt_rounded, color: Colors.grey,),
                        ),  IconButton(
                          onPressed: selectVideo,
                          icon:const Icon(Icons.attach_file_rounded, color: Colors.grey,),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding:const  EdgeInsets.only(
                  bottom: 8.0,
                left: 2,
                right: 2,
              ),
              child: GestureDetector(
                onTap:  sendTextMessage,
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF128C7E),
                  radius: 25,
                  child: Icon(
                   isShowSendButton ? Icons.send:isRecording?Icons.close:Icons.mic,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        isShowEmojiContainer ? SizedBox(height:MediaQuery.of(context).size.height/2.9,child: EmojiPicker(
    onEmojiSelected:((category,emoji){
    setState((){
    _messageController.text=_messageController.text+emoji.emoji;
    });
    if(!isShowSendButton){
      setState((){
        if(_messageController.text.isNotEmpty){isShowSendButton=true;}
         else if(_messageController.text.isEmpty){isShowSendButton=true;}
      });
    }
    }),),
        ):const SizedBox(),
      ],
    );
  }
}