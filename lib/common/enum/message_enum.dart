enum MessageEnum{
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');


  final String type;

 const MessageEnum(this.type);
}
extension ConvertMessage on String{
  MessageEnum toEnum(){
    switch(this){
      case 'audio':
        return MessageEnum.audio;
        case 'image':
        return MessageEnum.image;
        case 'video':
        return MessageEnum.video;
        case 'text':
        return MessageEnum.text;
        case 'gif':
        return MessageEnum.gif;
      default:
        return MessageEnum.text;
    }
  }
}