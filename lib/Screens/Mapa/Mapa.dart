import 'dart:typed_data';

import 'package:bankitos_flutter/Models/PlaceModel.dart';
import 'package:bankitos_flutter/Screens/Places/PlaceDetails.dart';
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
  String getUserId() {
    final box = GetStorage();
    return box.read('id') ?? '';
  }
void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    String? imageUrl = await cloudinaryService.uploadImage(img);
    if (imageUrl != null) {
      setState(() {
        photoUrlController = imageUrl as TextEditingController;
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
                        controller: addressController,
                        decoration: InputDecoration(labelText: 'Address'),
                      ),
                      Text('Tap on the map to select the location'),
                      SizedBox(height: 16),
                      // Map widget to select coordinates
                      Container(
                        height: 300, // Adjust height as needed
                        child: GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            // Initialize map controller
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
                              ? Set<Marker>.of([
                                  Marker(
                                    markerId: MarkerId('new_place'),
                                    position: _newPlacePosition!,
                                    infoWindow: InfoWindow(
                                      title: 'New Place',
                                    ),
                                  ),
                                ])
                              : Set<Marker>(),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
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
                                  'coordinates': [double.tryParse(latitudeController.text) ?? 0, double.tryParse(longitudeController.text) ?? 0],
                               },
                              photo: photoUrlController.text,
                              isBankito: _selectedPlace?.isBankito ?? false,
                              isPublic: _selectedPlace?.isPublic ?? false,
                              isCovered: _selectedPlace?.isCovered ?? false,
                              schedule: {
                                  'monday': '9:00 AM - 5:00 PM',
                                  'tuesday': '9:00 AM - 5:00 PM',
                                   'wednesday': '9:00 AM - 5:00 PM',
                                      'thursday': '9:00 AM - 5:00 PM',
                                     'friday': '9:00 AM - 5:00 PM',
                                   'saturday': 'Closed',
                                     'sunday': 'Closed',
                               },
                              address: addressController.text,
                              placeDeactivated: false,
                              creationDate: DateTime.now(),
                              modifiedDate: DateTime.now(),
                            );
                            createPost(newPlace);
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
 void createPost(Place place) {
    print(place.title);
    print(place.coords['latitude']);
    print(place.coords['longitude']);


    

    if ( place.title == null||
         place.content== null ||
         place.coords== null ||
         place.address== null) {
      Get.snackbar(
        'Error',
        'Campos vacios',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      
      placeService.createPlace(place).then((statusCode) {
        print('Place creado exitosamente');
        Get.snackbar(
          '¡Place Creado!',
          'Place creado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
        Navigator.of(context).pop();
        _loadMarkers();
      }).catchError((error) {
        Get.snackbar(
          'Error',
          'Ha ocurrido un error',
          snackPosition: SnackPosition.BOTTOM,
        );
        print('Error al enviar place al backend: $error');
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
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _filteredPlaces.length,
                      itemBuilder: (context, index) {
                        Place place = _filteredPlaces[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => PlaceDetailsPage(place));
                          },
                          child: Card(
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
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    ),
  );
}
}