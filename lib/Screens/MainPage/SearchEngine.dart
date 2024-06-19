import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Models/ReviewModel.dart';
import 'package:bankitos_flutter/Models/UserModel.dart';
import 'package:bankitos_flutter/Screens/Reviews/ReviewDetails.dart';
import 'package:bankitos_flutter/Screens/Reviews/UpdateReview.dart';
import 'package:bankitos_flutter/Services/ReviewService.dart';
import 'package:bankitos_flutter/Screens/Reviews/ReviewDetails.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Services/PlaceService.dart';
import 'package:bankitos_flutter/Widgets/PlaceCard.dart';
import 'package:bankitos_flutter/Widgets/ReviewCard.dart';
import 'package:bankitos_flutter/Widgets/UserCard.dart';
import 'package:bankitos_flutter/Widgets/UserDetails.dart';
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
  late ReviewService reviewService;
  late List<User> listaUsers = [];
  late List<Review> listaReviews = [];
  late List<User> filteredUsers = [];
  late List<Review> filteredReviews = [];
  bool isLoading = true;
  String selectedFilter = 'ID'; // Default filter for users
  List<String> userFilters = ['ID', 'Name'];
  List<String> reviewFilters = ['ID', 'Title', 'Author'];

  @override
  void initState() {
    super.initState();
    userService = UserService();
    reviewService = ReviewService();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      listaUsers = await userService.getUsers();
      listaReviews = await reviewService.getReviews();
      filteredUsers = List.from(listaUsers);
      filteredReviews = List.from(listaReviews);
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

  void filterUser() async {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = listaUsers.where((user) {
        if (selectedFilter == 'ID') {
          return user.id.startsWith(query);
        } else if (selectedFilter == 'Name') {
          return user.first_name.toLowerCase().startsWith(query) ||
              user.middle_name.toLowerCase().startsWith(query) ||
              user.last_name.toLowerCase().startsWith(query);
        }
        return false;
      }).toList();
    });
  }

  void filterReview() async {
    String query = _searchController.text.toLowerCase();
    if (selectedFilter == 'Author' && query.isNotEmpty) {
      // Filtrar usuarios por nombre
      List<User> matchingUsers = listaUsers.where((user) {
        return user.first_name.toLowerCase().startsWith(query) ||
            user.middle_name.toLowerCase().startsWith(query) ||
            user.last_name.toLowerCase().startsWith(query) ||
            user.id.startsWith(query); // Buscar también por ID de usuario
      }).toList();

      // Obtener los IDs de los usuarios coincidentes
      List<String> matchingUserIds =
          matchingUsers.map((user) => user.id).toList();

      // Filtrar reviews por IDs de autores coincidentes
      setState(() {
        filteredReviews = listaReviews.where((review) {
          return matchingUserIds.contains(review.author);
        }).toList();
      });
    } else {
      setState(() {
        filteredReviews = listaReviews.where((review) {
          if (selectedFilter == 'ID') {
            return review.id!.startsWith(query);
          } else if (selectedFilter == 'Title') {
            return review.title.toLowerCase().startsWith(query);
          }
          return false;
        }).toList();
      });
    }
  }

  void _onSearch() {
    _search = false;
    if (_searchController.text.isEmpty) {
      setState(() {
        filteredUsers = List.from(listaUsers);
        filteredReviews = List.from(listaReviews);
      });
    } else {
      if (_isUsersSelected) {
        filterUser();
      } else {
        filterReview();
      }
    }
  }

  void _selectUsers() {
    setState(() {
      _isUsersSelected = true;
      selectedFilter = userFilters[0]; // Reset filter to default for users
      filteredUsers = List.from(listaUsers); // Reset filtered list to full list
    });
  }

  void _selectReviews() {
    setState(() {
      _isUsersSelected = false;
      selectedFilter = reviewFilters[0]; // Reset filter to default for reviews
      filteredReviews =
          List.from(listaReviews); // Reset filtered list to full list
    });
  }

  Widget _buildReviewCard(Review review) {
    return GestureDetector(
      onTap: () {
        Get.to(ReviewDetailsPage(review));
      },
      child: Card(
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
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return GestureDetector(
      onTap: () {
        Get.to(() => UserDetails(user));
      },
      child: Card(
        color: Colors.orange[100], // Fondo de color naranja suave
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              user.photo.isNotEmpty
                  ? Image.network(
                      user.photo,
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
                      '${user.first_name} ${user.middle_name} ${user.last_name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      user.description,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            DropdownButton<String>(
              value: selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue!;
                });
              },
              items: (_isUsersSelected ? userFilters : reviewFilters)
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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
                  onTap: _selectReviews,
                  child: Column(
                    children: [
                      Text(
                        'Reviews',
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
                  : _isUsersSelected
                      ? ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildUserCard(filteredUsers[index]);
                          },
                        )
                      : ListView.builder(
                          itemCount: filteredReviews.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildReviewCard(filteredReviews[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
