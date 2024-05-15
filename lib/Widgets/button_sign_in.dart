import 'package:flutter/material.dart';
import '../Resources/pallete.dart';

class SignInButton extends StatelessWidget {
  final String text; 
  final VoidCallback onPressed;
  const SignInButton({Key? key, required this.onPressed, required this.text}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(400, 55),
        backgroundColor: Colors.orange,
        foregroundColor: Color.fromARGB(198, 0, 0, 0),
      ),
      child: Text(text, style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 17,
      ),),
    );
  }
}