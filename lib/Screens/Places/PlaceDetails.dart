import 'package:bankitos_flutter/Screens/Places/DeletePlace.dart';
import 'package:bankitos_flutter/Screens/Places/UpdatePlace.dart';
import 'package:bankitos_flutter/Screens/Reviews/GetReviews.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Widgets/button_sign_in.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';

late UserService userService;

class PlaceDetailsPage extends StatelessWidget {
  final Place place;

  const PlaceDetailsPage(this.place, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    // Guardar el id en la caja
    box.write('place_id', place.id);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('BanKitos'),
              SizedBox(width: 60),
            ],
          ),
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(
                  '¡Hola!\nHoy me topé con un lugar increíble que definitivamente debes visitar. 🌟 Se llama ' +
                      place.title +
                      '.\nTe invito a que descubras más sobre este lugar y explores otros sitios fascinantes utilizando nuestra aplicación. 😊 \nSimplemente sigue este enlace: https://bankitos.duckdns.org/ . \n\n¡Espero que disfrutes explorando tanto como yo! ✨ \n\n¡Nos vemos allí!');

              Get.snackbar(
                'Bankito compartido con exito',
                'dios te bendiga y dios bendiga america',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoBox('Title:', place.title),
                const SizedBox(height: 5),
                _buildInfoBox('Content:', place.content),
                const SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Image: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(177, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Image.network(place.photo),
                const SizedBox(height: 10),
                _buildInfoBox('ID del autor:', place.authorId),
                const SizedBox(height: 5),
                _buildInfoBox('Dirección:', place.address),
                const SizedBox(height: 5),
                _buildInfoBox('ID:', '${place.id}'),
                const SizedBox(height: 40),
                SignInButton(
                  onPressed: () async {
                    Get.to(ViewReviewsScreen());
                  },
                  text: 'View Reviews',
                ),
                const SizedBox(height: 20),
                SignInButton(
                  onPressed: () {
                    Get.to(UpdatePostScreen(place: place));
                  },
                  text: 'Update this Post',
                ),
                const SizedBox(height: 20),
                SignInButton(
                  onPressed: () {
                    Get.to(DeletePostScreen(place: place));
                  },
                  text: 'Delete this Post',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(177, 0, 0, 0),
            ),
          ),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(177, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }
}
