import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Resources/pallete.dart';

class ParamTextBox extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  ParamTextBox({Key? key, required this.controller, required this.text}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.orange, // Cambia este color al que prefieras
          enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 0, 1, 4),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
            color: Color.fromARGB(255, 7, 4, 3),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
          ),
          hintText: text,
          
        ),
        
      ),
    );
  }
}