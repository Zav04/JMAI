import 'dart:typed_data';
import 'dart:html' as html;
import 'file_picker_platform.dart';

class FilePickerWeb implements FilePickerPlatform {
  @override
  Future<List<Uint8List>> pickFiles({bool allowMultiple = false}) async {
    html.InputElement uploadInput =
        html.FileUploadInputElement() as html.InputElement;
    uploadInput.multiple = allowMultiple;
    uploadInput.click();

    await uploadInput.onChange.first;
    if (uploadInput.files!.isEmpty) return [];

    final files = uploadInput.files!;
    final List<Uint8List> pickedFiles = [];

    for (final file in files) {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;
      pickedFiles.add(Uint8List.fromList(reader.result as List<int>));
    }

    return pickedFiles;
  }
}
