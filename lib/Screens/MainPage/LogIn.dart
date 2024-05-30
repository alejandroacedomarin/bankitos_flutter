import 'dart:async';
import 'dart:convert' show json;
import 'dart:ui';
import 'package:bankitos_flutter/Screens/MainPage/Register.dart';
import 'package:bankitos_flutter/Widgets/Button.dart';
import 'package:bankitos_flutter/Widgets/NavBar.dart';
import 'package:bankitos_flutter/Widgets/TextBox.dart';
import 'package:bankitos_flutter/id.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Resources/pallete.dart';
import 'package:get/get.dart';

late UserService userService;

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: googleClientId,
  scopes: scopes,
);

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final Controller controller = Get.put(Controller());
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; 
  String _contactText = '';
  String mail = '';
  String Token = '';
  String fullName = '';
  String phoneNumber = '';
  String gender = '';
  String birthday = '';
  int i = 0;

  @override
  void initState() {
    super.initState();
    userService = UserService();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      bool isAuthorized = account != null;
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }
      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      if (isAuthorized) {
        await(_handleGetContact(account!));
      }
    });
    _googleSignIn.signInSilently();
  }

//  Future<void> _handleGetContact(GoogleSignInAccount user) async {
//   setState(() {
//     _contactText = 'Loading contact info...';
//   });

//   final http.Response response = await http.get(
//     Uri.parse('https://people.googleapis.com/v1/people/me?personFields=phoneNumbers,emailAddresses,names,addresses,genders,birthdays'),
//     headers: await user.authHeaders
//   );
//   print('Hola: ${response.statusCode}');

//   print('Response: ${response.body}');
  
//   if (response.statusCode == 200) {

//     print("Estoy aqui");
    
//     final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;

//     // Intenta acceder a la información de nombres y correo electrónico
//     final List<dynamic>? names = data['names'] as List<dynamic>?;
//     final List<dynamic>? emailAddresses = data['emailAddresses'] as List<dynamic>?;
//     final List<dynamic>? phoneNumbers = data['phoneNumbers'] as List<dynamic>?;
//     final List<dynamic>? genders = data['genders'] as List<dynamic>?;
//     final List<dynamic>? birthdays = data['birthdays'] as List<dynamic>?;


//     // Verifica si se encontraron datos y accede a ellos si es posible
//     if (names != null && names.isNotEmpty) {
//       final String? fullName = names[0]['displayName'] as String?;
//       print('Full Name: $fullName');

//     }
//     if (emailAddresses != null && emailAddresses.isNotEmpty) {
//       final String? email = emailAddresses[0]['value'] as String?;
//       print('Email: $email');
//     }
//     if (phoneNumbers != null && phoneNumbers.isNotEmpty) {
//       phoneNumber = phoneNumbers[0]['value'] as String;
//       print('Phone Number: $phoneNumber');
//     }
//     if (genders != null && genders.isNotEmpty) {
//       gender = genders[0]['value'] as String;
//       print('Gender: $gender');
//     }
//     if (birthdays != null && birthdays.isNotEmpty) {
//       birthday = birthdays[0]['date'] as String;
//       print('Birthday: $birthday');
//     }

//     setState(() {
//       _contactText = 'Contact info loaded';
//     });

