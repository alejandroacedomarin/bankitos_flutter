import 'package:bankitos_flutter/Screens/PlaceDetails.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Resources/pallete.dart';
import 'package:get/get.dart';

class PostWidget extends StatelessWidget {
  final Place place;

  const PostWidget({Key? key, required this.place}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return Card(
      child: Container(
        color: Colors.orange, // Establece el fondo del Container a naranja
        child: ListTile(
          title: Text(place.title, style: TextStyle(color: const Color.fromARGB(199, 0, 0, 0))), // Cambia el color del texto si es necesario
          subtitle: Text(place.content, style: TextStyle(color: const Color.fromARGB(168, 0, 0, 0))), // Cambia el color del texto si es necesario
          onTap: () {
            Get.to(() => PlaceDetailsPage(place));
          },
        ),
      ),
    );
  }
}
