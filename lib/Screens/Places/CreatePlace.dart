import 'dart:typed_data';
import 'package:bankitos_flutter/Screens/Places/GetPlaces.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Widgets/Button.dart';
import 'package:bankitos_flutter/Widgets/TextBox.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Services/PlaceService.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bankitos_flutter/utils/pickImage.dart';
import 'package:bankitos_flutter/Services/cloudinary_service.dart';

late UserService userService;
late PlaceService placeService;

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreen createState() => _CreatePostScreen();
}

class _CreatePostScreen extends State<CreatePostScreen> {
  final CreatePostController controller = Get.put(CreatePostController());

  @override
  void initState() {
    super.initState();
    userService = UserService();
    placeService = PlaceService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text('BanKitos'), SizedBox(width: 60)],
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Create Place',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(height: 15),
              ParamTextBox(
                controller: controller.titleController, 
                text: 'Título'
              ),
              const SizedBox(height: 15),
              ParamTextBox(
                controller: controller.contentController, 
                text: 'Contenido'
              ),
              const SizedBox(height: 15),
              ParamTextBox(
                controller: controller.imageController, 
                text: 'Url de la imágen'
              ),
              const SizedBox(height: 15),
              IconButton(
                icon: Icon(Icons.add_a_photo_outlined),
                onPressed: controller.selectImage,
              ),
              const SizedBox(height: 15),
              ParamTextBox(
                controller: controller.addressController, 
                text: 'Dirección'
              ),
              const SizedBox(height: 15),
              SignInButton(
                onPressed: () => controller.createPost(), 
                text: 'Crear Post'
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class CreatePostController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  bool invalid = false;
  bool parameters = false;

  void selectImage() async {
  try {
    Uint8List img = await pickImage(ImageSource.gallery);
    String? imageUrl = await _cloudinaryService.uploadImage(img);
    if (imageUrl != null) {
      imageController.text = imageUrl;
    } else {
      Get.snackbar('Error', 'Failed to upload image', snackPosition: SnackPosition.BOTTOM);
    }
  } catch (e) {
    Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
  }
}

  void createPost() {
    String id = userService.getUserId();

    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        imageController.text.isEmpty ||
        addressController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Campos vacios',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Place newPlace = Place(
        title: titleController.text,
        content: contentController.text,
        photo: imageController.text,
        authorId: id,
        rating: 1,
        coords: {
          'type': 'Point',
          'coordinates': [0, 0],
        },
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
      placeService.createPlace(newPlace).then((statusCode) {
        print('Place creado exitosamente');
        Get.snackbar(
          '¡Place Creado!',
          'Place creado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.to(() => PlaceListPage());
      }).catchError((error) {
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
