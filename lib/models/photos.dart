class Photos {
  String imgSrc;
  String PhotoName;

  Photos({required this.imgSrc, required this.PhotoName});
  // Api->json ==> // App->Map

  static fromAPI2APP(Map<String, dynamic> photoMap) {
    return Photos(
        imgSrc: (photoMap['src'])['portrait'],
        PhotoName: photoMap['photographer']);
  }
}
