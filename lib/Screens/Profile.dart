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
    middle_name: '',
    places: [],
    reviews: [],
    conversations: [],
    user_rating: 0.0,
    photo: '',
    description: '',
    dni: '',
    personality: '',
    address: '',
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

class UserProfileScreen extends StatelessWidget {
  final UserProfileController controller = Get.put(UserProfileController());

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
              Get.to(EditProfileScreen());
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
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(controller.user.value.photo), // Mostramos la imagen del usuario
                ),
                SizedBox(height: 10.0),
                Text(
                  '${controller.user.value.first_name} ${controller.user.value.last_name}',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
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
                _buildProfileInformation('First Name', controller.user.value.first_name),
                _buildProfileInformation('Middle Name', controller.user.value.middle_name),
                _buildProfileInformation('Last Name', controller.user.value.last_name),
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
                _buildPersonalInformation('Gender', controller.user.value.gender),
                _buildPersonalInformation('Role', controller.user.value.role),
                _buildPersonalInformation('Email', controller.user.value.email),
                _buildPersonalInformation('Phone Number', controller.user.value.phone_number),
                _buildPersonalInformation('Birth Date', controller.user.value.birth_date),
                _buildPasswordField('Password', controller.user.value.password),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  // Métodos de construcción de bloques de información
  Widget _buildProfileInformation(String label, String value) {
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