import 'dart:ui';
import 'package:bankitos_flutter/Widgets/Button.dart';
import 'package:bankitos_flutter/Widgets/NavBar.dart';
import 'package:bankitos_flutter/utils/insultos.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Widgets/TextBox.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Resources/pallete.dart';
import 'package:get/get.dart';
import 'package:safe_text/safe_text.dart';

late UserService userService;

class RegisterScreen extends StatefulWidget {
  final String? mail;
  final List<String>? partes;
  final String? gen;
  final String? phone;
  final String? birthDate;

  RegisterScreen({this.mail, this.partes, this.gen, this.phone, this.birthDate, Key? key }) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState(mail, partes, gen, phone, birthDate);
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterScreenController controller = Get.put(RegisterScreenController());
  final String? mail;
  final List<String>? partes;
  final String? gen;
  final String? phone;
  final String? birthDate;
      
  _RegisterScreenState(this.mail, this.partes, this.gen, this.phone, this.birthDate);

  @override
  void initState() {
    super.initState();
    userService = UserService();
    // Inicializar los campos con los valores proporcionados
    if(mail != null){
      print('mail no null');
      controller.emailController.text = mail!;
    }
    if (partes != null && partes!.length >= 3) {
      controller.firstNameController.text = partes![0];
      controller.middleNameController.text = partes![1];
      controller.lastNameController.text = partes![2];
    }
    else if(partes != null){
      controller.firstNameController.text = partes![0];
      controller.lastNameController.text = partes![1];
    }
    if(gen != null){
      print('Gen no null');
      controller.genderController.text = gen!;
    }
    if(phone != null){
      print('phone no null');
      controller.phoneController.text = phone!;
    }
    if(birthDate != null){
      print('birthDate no null');
      controller.birthController.text = birthDate!;
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
                            ParamTextBox(controller: controller.middleNameController, text: 'Middle Name (Optional)'),
                            const SizedBox(height: 15), //Middle name opcional
                            ParamTextBox(controller: controller.lastNameController, text: 'Last Name'),
                            const SizedBox(height: 15),
                            ParamTextBox(controller: controller.emailController, text: 'E-Mail'),
                            const SizedBox(height: 15),
                            Obx(() => Column(
                              children: [
                                ParamTextBox(controller: controller.passwordController, text: 'Password'),
                                if (controller.passwordError.isNotEmpty)
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      controller.passwordError.value,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            )),
                          const SizedBox(height: 15), 
                          //Tiene que tener 
                          /*
                          2 mayúsculas
                          2 números
                          1 caracter especial
                          8 caracteres mínimo
                          */
                            //Tiene que tener 
                            /*
                            2 mayúsculas
                            2 números
                            1 caracter especial
                            8 caracteres mínimo
                            */
                            ParamTextBox(controller: controller.confirmPasswordController, text: 'Confirm Password'),
                            const SizedBox(height: 15),
                            ParamTextBox(controller: controller.phoneController, text: 'Phone'),
                            const SizedBox(height: 15),
                            _buildGenderSelectionField('Gender', controller.genderController),
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

  var passwordError = ''.obs;

  RegisterScreenController() {
    passwordController.addListener(_validatePasswordInRealTime);
  }

  String badWords(String text){
    print("badWords");
    String filteredText = SafeText.filterText(
      text: text,
      extraWords: insultos,
      //excludedWords: ["exclude", "these", "words"],
      useDefaultWords: true,
      fullMode: true,
      obscureSymbol: "*",
    );
    print('Clear text: | $text | ------- Filtered text: | $filteredText |');
    return filteredText;
  }

  bool invalid = false;
  bool parameters = false;

  void _validatePasswordInRealTime() {
    String password = passwordController.text;
    if (password.length < 8 ||
        !RegExp(r'(?=.*[A-Z].*[A-Z])').hasMatch(password) ||
        !RegExp(r'(?=.*\d.*\d)').hasMatch(password) ||
        !RegExp(r'(?=.*[@$!%*?&.])').hasMatch(password)) {
      passwordError.value = 'Password must have at least 8 characters, 2 uppercase letters, 2 numbers, and 1 special character.';
    } else {
      passwordError.value = '';
    }
  }

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
    bool badWordExists = false;
    String badWordExists1 = '';
    String badWordExists2 = '';
    String badWordExists3 = '';
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty ||
        genderController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty ||
        emailController.text.isEmpty || phoneController.text.isEmpty || birthController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill the missing fields',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      if ((GetUtils.isEmail(emailController.text) == true) && (passwordController.text.compareTo(confirmPasswordController.text) == 0)) {
        print('badwords empieza');
        badWordExists1 = badWords(firstNameController.text);
        if(badWordExists1.compareTo(firstNameController.text)!=0){
          badWordExists = true;
        }
        badWordExists2 = badWords(middleNameController.text);
        if(badWordExists2.compareTo(middleNameController.text)!=0){
          badWordExists = true;
        }
        badWordExists3 = badWords(lastNameController.text);
        if(badWordExists3.compareTo(lastNameController.text)!=0){
          badWordExists = true;
        }
        if(badWordExists){
           Get.snackbar(
            'Error',
            'Insults are not allowed in the registry',
            snackPosition: SnackPosition.BOTTOM,
          );
          print('Bad Word Detected');
        }
        else{
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
        }
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