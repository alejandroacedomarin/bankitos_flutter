import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:flutter/material.dart';

class PlaceWidget extends StatelessWidget {
  final Place place;

  const PlaceWidget({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: Colors.transparent,
        leading: CircleAvatar(
          radius: 50.0,
          backgroundImage: place.photo.isEmpty
              ? AssetImage('assets/userdefec.png') as ImageProvider<Object>?
              : NetworkImage(place.photo), // URL de la foto si está disponible
        ),
        title: Text(place.title),
        subtitle: Row(
          children: [
            Icon(Icons.star, color: Colors.yellow), // Yellow star icon
            SizedBox(width: 4.0), // Space between the icon and text
            Text(place.rating.toString()),
          ],
        ),
        onTap: () {
          //Get.to(() => PlaceDetails(user));
        },
      ),
    );
  }
}
