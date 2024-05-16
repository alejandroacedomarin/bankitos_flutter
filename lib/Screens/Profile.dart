
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Screens/EditProfile.dart';

class UserProfileController extends GetxController {
  final user = User(
    first_name: 'John',
    last_name: 'Doe',
    gender: 'Male',
    role: 'User',
    password: 'password123',
    email: 'john@example.com',
    phone_number: '1234567890',
    birth_date: '1990-01-01',
    middle_name: 'Diiioooosss',
    places: [],
    reviews: [],
    conversations: [],
    user_rating: 3.7,
    photo: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVmX1T3VLwWgvuQtQye5EbgUMAZZcK3_Tgjg&s',
    description: 'AAALALALALALALALALALLALA',
    dni: '77777777',
    personality: 'Interesante',
    address: 'Carrer del GG',
    housing_offered: [],
    emergency_contact: {},
    user_deactivated: false,
    creation_date: DateTime.now(),
    modified_date: DateTime.now(),
  ).obs;
  
  void updateUser(User newUser) {
    user(newUser);
    GetStorage().write('user', newUser.toJson());
  }
}
void updateUser(User newUser) {
    
    GetStorage().write('user', newUser);
  }
User getToken(){
    final box = GetStorage();
    return box.read('user');
}

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late User user;

  @override
  void initState() {
    super.initState();
     updateUser(User(
    first_name: 'John',
    last_name: 'Doe',
    gender: 'Male',
    role: 'User',
    password: 'password123',
    email: 'john@example.com',
    phone_number: '1234567890',
    birth_date: '1990-01-01',
    middle_name: 'Diiioooosss',
    places: [],
    reviews: [],
    conversations: [],
    user_rating: 3.7,
    photo: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVmX1T3VLwWgvuQtQye5EbgUMAZZcK3_Tgjg&s',
    description: 'AAALALALALALALALALALLALA',
    dni: '77777777',
    personality: 'Interesante',
    address: 'Carrer del GG',
    housing_offered: [],
    emergency_contact: {},
    user_deactivated: false,
    creation_date: DateTime.now(),
    modified_date: DateTime.now(),
  ));
    user = getToken();
  }

  @override
  void didUpdateWidget(UserProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Obtiene el usuario cada vez que el widget se actualiza
    user = getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Abrir pantalla de edición
              Get.to(EditProfileScreen(user: user))?.then((_) {
                 setState(() {
                 user = getToken();
                 });
    
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
                      ? AssetImage('assets/userdefec.png') as ImageProvider<Object>?
                      : NetworkImage(user.photo), // URL de la foto si está disponible
                ),
                SizedBox(height: 10.0),
                Text(
                  '${user.first_name} ${user.last_name}',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.0),
                ExpansionTile(
                  title: Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        user.description,
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Divider(), // Línea separadora
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
          overflow: TextOverflow.ellipsis, // Ajusta el texto si es demasiado largo
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
          overflow: TextOverflow.ellipsis, // Ajusta el texto si es demasiado largo
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
            overflow: TextOverflow.ellipsis, // Ajusta el texto si es demasiado largo
            style: TextStyle(fontFamily: 'Courier'),
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}