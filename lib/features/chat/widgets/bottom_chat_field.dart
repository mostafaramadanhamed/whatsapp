import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final TextEditingController _messageController=TextEditingController();
  void sendTextMessage(){
    if(isShowSendButton){
      ref.read(chatControllerProvider)
          .sendTextMessage(context, _messageController.text,widget.receiverUserId ,);
      _messageController.clear();
      // todo لو مشتغلش حط setState((){});
      print('object');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
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
                        onPressed: () {  },
                         icon:const Icon(Icons.emoji_emotions, color: Colors.grey,),
                    ), IconButton(
                        onPressed: () {  },
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
                      onPressed: () {  },
                      icon:const Icon(Icons.camera_alt_rounded, color: Colors.grey,),
                    ),  IconButton(
                      onPressed: () {  },
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
          child: CircleAvatar(
            backgroundColor: const Color(0xFF128C7E),
            radius: 25,
            child: InkWell(
              onTap:  sendTextMessage,
              child: Icon(
               isShowSendButton ? Icons.send:Icons.mic,
                color: whiteColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}