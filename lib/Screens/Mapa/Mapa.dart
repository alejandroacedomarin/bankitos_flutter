import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  @override
  _GoogleMapsScreenState createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(41.2756, 1.9869);
  final UserService authService = UserService();
  Set<Marker> _markers = {};
  List<Place> _places = [];
  List<Place> _filteredPlaces = [];
  bool _loading = true;
  Place? _selectedPlace;
  LatLng? _newPlacePosition;
  TextEditingController _searchController = TextEditingController();
  bool _addingNewPlace = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    List<Place> markerData = await authService.getMarcadores();

    setState(() {
      _places = markerData;
      _filteredPlaces = _places;
      _updateMarkers();
      _loading = false;
    });
  }

  void _updateMarkers() {
    setState(() {
      _markers = _filteredPlaces.map((data) {
        double latitude = data.coords['latitude'];
        double longitude = data.coords['longitude'];
        LatLng position = LatLng(latitude, longitude);
        return Marker(
          markerId: MarkerId(data.id.toString()),
          position: position,
          infoWindow: InfoWindow(title: data.title),
          onTap: () {
            setState(() {
              _selectedPlace = data;
            });
            _showPlaceDetails();
          },
        );
      }).toSet();
    });
  }

  void _showPlaceDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return _selectedPlace != null
                ? SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_selectedPlace!.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text("ID: ${_selectedPlace!.id}"),
                          Text("Content: ${_selectedPlace!.content}"),
                          Text("Author ID: ${_selectedPlace!.authorId}"),
                          Text("Rating: ${_selectedPlace!.rating}"),
                          Text("Latitude: ${_selectedPlace!.coords['latitude']}"),
                          Text("Longitude: ${_selectedPlace!.coords['longitude']}"),
                          Text("Photo: ${_selectedPlace!.photo}"),
                          Text("Is Bankito: ${_selectedPlace!.isBankito}"),
                          Text("Is Public: ${_selectedPlace!.isPublic}"),
                          Text("Is Covered: ${_selectedPlace!.isCovered}"),
                          Text("Schedule: ${_selectedPlace!.schedule}"),
                          Text("Address: ${_selectedPlace!.address}"),
                          Text("Place Deactivated: ${_selectedPlace!.placeDeactivated}"),
                          Text("Creation Date: ${_selectedPlace!.creationDate}"),
                          Text("Modified Date: ${_selectedPlace!.modifiedDate}"),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container();
          },
        );
      },
    );
  }

  void _addNewPlace() {
    setState(() {
      _addingNewPlace = true;
      _newPlacePosition = null;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Add New Place', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(labelText: 'Title'),
                          onChanged: (value) {
                            setModalState(() {
                              _selectedPlace?.title = value;
                            });
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Content'),
                          onChanged: (value) {
                            setModalState(() {
                              _selectedPlace?.content = value;
                            });
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Author ID'),
                          onChanged: (value) {
                            setModalState(() {
                              _selectedPlace?.authorId = value;
                            });
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Rating'),
                          onChanged: (value) {
                            setModalState(() {
                              _selectedPlace?.rating = double.tryParse(value) ?? 0;
                            });
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Photo URL'),
                          onChanged: (value) {
                            setModalState(() {
                              _selectedPlace?.photo = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text('Is Bankito'),
                          value: _selectedPlace?.isBankito ?? false,
                          onChanged: (value) {
                            setModalState(() {
                              _selectedPlace?.isBankito = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text('Is Public'),
                          value: _selectedPlace?.isPublic ?? false,
                          onChanged: (value) {
                            setModalState(() {
                              _selectedPlace?.isPublic = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text('Is Covered'),
                          value: _selectedPlace?.isCovered ?? false,
                          onChanged: (value) {
                            setModalState(() {
                              _selectedPlace?.isCovered = value;
                            });
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Address'),
                          onChanged: (value) {
                            setModalState(() {
                              _selectedPlace?.address = value;
                            });
                          },
                        ),
                        Text('Tap on the map to select the location'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_newPlacePosition != null) {
                              Place newPlace = Place(
                                id: '',
                                title: _selectedPlace?.title ?? '',
                                content: _selectedPlace?.content ?? '',
                                authorId: _selectedPlace?.authorId ?? '',
                                rating: _selectedPlace?.rating ?? 0,
                                coords: {
                                   'latitude': _newPlacePosition!.latitude,
                                   'longitude': _newPlacePosition!.longitude,
                                   },
                                photo: _selectedPlace?.photo ?? '',
                                isBankito: _selectedPlace?.isBankito ?? false,
                                isPublic: _selectedPlace?.isPublic ?? false,
                                isCovered: _selectedPlace?.isCovered ?? false,
                                schedule: {},
                                address: _selectedPlace?.address ?? '',
                                placeDeactivated: false,
                                creationDate: DateTime.now(),
                                modifiedDate: DateTime.now(),
                              );
                              Navigator.of(context).pop();
                              _loadMarkers();
                            }
                          },
                          child: Text('Save Place'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _filterPlaces(String query) {
    setState(() {
      _filteredPlaces = _places.where((place) => place.title.toLowerCase().contains(query.toLowerCase())).toList();
      _updateMarkers();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterPlaces(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 18.0, 
            ),
            markers: _markers,
            onTap: (LatLng position) {
              if (_addingNewPlace) {
                setState(() {
                  _newPlacePosition = position;
                  _markers.add(Marker(
                    markerId: MarkerId('new_place'),
                    position: position,
                    infoWindow: InfoWindow(title: 'New Place'),
                  ));
                  _addingNewPlace = false;
                });
              }
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _addNewPlace,
              child: Icon(Icons.add),
              backgroundColor: Colors.orange,
            ),
          ),
          if (_searchController.text.isNotEmpty)
            Positioned(
              bottom: 80,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                child: Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = _filteredPlaces[index];
                      return ListTile(
                        title: Text(place.title),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newLatLng(
                              LatLng(place.coords['latitude'], place.coords['longitude']))
                          );
                          setState(() {
                            _selectedPlace = place;
                          });
                          _showPlaceDetails();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
