import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

getImgUrl({required String imgName, required Uint8List imgPath,required String folderName}) async {
  final storageRef = FirebaseStorage.instance.ref("$folderName/$imgName");
  // await storageRef.putFile(imgPath!);
  // use this code if u are using flutter web
  UploadTask uploadTask = storageRef.putData(imgPath);
  TaskSnapshot snap = await uploadTask;
  // get the link of the of the photo
  // String url = await storageRef.getDownloadURL();
  // Get img url
  String url = await snap.ref.getDownloadURL();
  return url;
}
