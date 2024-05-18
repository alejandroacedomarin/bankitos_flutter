import 'package:bankitos_flutter/Screens/Reviews/DeleteReview.dart';
import 'package:bankitos_flutter/Screens/Reviews/UpdateReview.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Widgets/button_sign_in.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

late UserService userService;

class ReveiwDetailsPage extends StatelessWidget {
  final Review review;

  const ReveiwDetailsPage(this.review, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    // Guardar el id en la caja
    box.write('review_id', review.id);

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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoBox('Title:', review.title),
                const SizedBox(height: 5),
                _buildInfoBox('Content:', review.content),
                const SizedBox(height: 5),
                _buildInfoBox('Content:', review.stars),
                const SizedBox(height: 20),
                SignInButton(
                  onPressed: () {
                    Get.to(UpdateReviewScreen(review: review));
                  },
                  text: 'Update this Review',
                ),
                const SizedBox(height: 20),
                SignInButton(
                  onPressed: () {
                    Get.to(DeleteReviewScreen(review: review));
                  },
                  text: 'Delete this Review',
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, dynamic content) {
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
        // Verificar si el contenido es de tipo double
        if (content is double)
          Text(
            content.toStringAsFixed(0),
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(177, 0, 0, 0),
            ),
          ),
        // Si no es de tipo double, simplemente mostrarlo como texto
        if (!(content is double))
          Text(
            content.toString(),
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
