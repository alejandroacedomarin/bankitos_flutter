import 'package:bankitos_flutter/Screens/Reviews/ViewReviews.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:bankitos_flutter/Widgets/button_sign_in.dart';
import 'package:bankitos_flutter/Widgets/paramTextBox.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

late UserService userService;

class CreateReviewScreen extends StatefulWidget {
  CreateReviewScreen({Key? key}) : super(key: key);

  @override
  _CreateReviewScreen createState() => _CreateReviewScreen();
}

class _CreateReviewScreen extends State<CreateReviewScreen> {
  final CreateReviewController controller = Get.put(CreateReviewController());

  @override
  void initState(){
    super.initState();
    userService = UserService();
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
      // #docregion addWidget
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text('Create Place', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
          
              const SizedBox(height: 40),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.titleController, text: 'Título'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.contentController, text: 'Contenido'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.startsController, text: 'Starts (0-5)'),
              const SizedBox(height: 15),
             
              SignInButton(onPressed: () => controller.createReview(), text: 'Crear Review'),
              const SizedBox(height: 40),
            ],
          ),
        )
      ),
    );
  }
}

class CreateReviewController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController startsController = TextEditingController();

  bool invalid = false;
  bool parameters = false;

  void createReview() {
  String id = userService.getUserId();
  if (titleController.text.isEmpty || contentController.text.isEmpty || startsController.text.isEmpty) {
    Get.snackbar(
      'Error', 
      'Campos vacíos',
      snackPosition: SnackPosition.BOTTOM,
    );
  } else {
    double? stars = double.tryParse(startsController.text);

    if (stars == null) {
      Get.snackbar(
        'Error', 
        'Por favor ingresa un número válido para la puntuación',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      final box = GetStorage();
      // Obtener el id guardado de la caja
      final placeId = box.read('place_id');

      Review newReview = Review(
        title: titleController.text,
        content: contentController.text,
        author: id,
        stars: stars,
        place_id: placeId,
        review_deactivated: false,
        creationDate: DateTime.now(),
        modifiedDate: DateTime.now(),
      );
      print('place_id: ${newReview.place_id}');

      userService.createReview(newReview).then((statusCode) {
        // La solicitud se completó exitosamente, puedes realizar acciones adicionales si es necesario
        Get.snackbar(
          'Review Creado!', 
          'Review creado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.to(() => ViewReviewsScreen());
      }).catchError((error) {
        // Manejar errores de solicitud HTTP
        Get.snackbar(
          'Error', 
          'Ha ocurrido un error',
          snackPosition: SnackPosition.BOTTOM,
        );
        print('Error al enviar el review al backend: $error');
      });
    }
  }
}
}

