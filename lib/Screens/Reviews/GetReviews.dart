import 'package:bankitos_flutter/Widgets/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:bankitos_flutter/Screens/Reviews/CreateReview.dart';
import 'package:bankitos_flutter/Widgets/Button.dart';
import 'package:bankitos_flutter/Widgets/ReviewWidgets/ReviewButton.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bankitos_flutter/Services/ReviewService.dart';

late ReviewService reviewService;

class ViewReviewsScreen extends StatefulWidget {
  ViewReviewsScreen({Key? key}) : super(key: key);

  @override
  _ViewReviewsScreen createState() => _ViewReviewsScreen();
}

class _ViewReviewsScreen extends State<ViewReviewsScreen> {
  late List<Review> lista_reviews;

  bool isLoading =
      true; // Nuevo estado para indicar si se están cargando los datos

  @override
  void initState() {
    super.initState();
    reviewService = ReviewService();
    final box = GetStorage();
    // Obtener el id guardado de la caja
    final id = box.read('place_id');
    print("PlaceId " + id);
    getReviewsById(id);
  }

  void getReviewsById(id) async {
    print('getReviewsById');

    try {
      print('ID: $id');
      lista_reviews = await reviewService.getReviewsById(id);
      setState(() {
        isLoading =
            false; // Cambiar el estado de carga cuando los datos están disponibles
      });
    } catch (error) {
      Get.snackbar(
        'Error',
        'No se han podido obtener los datos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error al comunicarse con el backend: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Muestra un indicador de carga mientras se cargan los datos
      return Center(child: CircularProgressIndicator());
    } else {
      // Muestra la lista de usuarios cuando los datos están disponibles
      return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('My Places'), SizedBox(width: 60)],
            ),
          ),
          backgroundColor: Colors.orange,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.turn_left,
                color: Colors.black,
              ),
              onPressed: () {
                Get.to(NavigationMenu());
              },
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: lista_reviews.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: PostReviewWidget(review: lista_reviews[index]),
                    );
                  },
                ),
              ),
              SignInButton(
                  onPressed: () {
                    Get.to(CreateReviewScreen());
                  },
                  text: '¡Create a Review!'),
            ],
          ),
        ),
      );
    }
  }
}
