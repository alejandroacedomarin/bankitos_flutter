import 'package:bankitos_flutter/Screens/MyPlacesList.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Widgets/button_sign_in.dart';
import 'package:bankitos_flutter/Widgets/paramTextBox.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Resources/pallete.dart';
import 'package:get/get.dart';

late UserService userService;

class DeletePostScreen extends StatefulWidget {
  final Place place;

  DeletePostScreen({required this.place, Key? key}) : super(key: key);

  @override
  _DeletePostScreenState createState() => _DeletePostScreenState();
}

class _DeletePostScreenState extends State<DeletePostScreen> {
  late DeletePostController controller;

  @override
  void initState() {
    super.initState();
    userService = UserService();
    controller = DeletePostController(widget.place);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('BanKitos'),
              SizedBox(width: 60)
            ],
          ),
        ),
        backgroundColor: Colors.orange,       
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              SizedBox(height: 15),
              Text(
                'Type "Delete this post" for deleting this post',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(177, 0, 0, 0),
                ),
              ),
              SizedBox(height: 10),
              ParamTextBox(
                controller: controller.messageController,
                text: 'Type the message here for deleting this post',
              ),  
              SizedBox(height: 30,),
              SignInButton(
                onPressed: () => controller.deletePost(),
                text: 'Delete this Post',
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class DeletePostController extends GetxController {
  final TextEditingController messageController;

  late Place _existingPlace;

  DeletePostController(this._existingPlace) : messageController = TextEditingController();

  String mensaje = 'delete this post';
  
  void deletePost() {

      String cleanedMessage = messageController.text.trim().toLowerCase(); // Limpiar y convertir a minúsculas

      print('Mensaje ingresado: "${cleanedMessage}"');

    if (cleanedMessage == mensaje) {
      String placeId = _existingPlace.id ?? '';

      print('ID: $placeId');
      userService.deletePlace(placeId).then((statusCode) {
        print('Place eliminado exitosamente');
        Get.snackbar(
          '¡Place Eliminado!',
          'Place eliminado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.to(() => PlaceListPage());
      }).catchError((error) {
        Get.snackbar(
          'Error',
          'Ha ocurrido un error al eliminar el lugar',
          snackPosition: SnackPosition.BOTTOM,
        );
        print('Error al enviar lugar eliminado al backend: $error');
      });
    } else {
      Get.snackbar(
        'Error',
        'Mensaje incorrecto para eliminar el post',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  
  
  }
}
