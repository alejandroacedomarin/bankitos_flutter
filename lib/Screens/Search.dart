import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isUsersSelected = true;

  void _onSearch() {
    String query = _searchController.text;
    if (_isUsersSelected) {
      // Search for users
      print("Searching for users: $query");
    } else {
      // Search for places
      print("Searching for places: $query");
    }
  }

  void _selectUsers() {
    setState(() {
      _isUsersSelected = true;
    });
  }

  void _selectPlaces() {
    setState(() {
      _isUsersSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
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
            // Additional content can be added here based on search results
          ],
        ),
      ),
    );
  }
}