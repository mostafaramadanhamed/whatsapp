enum MessageEnum{
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');


  final String type;

 const MessageEnum(this.type);
}