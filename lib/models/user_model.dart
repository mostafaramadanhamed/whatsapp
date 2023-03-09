class UserModel{
  final String uid;
  final String name;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String>groupId;

  UserModel({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
});
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      isOnline: map['isOnline'] as bool,
      phoneNumber: map['phoneNumber'] as String,
      groupId: map['groupId'] as List<String>,
    );
  }
}