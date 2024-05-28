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
   final String? mail;
  final List<String>? partes;

  RegisterScreen({this.mail, this.partes, Key? key }) : super(key: key);

  @override
  _RegisterScreen createState() => _RegisterScreen(mail, partes);
    
  }

  class _RegisterScreen extends State<RegisterScreen> {
    final RegisterScreenController controller = Get.put(RegisterScreenController());
    final String? mail;
    final List<String>? partes;
      
    _RegisterScreen(this.mail, this.partes);


    @override
    void initState() {
      super.initState();
      userService = UserService();
      // Inicializar los campos con los valores proporcionados
      if(mail != null){
        controller.emailController.text = mail!;
      }
      
      if (partes != null && partes!.length >= 3) {
        controller.firstNameController.text = partes![0];
        controller.middleNameController.text = partes![1];
        controller.lastNameController.text = partes![2];

      }
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
                              ParamTextBox(controller: controller.passwordController, text: 'Password'),
                              const SizedBox(height: 15),
                              ParamTextBox(controller: controller.confirmPasswordController, text: 'Confirm Password'),
                              const SizedBox(height: 15),
                              ParamTextBox(controller: controller.emailController, text: 'E-Mail'),
                              const SizedBox(height: 15),
                              ParamTextBox(controller: controller.phoneController, text: 'Phone'),
                              const SizedBox(height: 15),
                              // Nuevo TextField deshabilitado para cumpleaños
                              GestureDetector(
                                onTap: () => controller.selectDate(context),
                                child: AbsorbPointer(
                                  child: Container(
                                    constraints: const BoxConstraints(maxWidth: 400), // Ajusta el ancho máximo según tus necesidades
                                    child: TextField(
                                      controller: controller.birthController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.orange, // Cambia este color al que prefieras
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color.fromARGB(255, 0, 1, 4),
                                            width: 3,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        labelText: '👆 Click here for selecting your birthdate 👆' ,
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
          border: Border.all(color: Colors.black, width: 3),
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
            border: Border.all(color: Colors.black, width: 0.4), // Añadir un borde negro
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
    final TextEditingController confirmPasswordController = TextEditingController();

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
        birthController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Actualizar el controlador de texto con la fecha seleccionada
      }
    }

    void signUp() {
      if (firstNameController.text.isEmpty || middleNameController.text.isEmpty || lastNameController.text.isEmpty || 
        genderController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty || 
        emailController.text.isEmpty || phoneController.text.isEmpty || birthController.text.isEmpty) {
        Get.snackbar(
          'Error', 
          'Please fill the missing fields',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        if ((GetUtils.isEmail(emailController.text) == true) && (passwordController.text.compareTo(confirmPasswordController.text) == 0)) {
          User newUser = User(
            id: "",
            first_name: firstNameController.text,
            middle_name: middleNameController.text,
            last_name: lastNameController.text,
            gender: genderController.text,
            role: 'user',
            password: passwordController.text,
            email: emailController.text,
            phone_number: phoneController.text,
            birth_date: birthController.text,
            photo: '',
            description: '',
            dni: '',
            personality: '',
            address: '',
            emergency_contact: {
              'full_name': '',
              'telephone': '',
            },
            user_rating: 0.0, 
            places: [], reviews: [], conversations: [], housing_offered: [],
          );

          userService.createUser(newUser).then((statusCode) {
            // La solicitud se completó exitosamente, puedes realizar acciones adicionales si es necesario
            print('Usuario creado exitosamente');
            Get.snackbar(
              'User Created!', 
              'User Created Successfully',
              snackPosition: SnackPosition.BOTTOM,
            );
            Get.to(() => const NavigationMenu());
          }).catchError((error) {
            // Manejar errores de solicitud HTTP
            Get.snackbar(
              'Error', 
              'This E-Mail, Phone or Birthdate is not valid',
              snackPosition: SnackPosition.BOTTOM,
            );
            print('Error al enviar usuario al backend: $error');
          });
        } else {
          Get.snackbar(
            'Error', 
            'E-Mail is not valid',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    }
  }
