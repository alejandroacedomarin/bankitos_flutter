import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Services/PlaceService.dart';
import 'package:bankitos_flutter/Widgets/PlaceCard.dart';
import 'package:bankitos_flutter/Widgets/UserCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isUsersSelected = true;
  bool _search = true;
  late UserService userService;
  late PlaceService placeService;
  late List<User> listaUsers = [];
  late List<Place> listaPlaces = [];
  late User user = User(
      id: '',
      first_name: '',
      middle_name: '',
      last_name: '',
      gender: '',
      role: '',
      password: '',
      email: '',
      phone_number: '',
      birth_date: '',
      places: [],
      reviews: [],
      conversations: [],
      user_rating: 0,
      photo: '',
      description: '',
      dni: '',
      personality: '',
      address: '',
      housing_offered: [],
      emergency_contact: {});

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userService = UserService();
    placeService = PlaceService();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      listaUsers = await userService.getUsers();
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Error',
        'No se han podido obtener los datos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error al comunicarse con el backend: $error');
    }
  }

  void getUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      user = await userService.getSearchedUser(_searchController.text);
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Error',
        'No se han podido obtener los datos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error al comunicarse con el backend: $error');
    }
  }

  void getPlace() async {
    setState(() {
      isLoading = true;
    });
    try {
      listaPlaces = await placeService.getPlaces(_searchController.text);
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Error',
        'No se han podido obtener los datos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error al comunicarse con el backend: $error');
    }
  }

  void _onSearch() {
    _search = false;
    if (_isUsersSelected) {
      getUser();
    } else {
      getPlace();
    }
  }

  void _selectUsers() {
    setState(() {
      _isUsersSelected = true;
      getData();
    });
  }

  void _selectPlaces() {
    setState(() {
      _isUsersSelected = false;
      getPlace();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _onSearch,
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _selectUsers,
                  child: Column(
                    children: [
                      Text(
                        'Users',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: _isUsersSelected ? Colors.blue : Colors.black,
                        ),
                      ),
                      if (_isUsersSelected)
                        Container(
                          margin: EdgeInsets.only(top: 4.0),
                          height: 2.0,
                          width: 60.0,
                          color: Colors.blue,
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
                          color: !_isUsersSelected ? Colors.blue : Colors.black,
                        ),
                      ),
                      if (!_isUsersSelected)
                        Container(
                          margin: EdgeInsets.only(top: 4.0),
                          height: 2.0,
                          width: 60.0,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _search
                      ? ListView.builder(
                          itemCount: listaUsers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: UserWidget(user: listaUsers[index]),
                            );
                          },
                        )
                      : _isUsersSelected
                          ? ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 1000, // Set max width as needed
                                maxHeight: 200, // Set max height as needed
                              ),
                              child: Card(
                                child: UserWidget(user: user),
                              ),
                            )
                          : ListView.builder(
                              itemCount: listaPlaces.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: PlaceWidget(place: listaPlaces[index]),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
