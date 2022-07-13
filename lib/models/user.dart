class MyUser {
  String uid;
  String name;
  String image;
  String? chatId;

  MyUser({
    this.chatId,
    required this.name,
    required this.image,
    required this.uid,
  });
}
