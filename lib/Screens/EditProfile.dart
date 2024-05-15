import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

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
            _buildEditableTextField('First Name', _firstNameController),
            _buildEditableTextField('Last Name', _lastNameController),
            _buildEditableTextField('Gender', _genderController),
            _buildEditableTextField('Role', _roleController),
            _buildEditableTextField('Email', _emailController),
            _buildEditableTextField('Phone Number', _phoneNumberController),
            _buildEditableTextField('Birth Date', _birthDateController),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Aquí guardas los cambios
                _saveChanges();
                Navigator.pop(context); // Regresas a la pantalla anterior
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter $label',
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    // Aquí guardas los cambios realizados en los campos de texto
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String gender = _genderController.text;
    String role = _roleController.text;
    String email = _emailController.text;
    String phoneNumber = _phoneNumberController.text;
    String birthDate = _birthDateController.text;

    // Puedes enviar los nuevos datos a través de un método en el controlador o guardarlos en el almacenamiento local
  }
}