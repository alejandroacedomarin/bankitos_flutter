
import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Widgets/ReviewWidgets/ReviewButton.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Screens/EditProfile.dart';

late UserService userService;

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? user; // Cambiar a nullable
  List<Review>? reviews;
  List<Place>? places;
  bool _isInformationSelected = true;
  bool _isPlacesSelected = false;
  bool _isReviewsSelected = false;

  @override
  void initState() {
    super.initState();
    userService = UserService();
    getData();
    getReviewsUser();
  }

  void getData() async {
    print('getUser');
    try {
      User fetchedUser = await userService.getUser();
      setState(() {
        user = fetchedUser;
      });
      print(user!.id);
    } catch (error) {
      Get.snackbar(
        'Error',
        'No se han podido obtener los datos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error al comunicarse con el backend: $error');
    }
  }
  void getReviewsUser() async {
    print('getReviewsUser');
    try {
      List<Review> fetchedUser = await userService.getReviewsByUser();
      print(fetchedUser);
      setState(() {
        reviews = fetchedUser;
      });
      print(user!.id);
    } catch (error) {
      Get.snackbar(
        'Error',
        'No se han podido obtener los datos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error al comunicarse con el backend: $error');
    }
  }
  void getPlacesData() async {
    print('getUser');
    try {
      User fetchedUser = await userService.getUser();
      setState(() {
        user = fetchedUser;
      });
      print(user!.id);
    } catch (error) {
      Get.snackbar(
        'Error',
        'No se han podido obtener los datos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error al comunicarse con el backend: $error');
    }
  }

  void _selectInformation() {
    setState(() {
      _isInformationSelected = true;
      _isPlacesSelected = false;
      _isReviewsSelected = false;
    });
  }

  void _selectPlaces() {
    setState(() {
      _isInformationSelected = false;
      _isPlacesSelected = true;
      _isReviewsSelected = false;
    });
  }

  void _selectReviews() {
    setState(() {
      _isInformationSelected = false;
      _isPlacesSelected = false;
      _isReviewsSelected = true;
    });
  }

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
        child: user == null
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  // Sección de información del perfil
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        child: _buildStarRating(user!.user_rating),
                      ),
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: user!.photo.isEmpty
                            ? AssetImage('assets/userdefec.png') as ImageProvider<Object>?
                            : NetworkImage(user!.photo), // URL de la foto si está disponible
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '${user!.first_name} ${user!.last_name}',
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  // Opciones de navegación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: _selectInformation,
                        child: Column(
                          children: [
                            Text(
                              'Information',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: _isInformationSelected ? Colors.orange : Colors.black,
                              ),
                            ),
                            if (_isInformationSelected)
                              Container(
                                margin: EdgeInsets.only(top: 4.0),
                                height: 2.0,
                                width: 60.0,
                                color: Colors.orange,
                              ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _selectPlaces,
                        child: Column(
                          children: [
                            Text(
                              'Places',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: _isPlacesSelected ? Colors.orange : Colors.black,
                              ),
                            ),
                            if (_isPlacesSelected)
                              Container(
                                margin: EdgeInsets.only(top: 4.0),
                                height: 2.0,
                                width: 60.0,
                                color: Colors.orange,
                              ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _selectReviews,
                        child: Column(
                          children: [
                            Text(
                              'Reviews',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: _isReviewsSelected ? Colors.orange : Colors.black,
                              ),
                            ),
                            if (_isReviewsSelected)
                              Container(
                                margin: EdgeInsets.only(top: 4.0),
                                height: 2.0,
                                width: 60.0,
                                color: Colors.orange,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Divider(), // Línea separadora
                  SizedBox(height: 20.0),
                  // Contenido basado en la selección
                  if (_isInformationSelected) _buildInformation(),
                  if (_isPlacesSelected) _buildPlaces(),
                  if (_isReviewsSelected) _buildReviews(),
                ],
              ),
      ),
    );
  }

  Widget _buildInformation() {
    return Column(
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
        _buildProfileInformation('First Name', user!.first_name),
        _buildProfileInformation('Middle Name', user!.middle_name),
        _buildProfileInformation('Last Name', user!.last_name),
        SizedBox(height: 20.0),
        Divider(), // Línea separadora
        SizedBox(height: 20.0),
        Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.0),
        _buildPersonalInformation('Gender', user!.gender),
        _buildPersonalInformation('Role', user!.role),
        _buildPersonalInformation('Email', user!.email),
        _buildPersonalInformation('Phone Number', user!.phone_number),
        _buildPersonalInformation('Birth Date', user!.birth_date),
        _buildPasswordField('Password', user!.password),
      ],
    );
  }

  Widget _buildPlaces() {
    return Column(
      children: [
        // Aquí puedes agregar el contenido relacionado con 'Places'
        Text('Places Content'),
      ],
    );
  }

  Widget _buildReviews() {
   
        // Aquí puedes agregar el contenido relacionado con 'Reviews'
          
                return ListView.builder(
                  itemCount: reviews!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: PostReviewWidget(review: reviews![index]),
                    );
                  },
                );
              
    
  }

  Widget _buildProfileInformation(String label, String value) {
    if (value.isEmpty) {
      return SizedBox.shrink();
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildPersonalInformation(String label, String value) {
    if (value.isEmpty) {
      return SizedBox.shrink();
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    print(rating);
    int fullStars = rating.floor();
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow));
    }
    double fraction = rating - fullStars;
    if (fraction > 0) {
      stars.add(Icon(Icons.star_half, color: Colors.yellow));
    }
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
        SizedBox(width: 10.0),
        Expanded(
          child: Text(
            '${'*' * value.length}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Courier'),
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}