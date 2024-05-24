import 'dart:ui';

import 'package:bankitos_flutter/Screens/google.dart';
import 'package:bankitos_flutter/Widgets/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Screens/register_screen.dart';
import 'package:bankitos_flutter/Widgets/button_sign_in.dart';
import 'package:bankitos_flutter/Widgets/paramTextBox.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Resources/pallete.dart';
import 'package:get/get.dart';

late UserService userService;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final Controller controller = Get.put(Controller());

  @override
  void initState() {
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
              SizedBox(width: 160),
              Text('BanKitos'),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              onPressed: () {
                //Get.to(() => LoginScreen());
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 0, 3, 5),
                backgroundColor: Color.fromARGB(255, 247, 115, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.0),
              ),
              child: Text('Sign In'),
            ),
          ),
          const SizedBox(width: 5),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => RegisterScreen());
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 0, 3, 5),
                backgroundColor: Color.fromARGB(255, 247, 115, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.0),
              ),
              child: Text('Sign Up'),
            ),
          ),
        ],
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
                              'LOG IN',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(204, 0, 0, 0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          ParamTextBox(
                            controller: controller.mailController,
                            text: 'Correo electrónico',
                          ),
                          const SizedBox(height: 15),
                          ParamTextBox(
                            controller: controller.contrasenaController,
                            text: 'Contraseña',
                            obscureText: true,
                          ),
                          const SizedBox(height: 40),
                          SignInButton(
                            onPressed: () => controller.logIn(),
                            text: 'Log In',
                          ),
                          SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.7), // Color de fondo con opacidad
                              borderRadius: BorderRadius.circular(10), // Bordes redondeados
                            ),
                            child: const Text(
                              'Or Sign In with',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              Get.to(() => SignInDemo());
                              // Aquí puedes definir lo que quieres que suceda cuando se presione la imagen
                              print('Botón de Google presionado');
                              // Por ejemplo, puedes iniciar sesión con Google o realizar alguna otra acción
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/logoGoogle.jpg', // Imagen superpuesta
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Controller extends GetxController {
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController mailController = TextEditingController();

  bool invalid = false;
  bool parameters = false;

  void logIn() {
    if (contrasenaController.text.isEmpty || mailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Campos vacios',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      if (GetUtils.isEmail(mailController.text) == true) {
        final logIn = (
          email: mailController.text,
          password: contrasenaController.text,
        );
        userService.logIn(logIn).then((statusCode) {
          print('Login Exitoso');
          Get.to(() => NavigationMenu());
        }).catchError((error) {
          Get.snackbar(
            'Error',
            'Hubo un error con el log in, por favor, inténtelo de nuevo.',
            snackPosition: SnackPosition.BOTTOM,
          );
          print('Error al enviar log in al backend: $error');
        });
      } else {
        Get.snackbar(
          'Error',
          'e-mail no valido',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
