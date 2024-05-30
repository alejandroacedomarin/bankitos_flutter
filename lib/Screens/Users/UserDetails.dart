import 'package:bankitos_flutter/Screens/MainPage/LogIn.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Widgets/Button.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Screens/Users/UpdateUser.dart';
import 'package:google_sign_in/google_sign_in.dart';

late UserService userService;

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserDetailsController controller = Get.put(UserDetailsController());

  late User user;

  @override
  void initState() {
    super.initState();
    userService = UserService();
    getData();
  }

  void getData() async {
    print('getUser');
    try {
      User fetchedUser = await userService.getUser();
      setState(() {
        user = fetchedUser;
      });
      print(user.id);
    } catch (error) {
      Get.snackbar(
        'Error',
        'No se han podido obtener los datos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error al comunicarse con el backend: $error');
    }
  }

  /* void didUpdateWidget(UserProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Obtiene el usuario cada vez que el widget se actualiza
    user = getToken();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Abrir pantalla de edición
              Get.to(EditProfileScreen(user: user))?.then((_) {
                getData();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Sección de información del perfil
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: _buildStarRating(user.user_rating),
                ),
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: user.photo.isEmpty
                      ? AssetImage('assets/userdefec.png')
                          as ImageProvider<Object>?
                      : NetworkImage(
                          user.photo), // URL de la foto si está disponible
                ),
                const SizedBox(height: 10.0),
                Text(
                  '${user.first_name} ${user.last_name}',
                  style: const TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                ExpansionTile(
                  title: const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        user.description,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Divider(), // Línea separadora
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Information',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                // Bloque de Profile Information
                _buildProfileInformation('First Name', user.first_name),
                _buildProfileInformation('Middle Name', user.middle_name),
                _buildProfileInformation('Last Name', user.last_name),
              ],
            ),
            // Botón de editar
            SizedBox(height: 20.0),
            Divider(), // Línea separadora
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                // Campos de texto para la información personal
                _buildPersonalInformation('Gender', user.gender),
                _buildPersonalInformation('Role', user.role),
                _buildPersonalInformation('Email', user.email),
                _buildPersonalInformation('Phone Number', user.phone_number),
                _buildPersonalInformation('Birth Date', user.birth_date),
                _buildPasswordField('Password', user.password),
              ],
            ),
            SizedBox(height: 20.0),
            const Divider(),
            SignInButton(
              onPressed: () => controller.logOut(),
              text: 'Log Out',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInformation(String label, String value) {
    // Verifica si el valor no está vacío
    if (value.isEmpty) {
      // Si el valor está vacío, no muestra nada
      return SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10.0), // Espacio entre el label y el valor
        Expanded(
          child: Text(
            value,
            overflow:
                TextOverflow.ellipsis, // Ajusta el texto si es demasiado largo
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildPersonalInformation(String label, String value) {
    // Verifica si el valor no está vacío
    if (value.isEmpty) {
      // Si el valor está vacío, no muestra nada
      return SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10.0), // Espacio entre el label y el valor
        Expanded(
          child: Text(
            value,
            overflow:
                TextOverflow.ellipsis, // Ajusta el texto si es demasiado largo
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    print(rating);
    // Calcula las estrellas llenas
    int fullStars = rating.floor();
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow));
    }

    // Calcula la fracción de estrella
    double fraction = rating - fullStars;
    if (fraction > 0) {
      stars.add(Icon(Icons.star_half, color: Colors.yellow));
    }

    // Añade las estrellas vacías restantes
    int emptyStars = 5 - stars.length;
    for (int i = 0; i < emptyStars; i++) {
      stars.add(Icon(Icons.star_border, color: Colors.yellow));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  Widget _buildPasswordField(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10.0), // Espacio entre el label y el valor
        Expanded(
          child: Text(
            '${'*' * value.length}',
            overflow:
                TextOverflow.ellipsis, // Ajusta el texto si es demasiado largo
            style: TextStyle(fontFamily: 'Courier'),
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}

class UserDetailsController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void logOut() async {
    try {
      // Desconectar de Google
      await _googleSignIn.disconnect();
      print('Google Sign Out exitoso');
    } catch (error) {
      print('Error al cerrar sesión en Google: $error');
    }

    // Luego cerrar sesión en la aplicación
    userService.logOut().then((statusCode) {
      // La solicitud se completó exitosamente, puedes realizar acciones adicionales si es necesario
      print('Log Out exitoso');
      Get.snackbar(
        'Log Out',
        'Log Out Successfull',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAll(() => LoginScreen());
    }).catchError((error) {
      // Manejar errores de solicitud HTTP
      Get.snackbar(
        'Error',
        'Error with Log Out',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error al hacer logout: $error');
    });
  } 
}

