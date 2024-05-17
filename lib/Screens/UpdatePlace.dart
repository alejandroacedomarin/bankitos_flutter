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


class UpdatePostScreen extends StatefulWidget {
  final Place place; // Recibe el lugar existente que se va a actualizar

  UpdatePostScreen({required this.place, Key? key}) : super(key: key);

  @override
  _UpdatePostScreenState createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  late UpdatePostController controller;

  @override
  void initState() {
    super.initState();
    userService = UserService();
    controller = UpdatePostController(widget.place); // Pasa el lugar existente al controlador
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
              const SizedBox(height: 40),
              const SizedBox(height: 15),
              const Text(
                              'Title:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(177, 0, 0, 0),
                              ),
                            ),
              const SizedBox(height: 10),
              ParamTextBox(
                controller: controller.titleController,
                text: 'Title',
                initialValue: widget.place.title, // Establece el valor inicial del título
              ),
              const SizedBox(height: 15),
              const Text(
                              'Content:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(177, 0, 0, 0),
                              ),
                            ),
              const SizedBox(height: 10),
              ParamTextBox(
                controller: controller.contentController,
                text: 'Content',
                initialValue: widget.place.content, // Establece el valor inicial del contenido
              ),
              const SizedBox(height: 15),

              const Text(
                              'Image URL:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(177, 0, 0, 0),
                              ),
                            ),
              const SizedBox(height: 10),
              ParamTextBox(
                controller: controller.urlController,
                text: 'Image URL',
                initialValue: widget.place.photo, // Establece el valor inicial del contenido
              ),
                            const SizedBox(height: 15),

              const Text(
                              'Address:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(177, 0, 0, 0),
                              ),
                            ),
              const SizedBox(height: 10),
              ParamTextBox(
                controller: controller.addressController,
                text: 'Address',
                initialValue: widget.place.address, // Establece el valor inicial del contenido
              ),
              SizedBox(height: 40,),
              // Otras ParamTextBox para los demás campos con sus valores iniciales correspondientes
              SignInButton(
                onPressed: () => controller.updatePost(),
                text: '¡Update this Place!',
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdatePostController extends GetxController {
  final TextEditingController titleController;
  final TextEditingController contentController;
    final TextEditingController urlController;
    final TextEditingController addressController;

  // Otros controladores de texto para los demás campos

  late Place _existingPlace;

 UpdatePostController(Place existingPlace)
    : _existingPlace = existingPlace,
      titleController = TextEditingController(text: existingPlace.title),
      contentController = TextEditingController(text: existingPlace.content),
      urlController = TextEditingController(text: existingPlace.photo),
      addressController= TextEditingController(text: existingPlace.address);


  void updatePost() {
  // Obtén los nuevos valores del lugar del controlador de texto
  _existingPlace.title = titleController.text;
  _existingPlace.content = contentController.text;
    _existingPlace.photo = urlController.text;
  _existingPlace.address = addressController.text;


  // Actualiza otros campos según sea necesario

  String placeId = _existingPlace.id ?? '';

  print('ID: $placeId');
  // Llama al servicio para actualizar el lugar
  userService.updatePlace(_existingPlace, placeId).then((statusCode) {
    // La solicitud se completó exitosamente, puedes realizar acciones adicionales si es necesario
    print('Place actualizado exitosamente');
    Get.snackbar(
      '¡Place Actualizado!',
      'Place actualizado correctamente',
      snackPosition: SnackPosition.BOTTOM,
      
    );

      Get.to(() => PlaceListPage());
  }).catchError((error) {
    // Manejar errores de solicitud HTTP
    Get.snackbar(
      'Error',
      'Ha ocurrido un error al actualizar el lugar',
      snackPosition: SnackPosition.BOTTOM,
    );
    print('Error al enviar lugar actualizado al backend: $error');
  });
}
}