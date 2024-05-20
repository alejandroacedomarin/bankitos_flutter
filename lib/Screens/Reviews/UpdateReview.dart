import 'package:bankitos_flutter/Screens/Reviews/ViewReviews.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:bankitos_flutter/Widgets/button_sign_in.dart';
import 'package:bankitos_flutter/Widgets/paramTextBox.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:get/get.dart';

late UserService userService;


class UpdateReviewScreen extends StatefulWidget {
  final Review review; // Recibe el lugar existente que se va a actualizar

  UpdateReviewScreen({required this.review, Key? key}) : super(key: key);

  @override
  _UpdateReviewScreen createState() => _UpdateReviewScreen();
}

class _UpdateReviewScreen extends State<UpdateReviewScreen> {
  late UpdateReviewController controller;

  @override
  void initState() {
    super.initState();
    userService = UserService();
    controller = UpdateReviewController(widget.review); // Pasa el lugar existente al controlador
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
                initialValue: widget.review.title, // Establece el valor inicial del título
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
                initialValue: widget.review.content, // Establece el valor inicial del contenido
              ),
              const SizedBox(height: 15),
              const Text(
                              'Stars:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(177, 0, 0, 0),
                              ),
                            ),
              const SizedBox(height: 10),
              ParamTextBox(
                controller: controller.starsController,
                text: 'Stars',
                initialValue: widget.review.stars.toString(), // Establece el valor inicial del stars
              ),
              SizedBox(height: 40,),
              // Otras ParamTextBox para los demás campos con sus valores iniciales correspondientes
              SignInButton(
                onPressed: () => controller.updateReview(),
                text: '¡Update this Review!',
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateReviewController extends GetxController {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController starsController;

  // Otros controladores de texto para los demás campos

  late Review _existingReview;
  
 UpdateReviewController(Review existingReview)
 
    : _existingReview = existingReview,
      titleController = TextEditingController(text: existingReview.title),
      contentController = TextEditingController(text: existingReview.content),
      starsController = TextEditingController(text: existingReview.stars.toStringAsFixed(0));


  void updateReview() {

    // Obtén los nuevos valores del review del controlador de texto
    _existingReview.title = titleController.text;
    _existingReview.content = contentController.text;
     try {
    _existingReview.stars = double.parse(starsController.text);
    // Si la conversión tiene éxito, el código dentro de este bloque se ejecutará
  } catch (e) {
    print('Error al convertir el texto a double: $e');
    Get.snackbar(
      'Error',
      'No has escrito un numero en el campo stars',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Actualiza otros campos según sea necesario

  String reviewId = _existingReview.id ?? '';

  print('ID: $reviewId');
  // Llama al servicio para actualizar el lugar
  userService.updateReview(_existingReview, reviewId).then((statusCode) {
    // La solicitud se completó exitosamente, puedes realizar acciones adicionales si es necesario
    print('Review actualizado exitosamente');
    Get.snackbar(
      'Review Actualizado!',
      'Review actualizado correctamente',
      snackPosition: SnackPosition.BOTTOM,
    );
      Get.to(() => ViewReviewsScreen());
  }).catchError((error) {
    // Manejar errores de solicitud HTTP
    Get.snackbar(
      'Error',
      'No es un review tuyo',
      snackPosition: SnackPosition.BOTTOM,
    );
    print('Error al enviar review actualizado al backend: $error');
  });
}
}