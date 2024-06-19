import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<Uint8List> pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: source);
  if (image != null) {
    return await image.readAsBytes();
  } else {
    throw Exception('No image selected');
  }
}
