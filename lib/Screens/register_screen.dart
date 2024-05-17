import 'dart:ui';
import 'package:bankitos_flutter/Widgets/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Widgets/button_sign_in.dart';
import 'package:bankitos_flutter/Widgets/paramTextBox.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Resources/pallete.dart';
import 'package:get/get.dart';

late UserService userService;

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final RegisterScreenController controller = Get.put(RegisterScreenController());

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
        body: Stack(
        children: [
          // Imagen de fondo
          SizedBox.expand(
            child: Image.asset(
              'assets/ImagenFondoLogin.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Filtro de desenfoque
          SizedBox.expand(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          // Imagen superpuesta con contenido principal
          Center(
            child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [  
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png', // Imagen superpuesta
                      width: 450,
                      height: 450,
                      fit: BoxFit.cover,
                    ),  

                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Container(
                            width: 150, // Ajusta el ancho
                            height: 50, // Ajusta la altura
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(255, 0, 1, 4),
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.orange,
                            ),
                            child: const Text(
                              'REGISTER',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(204, 0, 0, 0),
                              ),
                            ),
                          ),
                         const SizedBox(height: 50),

              ParamTextBox(controller: controller.firstNameController, text: 'First Name'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.middleNameController, text: 'Middle Name'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.lastNameController, text: 'Last Name'),
              const SizedBox(height: 15),
              _buildGenderSelectionField('Gender', controller.genderController),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.roleController, text: 'Role'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.passwordController, text: 'Password'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.emailController, text: 'E-Mail'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.phoneController, text: 'Phone'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.birthController, text: 'Cumpleaños'),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => controller.selectDate(context),
                child: Text('Select Birth Date'),
              ),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.photoController, text: 'Photo URL'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.descriptionController, text: 'Description'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.dniController, text: 'DNI'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.personalityController, text: 'Personality'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.addressController, text: 'Address'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.emergencyNameController, text: 'Emergency Name'),
              const SizedBox(height: 15),
              ParamTextBox(controller: controller.emergencyPhoneController, text: 'Emergency Phone'),
              const SizedBox(height: 15),
              Visibility(
                visible: controller.invalid,
                child: const Text(
                  'Invalid',
                  style: TextStyle(color: Pallete.salmonColor, fontSize: 15),
                ),
              ),
              const SizedBox(height: 15),

                          const SizedBox(height: 40),
                          SignInButton(
                            onPressed: () => controller.signUp(),
                            text: 'Register',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelectionField(String label, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange, // Fondo naranja
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildOption('Male', controller, () => setState(() {})),
                _buildOption('Female', controller, () => setState(() {})),
                _buildOption('Other', controller, () => setState(() {})),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String option, TextEditingController controller, VoidCallback updateState) {
    bool isSelected = controller.text == option;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          controller.text = option;
          updateState(); // Actualizar el estado del widget
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          option,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class RegisterScreenController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController photoController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController personalityController= TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController emergencyPhoneController = TextEditingController();


  bool invalid = false;
  bool parameters = false;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      birthController.text = pickedDate.toString(); // Actualizar el controlador de texto con la fecha seleccionada
    }
  }

  void signUp() {
    if(firstNameController.text.isEmpty || middleNameController.text.isEmpty || lastNameController.text.isEmpty || 
    genderController.text.isEmpty || roleController.text.isEmpty || passwordController.text.isEmpty || 
    emailController.text.isEmpty || phoneController.text.isEmpty || birthController.text.isEmpty || 
    phoneController.text.isEmpty || descriptionController.text.isEmpty || dniController.text.isEmpty || 
    personalityController.text.isEmpty || addressController.text.isEmpty || emergencyNameController.text.isEmpty || 
    emergencyPhoneController.text.isEmpty ){
      Get.snackbar(
        'Error', 
        'Campos vacios',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    else{
      if(GetUtils.isEmail(emailController.text)==true){
        User newUser = User(
          id: "",
      first_name: firstNameController.text,      
      middle_name: middleNameController.text,
      last_name: lastNameController.text,
      gender: genderController.text,
      role: roleController.text,
      password: passwordController.text,
      email: emailController.text,
      phone_number: phoneController.text,
      birth_date: birthController.text,
      photo: photoController.text,
      description: descriptionController.text,
      dni: dniController.text,
      personality: personalityController.text,
      address: addressController.text,
      emergency_contact: {
                        'full_name': emergencyNameController.text,
                        'telephone': emergencyPhoneController.text,
                      },     
      user_rating: 0.0, 
      places: [], reviews: [], conversations: [], housing_offered: [],
      );
        userService.createUser(newUser).then((statusCode) {
          // La solicitud se completó exitosamente, puedes realizar acciones adicionales si es necesario
          print('Usuario creado exitosamente');
          Get.snackbar(
            '¡Usuario Creado!', 
            'Usuario creado correctamente',
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.to(() => const NavigationMenu());
        }).catchError((error) {
          // Manejar errores de solicitud HTTP
          Get.snackbar(
            'Error', 
            'Este E-Mail o Teléfono ya están en uso actualmente.',
            snackPosition: SnackPosition.BOTTOM,
          );
          print('Error al enviar usuario al backend: $error');
        });
      }
      else{
        Get.snackbar(
          'Error', 
          'e-mail no valido',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
