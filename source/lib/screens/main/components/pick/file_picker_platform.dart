import 'dart:typed_data';

abstract class FilePickerPlatform {
  Future<List<Uint8List>> pickFiles({bool allowMultiple});
}
