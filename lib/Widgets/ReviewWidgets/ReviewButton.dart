//import 'package:bankitos_flutter/Screens/ReviewDetails.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:bankitos_flutter/Screens/Reviews/ReviewDetails.dart';
import 'package:get/get.dart';

class PostReviewWidget extends StatelessWidget {
  final Review review;

  const PostReviewWidget({Key? key, required this.review}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return Card(
      child: Container(
        color: Colors.orange, // Establece el fondo del Container a naranja
        child: ListTile(
          title: Text(review.title, style: TextStyle(color: const Color.fromARGB(199, 0, 0, 0))), // Cambia el color del texto si es necesario
          subtitle: Text(review.content, style: TextStyle(color: const Color.fromARGB(168, 0, 0, 0))), // Cambia el color del texto si es necesario
          onTap: () {
          Get.to(() => ReveiwDetailsPage(review));
          },
        ),
      ),
    );
  }
}
