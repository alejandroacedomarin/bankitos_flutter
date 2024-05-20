import 'package:bankitos_flutter/Screens/Reviews/ViewReviews.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:bankitos_flutter/Widgets/button_sign_in.dart';
import 'package:bankitos_flutter/Widgets/paramTextBox.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:get/get.dart';

late UserService userService;

class DeleteReviewScreen extends StatefulWidget {
  final Review review;

  DeleteReviewScreen({required this.review, Key? key}) : super(key: key);

  @override
  _DeleteReviewScreen createState() => _DeleteReviewScreen();
}

class _DeleteReviewScreen extends State<DeleteReviewScreen> {
  late DeleteReviewController controller;

  @override
  void initState() {
    super.initState();
    userService = UserService();
    controller = DeleteReviewController(widget.review);
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
                'Type "Delete this review" for deleting this review',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(177, 0, 0, 0),
                ),
              ),
              SizedBox(height: 10),
              ParamTextBox(
                controller: controller.messageController,
                text: 'Type the message here for deleting this reveiw',
              ),  
              SizedBox(height: 30,),
              SignInButton(
                onPressed: () => controller.deleteReview(),
                text: 'Delete this Review',
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteReviewController extends GetxController {
  final TextEditingController messageController;

  late Review _existingReview;

  DeleteReviewController(this._existingReview) : messageController = TextEditingController();

  String mensaje = 'delete this review';
  
  void deleteReview() {

      String cleanedMessage = messageController.text.trim().toLowerCase(); // Limpiar y convertir a minúsculas

      print('Mensaje ingresado: "${cleanedMessage}"');

    if (cleanedMessage == mensaje) {
      String reviewId = _existingReview.id ?? '';

      print('ID: $reviewId');
      userService.deleteReview(reviewId).then((statusCode) {
        print('Review eliminado exitosamente');
        Get.snackbar(
          'Review Eliminado!',
          'Review eliminado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.to(() => ViewReviewsScreen());
      }).catchError((error) {
        Get.snackbar(
          'Error',
          'Este review no es tuyo no puedes Eliminarlo!!',
          snackPosition: SnackPosition.BOTTOM,
        );
        print('Error al enviar review eliminado al backend: $error');
      });
    } else {
      Get.snackbar(
        'Error',
        'Mensaje incorrecto para eliminar el review',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

