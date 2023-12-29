import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'file_picker_platform.dart';

class FilePickerMobile implements FilePickerPlatform {
  @override
  Future<List<Uint8List>> pickFiles({bool allowMultiple = false}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
    );

    if (result == null) {
      return [];
    }

    List<Uint8List> filesData = [];
    for (var file in result.files) {
      if (file.bytes != null) {
        filesData.add(file.bytes!);
      }
    }
    return filesData;
  }
}
