import 'dart:typed_data';
import 'package:bankitos_flutter/Screens/MainPage/LogIn.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/utils/pickImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bankitos_flutter/Services/cloudinary_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late UserService userService;
  final box = GetStorage();
  final CloudinaryService cloudinaryService = CloudinaryService();

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
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _verifyPasswordController;
  final TextEditingController _deleteProfileController = TextEditingController();

  bool _isEditingPassword = false;

  @override
  void initState() {
    super.initState();
    userService = UserService();

    // Initialize controllers with current user values
    _firstNameController = TextEditingController(text: widget.user.first_name);
    _middleNameController = TextEditingController(text: widget.user.middle_name);
    _lastNameController = TextEditingController(text: widget.user.last_name);
    _genderController = TextEditingController(text: widget.user.gender);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneNumberController = TextEditingController(text: widget.user.phone_number);
    _birthDateController = TextEditingController(text: widget.user.birth_date);
    _passwordController = TextEditingController();
    _photoController = TextEditingController(text: widget.user.photo);
    _descriptionController = TextEditingController(text: widget.user.description);
    _dniController = TextEditingController(text: widget.user.dni);
    _personalityController = TextEditingController(text: widget.user.personality);
    _addressController = TextEditingController(text: widget.user.address);
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _verifyPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers when done
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
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _verifyPasswordController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    String? imageUrl = await cloudinaryService.uploadImage(img);
    if (imageUrl != null) {
      setState(() {
        _photoController.text = imageUrl;
      });
    } else {
      Get.snackbar(
        'Error',
        'Failed to upload image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          backgroundColor: Colors.orange,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: _photoController.text.isEmpty
                            ? AssetImage('assets/userdefec.png') as ImageProvider<Object>?
                            : NetworkImage(_photoController.text),
                      ),
                      Positioned(
                        child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(Icons.add_a_photo_outlined),
                        ),
                        bottom: -10,
                        left: 65,
                      )
                    ],
                  ),
                  _buildEditableTextField('First Name', _firstNameController),
                  _buildEditableTextField('Middle Name', _middleNameController),
                  _buildEditableTextField('Last Name', _lastNameController),
                  buildEditableSelectionField('Gender', _genderController),
                  
                  _buildEditableTextField('Birth Date', _birthDateController),
                  _buildPasswordField('Password', _passwordController),
                  _buildEditableTextField('Address', _addressController),
                  _buildEditableTextField('Personality', _personalityController),
                  _buildEditableTextField('Description', _descriptionController),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Save'),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: _showDeleteProfileDialog,
                    child: Text(
                      'Delete Profile',
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildEditableTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 10), // Spacing between text and TextField
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

  Widget buildEditableSelectionField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 10), // Spacing between text and ScrollView
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildOption('Male', controller, () => setState(() {})),
                  _buildOption('Female', controller, () => setState(() {})),
                  _buildOption('Other', controller, () => setState(() {})),
                ],
              ),
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
          updateState(); // Update widget state
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : null,
          borderRadius: BorderRadius.circular(20),
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

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEditingPassword = !_isEditingPassword;
                  });
                },
              ),
            ],
          ),
          if (_isEditingPassword)
            Column(
              children: [
                _buildPasswordTextField('Password', _passwordController),
                _buildPasswordTextField('New Password', _newPasswordController),
                _buildPasswordTextField('Verify Password', _verifyPasswordController),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                  ),
                  child: Text('Change Password'),
                ),
              ],
            )
          else
            TextField(
              controller: controller,
              obscureText: true,
              readOnly: true,
              decoration: InputDecoration(
                hintText: '********',
              ),
            ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildPasswordTextField(String label, TextEditingController controller) {
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
          SizedBox(width: 10), // Spacing between text and TextField
          Expanded(
            flex: 3,
            child: TextField(
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter $label',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('To delete this profile, please enter:'),
              Text('Delete profile: ${widget.user.email}', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _deleteProfileController,
                decoration: InputDecoration(
                  labelText: 'Delete profile: ${widget.user.email}',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_deleteProfileController.text == 'Delete profile: ${widget.user.email}') {
                  deleteUser();
                }
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteUser() async {
    try {
      String message = await userService.deleteUser();
      Get.snackbar(
        'Message',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
      box.erase();
      Get.offAll(() => LoginScreen());
    } catch (error) {
      Get.snackbar(
        'Error',
        'Please try again',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _saveChanges() async {
    User updatedUser = User(
      id: widget.user.id,
      first_name: _firstNameController.text,
      middle_name: _middleNameController.text,
      last_name: _lastNameController.text,
      gender: _genderController.text,
      role: widget.user.role,
      email: _emailController.text,
      phone_number: _phoneNumberController.text,
      birth_date: _birthDateController.text,
      password: _passwordController.text,
      places: widget.user.places,
      reviews: widget.user.reviews,
      conversations: widget.user.conversations,
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

    try {
      await userService.putUser(updatedUser).then((value) => {Navigator.pop(context)});
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text == _verifyPasswordController.text) {
      try {
        await userService.changePass(_passwordController.text, _verifyPasswordController.text);
        Get.snackbar(
          'Success',
          'Password changed successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        Navigator.pop(context);
      } catch (error) {
        Get.snackbar(
          'Error',
          error.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
