import 'dart:io';

import 'package:bankitos_flutter/Screens/MainPage/LogIn.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Services/ReviewService.dart';
import 'package:bankitos_flutter/Widgets/Button.dart';
import 'package:bankitos_flutter/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:bankitos_flutter/Screens/Users/UpdateUser.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bankitos_flutter/Screens/MainPage/LogIn.dart';
import 'package:restart_app/restart_app.dart';
import 'package:bankitos_flutter/Models/PlaceModel.dart';


class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> with SingleTickerProviderStateMixin {
  final UserDetailsController controller = Get.put(UserDetailsController());
  late UserService userService;
  late ReviewService reviewService;
  late User user;
  bool _isLoading = true;
  List<Place> _places = [];
  List<Review> _reviews = [];
  bool _isLoadingPlaces = true;
  bool _isLoadingReviews = true;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    userService = UserService();
    reviewService = ReviewService();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    getData();
  }

  void _handleTabSelection() {
    if (_tabController.index == 0 && _isLoadingPlaces) {
      _loadPlaces();
    } else if (_tabController.index == 1 && _isLoadingReviews) {
      _loadReviews();
    }
  }

  void getData() async {
    print('getUser');
    try {
      User fetchedUser = await userService.getUser();
      setState(() {
        user = fetchedUser;
        _isLoading = false;
      });
      print(user.id);
    } catch (error) {
      Get.snackbar(
        'Error',
        'No se han podido obtener los datos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error al comunicarse con el backend: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPlaces() async {
    try {
      List<Place> places = await userService.getPlaces();
      setState(() {
        _places = places;
        _isLoadingPlaces = false;
      });
    } catch (error) {
      Get.snackbar(
        'Error',
        'No se han podido obtener los lugares.',
        snackPosition: SnackPosition.BOTTOM,
      );
      setState(() {
        _isLoadingPlaces = false;
      });
    }
  }

  Future<void> _loadReviews() async {
    try {
      List<Review> reviews = await reviewService.getReviewsByAuthor();
      setState(() {
        _reviews = reviews;
        _isLoadingReviews = false;
      });
    } catch (error) {
      Get.snackbar(
        'Error',
        'No se han podido obtener los reviews.',
        snackPosition: SnackPosition.BOTTOM,
      );
      setState(() {
        _isLoadingReviews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.orange,
        actions: [
          if (!_isLoading)
          /* SignInButton(
          onPressed: () => controller.logOut(),
          text: 'Log Out',
        ), */
        IconButton(
              icon: Icon(Icons.login_outlined),
              onPressed: () {
                // Abrir pantalla de edición
                controller.logOut();
            
              },
            ),
          
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)))
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: user.photo.isEmpty
                        ? AssetImage('assets/userdefec.png') as ImageProvider<Object>?
                        : NetworkImage(user.photo),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '${user.first_name} ${user.last_name}',
                    style: const TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10.0),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.orange,
                    overlayColor: MaterialStateProperty.all(Colors.orange),
                    dividerColor: Colors.orange,
                    labelColor: Colors.orange,
                    tabs: [
                      Tab(text: 'Places'),
                      Tab(text: 'Reviews'),
                      Tab(text: 'My Info'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPlacesTab(),
                        _buildReviewsTab(),
                        _buildPersonalInfo(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPlacesTab() {
    return _isLoadingPlaces
        ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)))
        : ListView.builder(
            itemCount: _places.length,
            itemBuilder: (context, index) {
              Place place = _places[index];
              return Card(
                color: Colors.orange[100], // Fondo de color naranja suave
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      place.photo.isNotEmpty
                          ? Image.network(
                              place.photo,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/userdefec.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              place.content,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < place.rating ? Icons.star : Icons.star_border,
                                  color: Colors.yellow,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildReviewsTab() {
    return _isLoadingReviews
        ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)))
        : ListView.builder(
            itemCount: _reviews.length,
            itemBuilder: (context, index) {
              Review review = _reviews[index];
              return Card(
                color: Colors.orange[100], // Fondo de color naranja suave
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        review.content,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < review.stars ? Icons.star : Icons.star_border,
                            color: Colors.yellow,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildPersonalInfo() {
    return ListView(
      children: [
        
        const SizedBox(height: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            _buildProfileInformation('First Name', user.first_name),
            _buildProfileInformation('Middle Name', user.middle_name),
            _buildProfileInformation('Last Name', user.last_name),
          ],
        ),
        SizedBox(height: 20.0),
        Divider(color: Colors.orange,),
        SizedBox(height: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            _buildPersonalInformation('Gender', user.gender),
            _buildPersonalInformation('Role', user.role),
            _buildPersonalInformation('Email', user.email),
            _buildPersonalInformation('Phone Number', user.phone_number),
            _buildPersonalInformation('Birth Date', user.birth_date),
            
          ],
        ),
        SizedBox(height: 20.0),
        const Divider(color: Colors.orange,),
      ],
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
}

  class UserDetailsController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.disconnect();
      print('Google Sign Out exitoso');
    } catch (error) {
      print('Error al cerrar sesión en Google: $error');
    }
  } 

  void logOut() async {
    await _handleSignOut();
   
    Restart.restartApp();    
  }
}

