import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/common/enum/message_enum.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF(
      {Key? key, required this.message, required this.type,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type==MessageEnum.text? Text(
      message,
      style: const TextStyle(
        fontSize: 16,
      ),
    ):Container(
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