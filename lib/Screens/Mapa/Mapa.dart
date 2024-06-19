import 'dart:typed_data';

import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Screens/Places/PlaceDetails.dart';
import 'package:bankitos_flutter/Services/SocketService.dart';
import 'package:bankitos_flutter/Services/UserService.dart';
import 'package:bankitos_flutter/Services/PlaceService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bankitos_flutter/utils/pickImage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bankitos_flutter/Services/cloudinary_service.dart';



class GoogleMapsScreen extends StatefulWidget {
  @override
  _GoogleMapsScreenState createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  late GoogleMapController mapController;
  final SocketService socketService = Get.put(SocketService());
  final CloudinaryService cloudinaryService = CloudinaryService();
  final LatLng _center = const LatLng(41.2756, 1.9869);
  final UserService authService = UserService();
  final PlaceService placeService = PlaceService();
  Set<Marker> _markers = {};
  List<Place> _places = [];
  List<Place> _filteredPlaces = [];
  bool _loading = true;
  Place? _selectedPlace;
  LatLng? _newPlacePosition;
  TextEditingController _searchController = TextEditingController();
  bool _addingNewPlace = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController photoUrlController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  final SocketService _socketService = Get.find();
  bool isBankito = false;
  bool isPublic = false;
  bool isCovered = false;

void initState(){
   super.initState();
    _loadMarkers();

  
    
    
}

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _loadMarkers();
    _socketService.setNewPlaceCallback(_handleNewPlace);
    
  }

  void _handleNewPlace(dynamic newPlace) {
    print("se tira");
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

  String getUserId() {
    final box = GetStorage();
    return box.read('id') ?? '';
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    String? imageUrl = await cloudinaryService.uploadImage(img);
    if (imageUrl != null) {
      setState(() {
        photoUrlController.text = imageUrl;
      });
    } else {
      Get.snackbar(
        'Error',
        'Failed to upload image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _updateMarkers() {
    setState(() {
      _markers = _filteredPlaces.map((data) {
        double latitude = data.coords['coordinates'][1]; 
        double longitude = data.coords['coordinates'][0]; 
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
                        Center(
                          child: Text(
                            _selectedPlace!.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: _selectedPlace!.photo.isEmpty
                                ? AssetImage('assets/userdefec.png') as ImageProvider<Object>?
                                : NetworkImage(_selectedPlace!.photo),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (i) {
                              return Icon(
                                i < _selectedPlace!.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(PlaceDetailsPage(_selectedPlace!));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white, 
                              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              'Ir al Place',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                       Stack(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: photoUrlController.text.isEmpty
                            ? AssetImage('assets/userdefec.png') as ImageProvider<Object>?
                            : NetworkImage(photoUrlController.text),
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
                        SizedBox(height: 8),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(labelText: 'Title'),
                        ),
                        TextField(
                          controller: contentController,
                          decoration: InputDecoration(labelText: 'Content'),
                        ),
                        TextField(
                          controller: ratingController,
                          decoration: InputDecoration(labelText: 'Rating'),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                        TextField(
                          controller: photoUrlController,
                          decoration: InputDecoration(labelText: 'Photo URL'),
                        ),
                        SwitchListTile(
                          title: Text('Is Bankito'),
                          value: isBankito,
                          onChanged: (value) {
                            setModalState(() {
                              isBankito = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text('Is Public'),
                          value: isPublic,
                          onChanged: (value) {
                            setModalState(() {
                              isPublic = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text('Is Covered'),
                          value: isCovered,
                          onChanged: (value) {
                            setModalState(() {
                              isCovered = value;
                            });
                          },
                        ),
                        
                        Text('Tap on the map to select the location'),
                        SizedBox(height: 16),
                        Container(
                          height: 300, 
                          child: GoogleMap(
                            onMapCreated: (GoogleMapController controller) {
                              
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(41.2756, 1.9869), // Initial position
                              zoom: 18.0,
                            ),
                            onTap: (LatLng position) {
                              setModalState(() {
                                _newPlacePosition = position;
                                latitudeController.text = position.latitude.toString();
                                longitudeController.text = position.longitude.toString();
                                
                              });
                            },
                            markers: _newPlacePosition != null
                                ? {
                                    Marker(
                                      markerId: MarkerId('new_place'),
                                      position: _newPlacePosition!,
                                      infoWindow: InfoWindow(title: 'New Place'),
                                    ),
                                  }
                                : {},
                          ),
                        ),
                        TextField(
                          controller: latitudeController,
                          decoration: InputDecoration(labelText: 'Latitude'),
                          readOnly: true,
                        ),
                        TextField(
                          controller: longitudeController,
                          decoration: InputDecoration(labelText: 'Longitude'),
                          readOnly: true,
                        ),
                        SizedBox(height: 16),
                        Center(
  child: ElevatedButton(
    onPressed: () async {
      if (_newPlacePosition != null) {
        Place newPlace = Place(
          id: '',
          title: titleController.text,
          content: contentController.text,
          authorId: getUserId(),
          rating: double.tryParse(ratingController.text) ?? 0,
          coords: {
            'type': 'Point',
            'coordinates': [
              double.tryParse(longitudeController.text) ?? 0,
              double.tryParse(latitudeController.text) ?? 0
            ],
          },
          photo: photoUrlController.text,
          isBankito: isBankito,
          isPublic: isPublic,
          isCovered: isCovered,
          schedule: {
            'monday': '9:00 AM - 5:00 PM',
            'tuesday': '9:00 AM - 5:00 PM',
            'wednesday': '9:00 AM - 5:00 PM',
            'thursday': '9:00 AM - 5:00 PM',
            'friday': '9:00 AM - 5:00 PM',
            'saturday': 'Closed',
            'sunday': 'Closed',
          },
          address: "Not provided",
          placeDeactivated: false,
          creationDate: DateTime.now(),
          modifiedDate: DateTime.now(),
        );
        createPost(newPlace);
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white, 
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    child: Text('Save Place'),
  ),
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

  void createPost(Place place) {
    if (place.title.isEmpty || place.content.isEmpty || place.coords.isEmpty|| place.rating == 0) {
      Get.snackbar(
        'Error',
        'Campos vacios',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      placeService.createPlace(place).then((statusCode) {
        Get.snackbar(
          '¡Place Creado!',
          'Place creado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
        _newPlacePosition = null;
        latitudeController.text = '';
        longitudeController.text = '';
        photoUrlController.text ='';
        ratingController.text ='';
        contentController.text ='';
        titleController.text ='';
        
        Navigator.of(context).pop();
        _loadMarkers();
      }).catchError((error) {
        Get.snackbar(
          'Error',
          'Ha ocurrido un error',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    }
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
                  onChanged: (text) {
                    setState(() {
                      _filteredPlaces = _places.where((place) {
                        return place.title.toLowerCase().contains(text.toLowerCase()) ||
                               place.content.toLowerCase().contains(text.toLowerCase());
                      }).toList();
                      _updateMarkers();
                    });
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              onPressed: _addNewPlace,
              child: Icon(Icons.add),
              backgroundColor: Colors.orange,
            ),
          ),
          if (_searchController.text.isNotEmpty)
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredPlaces.length,
                  itemBuilder: (context, index) {
                    Place place = _filteredPlaces[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPlace = place;
                          _searchController.clear();
                          _filteredPlaces = _places;
                          _updateMarkers();
                        });
                        _showPlaceDetails();
                      },
                      child: Card(
                color: Colors.orange[100], 
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
              ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}