import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<String?> uploadFileFireBase(PlatformFile pickedFile) async {
  try {
    // Obtem o caminho do arquivo e cria um arquivo a partir dele
    File file = File(pickedFile.path!);

    // Define o caminho no Firebase Storage
    String filePath = 'docs/${pickedFile.name}';
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(filePath);

    // Cria a tarefa de upload
    firebase_storage.UploadTask uploadTask = ref.putFile(file);

    // Inicia o upload e espera sua conclusão
    await uploadTask.whenComplete(() {});

    // Retorna a URL do arquivo após o upload
    return await ref.getDownloadURL();
  } catch (e) {
    // Tratamento de exceções
    print(e);
    return null;
  }
}