//     // Continuar con el proceso de inicio de sesión o registro
//     // logInOrRegister(email, fullName, phoneNumber, gender, birthday);
//   } else {
//     setState(() {
//       _contactText = 'Error: ${response.statusCode}';
//     });
//   }
// }

Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });

    final http.Response response = await http.get(
      Uri.parse(
          'https://people.googleapis.com/v1/people/me?personFields=phoneNumbers,emailAddresses,names,addresses,genders,birthdays'),
      headers: await user.authHeaders,
    );
    print('Hola: ${response.statusCode}');

    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      print("Estoy aqui");

      final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;

      // Intenta acceder a la información de nombres y correo electrónico
      final List<dynamic>? names = data['names'] as List<dynamic>?;
      final List<dynamic>? emailAddresses = data['emailAddresses'] as List<dynamic>?;
      final List<dynamic>? phoneNumbers = data['phoneNumbers'] as List<dynamic>?;
      final List<dynamic>? genders = data['genders'] as List<dynamic>?;
      final List<dynamic>? birthdays = data['birthdays'] as List<dynamic>?;

      // Guardar los valores en el estado del widget
      if (names != null && names.isNotEmpty) {
        fullName = names[0]['displayName'] as String;
        print('Full Name: $fullName');
      }
      if (emailAddresses != null && emailAddresses.isNotEmpty) {
        mail = emailAddresses[0]['value'] as String;
        print('Email: $mail');
      }
      if (phoneNumbers != null && phoneNumbers.isNotEmpty) {
        phoneNumber = phoneNumbers[0]['value'] as String;
        print('Phone Number: $phoneNumber');
      }
      
      if (birthdays != null && birthdays.isNotEmpty) {
        final Map<String, dynamic> date = birthdays[0]['date'];
        final int? year = date['year'] as int?;
        final int? month = date['month'] as int?;
        final int? day = date['day'] as int?;
        
        if (year != null && month != null && day != null) {
          birthday = '$year-$month-$day';
          print('Birthday: $birthday');
        } else {
          print('Error: Missing year, month, or day in birthday data');
        }
      }

      if (genders != null && genders.isNotEmpty) {
        gender = genders[0]['value'] as String;
        print('Gender: $gender');
      }
      setState(() {
        _contactText = 'Contact info loaded';
      });
      String firstName = '';
            String middleName = '';
            String lastName = '';
            List<String>? partes = [];
              if(fullName != '' ){
                partes = fullName.split(' '); 
                if(partes != null){
                  if(partes.length>=3){
                    firstName = partes[0];
                    middleName = partes[1];
                    lastName = partes[2];
                  }
                  else{
                    firstName = partes[0];
                    lastName = partes[1];
                  }
                }
                // Imprimir las variables para verificar
                print('Primer Nombre: $firstName');
                print('Segundo Nombre: $middleName');
                print('Apellido: $lastName');
              }
              else{
                print('fullName is Empty');
              }
      // Verificar si se deben realizar el registro automático o redirigir al usuario a la pantalla de registro manual
      if (fullName != '' && mail != '' && gender != '' && birthday != '' && phoneNumber != '') {
        // Se tienen todos los valores necesarios para realizar el registro automático
        User newUser = User(
          id: "",
          first_name: firstName,
          middle_name: middleName ,
          last_name: lastName,
          gender: gender,
          role: 'user',
          password: '',
          email: mail ,
          phone_number: phoneNumber,
          birth_date: birthday,
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
          places: [],
          reviews: [],
          conversations: [],
          housing_offered: [],
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
        print('Faltan algunos valores, redirigir al usuario a la pantalla de registro manual');
        if(gender == '' || birthday == '' || phoneNumber == ''){
          Get.to(RegisterScreen(mail: mail, partes: partes, phone: phoneNumber, gen: gender, birthDate: birthday));
        }
        // Faltan algunos valores, redirigir al usuario a la pantalla de registro manual
      }

    } else {
      setState(() {
        _contactText = 'Error: ${response.statusCode}';
      });
    }
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
        (dynamic name) =>
            (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  // Future<void> _handleSignIn() async {          
  //   String phone = '';
  //   String gen = '';
  //   String birthDate = '';

  //   if(i == 1){
  //     try {
  //       i = 0;
  //       final GoogleSignInAccount? account = await _googleSignIn.signIn();
  //       if (account != null) {
  //         final GoogleSignInAuthentication authentication = await account.authentication;

  //         final String accessToken = authentication.accessToken!;
  //         final String email = account.email;
  //         final String? name = account.displayName ;
  //         if(phoneNumber != null){phone = phoneNumber;}
  //         if(gender != null){gen = gender;}
  //         if(birthday != null){birthDate = birthday;}
                
  //         print('Access Token: $accessToken');
  //         print('Email: $email');
  //         print('Name: $name');
  //         print('Phone: $phone');
  //         print('Birth: $birthDate');
  //         print('Gender: $gen');

  //         mail = email;
  //         Token = accessToken;
  //         fullName = name;

  //         print('Access Token 2: $Token');
  //         print('Email 2: $mail');
  //         print('Name 2: $fullName');
  //         print('Phone: $phone');
  //         print('Birth: $birthDate');
  //         print('Gender: $gen');

  //         int response = await userService.logInWithGoogle(Token, mail);

  //         print('Response received in LogIn from Log In with Google: $response');

  //         if(response == -1){        
            
  //           print('Response is -1');

  //           String firstName = '';
  //           String middleName = '';
  //           String lastName = '';
  //           List<String>? partes = [];
  //             if(fullName != null ){
  //               partes = fullName?.split(' '); 
  //               if(partes != null){
  //                 if(partes.length>=3){
  //                   firstName = partes[0];
  //                   middleName = partes[1];
  //                   lastName = partes[2];
  //                 }
  //                 else{
  //                   firstName = partes[0];
  //                   lastName = partes[1];
  //                 }
  //               }
  //               // Imprimir las variables para verificar
  //               print('Primer Nombre: $firstName');
  //               print('Segundo Nombre: $middleName');
  //               print('Apellido: $lastName');
  //               print('Data: $email, $fullName, $phone, $gen, $birthDate');
  //             }
  //             else{
  //               print('fullName is Empty');
  //             }
  //           if(phone != '' || birthDate != '' || gen != ''){
  //             //Tenemos todos los datos --> Se hace el register automáticamente
  //             User newUser = User(
  //               id: "",
  //               first_name: firstName,
  //               middle_name: middleName,
  //               last_name: lastName,
  //               gender: gen,
  //               role: 'user',
  //               password: '',
  //               email: mail,
  //               phone_number: phone,
  //               birth_date: birthDate,
  //               photo: '',
  //               description: '',
  //               dni: '',
  //               personality: '',
  //               address: '',
  //               emergency_contact: {
  //                 'full_name': '',
  //                 'telephone': '',
  //               },
  //               user_rating: 0.0,
  //               places: [], reviews: [], conversations: [], housing_offered: [],
  //             );
  //             userService.createUser(newUser).then((statusCode) {
  //             // La solicitud se completó exitosamente, puedes realizar acciones adicionales si es necesario
  //             print('Usuario creado exitosamente');
  //             Get.snackbar(
  //               'User Created!',
  //               'User Created Successfully',
  //               snackPosition: SnackPosition.BOTTOM,
  //             );
  //             Get.to(() => const NavigationMenu());
  //           }).catchError((error) {
  //             // Manejar errores de solicitud HTTP
  //             Get.snackbar(
  //               'Error',
  //               'This E-Mail, Phone or Birthdate is not valid',
  //               snackPosition: SnackPosition.BOTTOM,
  //             );
  //             print('Error al enviar usuario al backend: $error');
  //           });
  //           }
  //           else{
  //             Get.to(RegisterScreen(mail: mail, partes: partes, phone: phone, gen: gen, birthDate: birthDate));
  //           }
  //         }
  //         else{
  //           Get.snackbar(
  //           'Log In Successful',
  //           'Log In Successful',
  //           snackPosition: SnackPosition.BOTTOM,
  //         );
  //         Get.to(() => NavigationMenu());
  //         }
  //         } else {
  //         print('Inicio de sesión cancelado por el usuario.');
  //       }
  //     } catch (error) {
  //       print('Error al iniciar sesión: $error');
  //     }
  //   }
  // }

  Future<void> _handleSignIn() async {
  try {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account != null) {
      final GoogleSignInAuthentication authentication = await account.authentication;
      
      final String accessToken = authentication.accessToken!;
      final String email = account.email ?? '';
      final String? name = account.displayName ?? '';
      
      // Lógica adicional para manejar el inicio de sesión
      print('Access Token: $accessToken');
      print('Email: $email');
      print('Name: $name');

      // Aquí puedes enviar el token de acceso y la información del usuario a tu backend para autenticar al usuario
    } else {
      print('Inicio de sesión cancelado por el usuario.');
    }
  } catch (error) {
    print('Error al iniciar sesión: $error');
  }
}


  Future<void> _handleSignOut() => _googleSignIn.disconnect();

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
                              i = 1;
                              _handleSignIn();
                              print('Botón de Google presionado');
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