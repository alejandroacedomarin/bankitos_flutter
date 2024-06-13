import 'dart:async';
import 'dart:convert';
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
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:get/get.dart';
import 'package:safe_text/safe_text.dart';

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
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Controller controller = Get.put(Controller());
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; 
  String _contactText = '';
  String mail = '';
  String token = '';
  String idToken1 = '';
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
        await _handleGetContact(account!);
      }
    });
    _googleSignIn.signInSilently(); 
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });

    final http.Response response = await http.get(
      Uri.parse(
          'https://people.googleapis.com/v1/people/me?personFields=phoneNumbers,emailAddresses,names,addresses,genders,birthdays'),
      headers: await user.authHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;

      _extractUserData(data);

      setState(() {
        _contactText = 'Contact info loaded';
      });
      print('token previo login with google: $token');
      print('mail previo login with google: $mail');
      print('idtoken previo login with google: $idToken1');

      int responseCode = await userService.logInWithGoogle(token, mail, idToken1);

      if (responseCode == -1) {
        _autoRegisterUser();
      } else {
        Get.snackbar(
          'Log In Successful',
          'Log In Successful',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.to(() => NavigationMenu());
      }
    } else {
      setState(() {
        _contactText = 'Error: ${response.statusCode}';
      });
    }
  }

  void _extractUserData(Map<String, dynamic> data) {
    final List<dynamic>? names = data['names'] as List<dynamic>?;
    final List<dynamic>? emailAddresses = data['emailAddresses'] as List<dynamic>?;
    final List<dynamic>? phoneNumbers = data['phoneNumbers'] as List<dynamic>?;
    final List<dynamic>? genders = data['genders'] as List<dynamic>?;
    final List<dynamic>? birthdays = data['birthdays'] as List<dynamic>?;

    if (names != null && names.isNotEmpty) {
      fullName = names[0]['displayName'] as String;
    }
    if (emailAddresses != null && emailAddresses.isNotEmpty) {
      mail = emailAddresses[0]['value'] as String;
    }
    if (phoneNumbers != null && phoneNumbers.isNotEmpty) {
      phoneNumber = phoneNumbers[0]['value'] as String;
    }
    if (birthdays != null && birthdays.isNotEmpty) {
      final Map<String, dynamic> date = birthdays[0]['date'];
      final int? year = date['year'] as int?;
      final int? month = date['month'] as int?;
      final int? day = date['day'] as int?;

      if (year != null && month != null && day != null) {
        birthday = '$year-$month-$day';
      }
    }
    if (genders != null && genders.isNotEmpty) {
      gender = genders[0]['value'] as String;
    }
  }

  Future<void> _autoRegisterUser() async {
    String firstName = '';
    String middleName = '';
    String lastName = '';
    List<String>? partes = fullName.split(' ');

    if (partes != null) {
      if (partes.length >= 3) {
        firstName = partes[0];
        middleName = partes[1];
        lastName = partes[2];
      } else {
        firstName = partes[0];
        lastName = partes[1];
      }
    }

    if (fullName.isNotEmpty && mail.isNotEmpty && gender.isNotEmpty && birthday.isNotEmpty && phoneNumber.isNotEmpty) {
      User newUser = User(
        id: "",
        first_name: firstName,
        middle_name: middleName,
        last_name: lastName,
        gender: gender,
        role: 'user',
        password: '',
        email: mail,
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

      try {
        await userService.createUser(newUser);
        Get.snackbar(
          'User Created!',
          'User Created Successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.to(() => const NavigationMenu());
      } catch (error) {
        Get.snackbar(
          'Error',
          'This E-Mail, Phone or Birthdate is not valid',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.to(RegisterScreen(mail: mail, partes: partes, phone: phoneNumber, gen: gender, birthDate: birthday));
    }
  }

  Future<void> _handleSignIn() async {
  try {
    final GoogleSignInAccount? account = null; //await _googleSignIn.signIn();
    if (account != null) {
      final GoogleSignInAuthentication authentication = await account.authentication;

      final String? accessToken = authentication.accessToken;

      if (accessToken != null) {
        token = accessToken;
        mail = account.email;
        fullName = account.displayName ?? '';
        idToken1 = authentication.idToken ?? 'empty';
        
        print('Id Token: $idToken1');
        print("Token: $token");
        print("Email: $mail");
        await _handleGetContact(account);
      } else {
        print('Failed to get access token');
      }
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
        automaticallyImplyLeading: false,
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
                _handleSignIn();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 0, 3, 5),
                backgroundColor: const Color.fromARGB(255, 247, 115, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
              ),
              child: const Text('Sign In'),
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
                backgroundColor: const Color.fromARGB(255, 247, 115, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
              ),
              child: const Text('Sign Up'),
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
                                color: const Color.fromARGB(255, 0, 1, 4),
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
                          const SizedBox(height: 30),
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

  void logIn() {
    if (contrasenaController.text.isEmpty || mailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Campos vacios',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      if (GetUtils.isEmail(mailController.text)) {
        final logInData = (
          email: mailController.text,
          password: contrasenaController.text,
        );
        userService.logIn(logInData).then((statusCode) {
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
