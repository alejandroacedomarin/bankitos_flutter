import 'package:bankitos_flutter/Screens/Reviews/GetReviews.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:bankitos_flutter/Widgets/Button.dart';
import 'package:bankitos_flutter/Widgets/TextBox.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Services/ReviewService.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:bankitos_flutter/Widgets/ReviewWidgets/StarsReview.dart';

late UserService userService;
late ReviewService reviewService;

class CreateReviewScreen extends StatefulWidget {
  CreateReviewScreen({Key? key}) : super(key: key);

  @override
  _CreateReviewScreenState createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final CreateReviewController controller = Get.put(CreateReviewController());

  @override
  void initState() {
    super.initState();
    userService = UserService();
    reviewService = ReviewService();
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
              SizedBox(width: 60),
            ],
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              const Text(
                'Create Review',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              SizedBox(height: 40),
              SizedBox(height: 15),
              ParamTextBox(
                  controller: controller.titleController, text: 'Título'),
              SizedBox(height: 15),
              ParamTextBox(
                  controller: controller.contentController, text: 'Contenido'),
              SizedBox(height: 15),
              // Reemplazar ParamTextBox por StarRating
              StarRating(
                initialRating:
                    0.0, // Puedes definir una calificación inicial si es necesario
                onRatingChanged: (double rating) {
                  // Actualiza el valor de las estrellas en el controlador
                  controller.startsController.text = rating.toString();
                },
              ),
              SizedBox(height: 15),
              SignInButton(
                onPressed: () => controller.createReview(),
                text: 'Crear Review',
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateReviewController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController startsController = TextEditingController();

  void createReview() {
    String id = userService.getUserId();
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        startsController.text.isEmpty) {
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

        reviewService.createReview(newReview).then((statusCode) {
          // La solicitud se completó exitosamente, puedes realizar acciones adicionales si es necesario
          Get.snackbar(
            'Review Creado!',
            'Review creado correctamente',
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.to(() => ViewReviewsScreen());

          // Limpiar los textboxes después de crear el review
          titleController.clear();
          contentController.clear();
          startsController.clear();
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
