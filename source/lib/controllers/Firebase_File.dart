import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:html' as html;
import 'dart:convert';

Future<String?> uploadFileToFirebase(html.File file) async {
  try {
    String filePath = 'docs/${file.name}';
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(filePath);

    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    await reader.onLoad.first;

    final bytes =
        Base64Decoder().convert(reader.result.toString().split(",").last);
    firebase_storage.UploadTask uploadTask = ref.putData(
        bytes, firebase_storage.SettableMetadata(contentType: file.type));
    firebase_storage.TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print(e);
    return null;
  }
}
