import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource image) async{
  final ImagePicker _image = ImagePicker();
  XFile? _file = await _image.pickImage(source: image);
  if(_file!= null){
    return await _file.readAsBytes();
  }
 
}