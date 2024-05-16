import 'package:bankitos_flutter/Screens/Profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
void updateUser(User newUser) {
    
    GetStorage().write('user', newUser);
}
class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _genderController;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _birthDateController;
  late TextEditingController _photoController;
  late TextEditingController _descriptionController;
  late TextEditingController _dniController;
  late TextEditingController _personalityController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los valores actuales del usuario
    _firstNameController = TextEditingController(text: widget.user.first_name);
    _middleNameController = TextEditingController(text: widget.user.middle_name);
    _lastNameController = TextEditingController(text: widget.user.last_name);
    _genderController = TextEditingController(text: widget.user.gender);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneNumberController = TextEditingController(text: widget.user.phone_number);
    _birthDateController = TextEditingController(text: widget.user.birth_date);
    _passwordController = TextEditingController(text: widget.user.password);
    _photoController = TextEditingController(text: widget.user.photo);
    _descriptionController = TextEditingController(text: widget.user.description);
    _dniController = TextEditingController(text: widget.user.dni);
    _personalityController = TextEditingController(text: widget.user.personality);
    _addressController = TextEditingController(text: widget.user.address);
    

  }

  @override
  void dispose() {
    // Dispose de los controladores al finalizar
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _birthDateController.dispose();
    _photoController.dispose();
    _descriptionController.dispose();
    _dniController.dispose();
    _personalityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            
            
            CircleAvatar(
              radius: 50.0,
              backgroundImage: widget.user.photo.isEmpty
                  ? AssetImage('assets/userdefec.png') as ImageProvider<Object>?
                  : NetworkImage(widget.user.photo),
            ),
            _buildEditableTextField('First Name', _firstNameController),
            _buildEditableTextField('Middle Name', _middleNameController),
            _buildEditableTextField('Last Name', _lastNameController),
            _buildEditableTextField('Gender', _genderController),
            _buildEditableTextField('Dni', _dniController),
            _buildEditableTextField('Email', _emailController),
            _buildEditableTextField('Phone Number', _phoneNumberController),
            _buildEditableTextField('Birth Date', _birthDateController),
            _buildEditableTextField('Password', _passwordController),
            _buildEditableTextField('Address', _addressController),
            _buildEditableTextField('Personality', _personalityController),
            _buildEditableTextField('Description', _descriptionController),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save'),
            ),
          ],
        ),
      ],
      ),
    )
    );
  }

  Widget _buildEditableTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10), // Espaciado entre el texto y el TextField
          Expanded(
            flex: 3,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: controller.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    // Guarda los cambios en el usuario

  // Crea un nuevo usuario con los valores de los controladores
  User updatedUser = User(
    first_name: _firstNameController.text,
    middle_name: _middleNameController.text,
    last_name: _lastNameController.text,
    gender: _genderController.text,
    role: widget.user.role,
    email: _emailController.text,
    phone_number: _phoneNumberController.text,
    birth_date: _birthDateController.text,
    // Inicializa algunos parámetros con valores predeterminados
    password: _passwordController.text,
    places: widget.user.places,
    reviews: widget.user.reviews,
    conversations:widget.user.conversations,
    user_rating: widget.user.user_rating,
    photo: _photoController.text,
    description: _descriptionController.text,
    dni: _dniController.text,
    personality: _personalityController.text,
    address: _addressController.text,
    housing_offered: widget.user.housing_offered,
    emergency_contact: widget.user.emergency_contact,
    user_deactivated: widget.user.user_deactivated,
    creation_date: widget.user.creation_date,
    modified_date: widget.user.modified_date,
  );
  updateUser(updatedUser);
  // Actualiza el usuario en el controlador, si fuera necesario
  print(updatedUser);

  // Regresa a la pantalla anterior
  Navigator.pop(context);
}
    // Actualiza el usuario en el controlador

}