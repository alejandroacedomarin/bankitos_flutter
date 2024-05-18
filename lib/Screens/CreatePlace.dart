import 'package:bankitos_flutter/Screens/MyPlacesList.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Widgets/button_sign_in.dart';
import 'package:bankitos_flutter/Widgets/paramTextBox.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:get/get.dart';

late UserService userService;

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreen createState() => _CreatePostScreen();
}

class _CreatePostScreen extends State<CreatePostScreen> {
  final CreatePostController controller = Get.put(CreatePostController());

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
               ParamTextBox(controller: controller.autorController, text: 'ID del autor'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.imageController, text: 'Url de la imágen'),
              const SizedBox(height: 15),
               ParamTextBox(controller: controller.addressController, text: 'Dirección'),
              const SizedBox(height: 15),
             
              SignInButton(onPressed: () => controller.createPost(), text: 'Crear Post'),
              const SizedBox(height: 40),
            ],
          ),
        )
      ),
    );
  }
}

class CreatePostController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController autorController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  

  bool invalid = false;
  bool parameters = false;


  void createPost() {
    if(titleController.text.isEmpty || contentController.text.isEmpty || imageController.text.isEmpty || autorController.text.isEmpty || addressController.text.isEmpty){
      Get.snackbar(
        'Error', 
        'Campos vacios',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    else{
        Place newPlace = Place(
          title: titleController.text,
          content: contentController.text,
          photo: imageController.text,
          authorId: autorController.text,
          rating: 1,
          latitude: 1,
          longitude: 1,
          isBankito: true,
          isPublic: true,
          isCovered: true,
          schedule: {
            'monday': '9:00 AM - 5:00 PM',
            'tuesday': '9:00 AM - 5:00 PM',
            'wednesday': '9:00 AM - 5:00 PM',
            'thursday': '9:00 AM - 5:00 PM',
            'friday': '9:00 AM - 5:00 PM',
            'saturday': 'Closed',
            'sunday': 'Closed',
          },
          address: addressController.text,
          placeDeactivated: false,
          creationDate: DateTime.now(),
          modifiedDate: DateTime.now(),
        );
        userService.createPlace(newPlace).then((statusCode) {
          // La solicitud se completó exitosamente, puedes realizar acciones adicionales si es necesario
          print('Place creado exitosamente');
          Get.snackbar(
            '¡Place Creado!', 
            'Place creado correctamente',
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.to(() => PlaceListPage());
        }).catchError((error) {
          // Manejar errores de solicitud HTTP
          Get.snackbar(
            'Error', 
            'Ha ocurrido un error',
            snackPosition: SnackPosition.BOTTOM,
          );
          print('Error al enviar place al backend: $error');
        });
    }
  }
}


