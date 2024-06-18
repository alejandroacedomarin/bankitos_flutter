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
  bool _loading = true;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
  List<Place> markerData = await authService.getMarcadores();
  
  setState(() {
    _markers = markerData.map((data) {
      // Extract latitude and longitude from coords
      double latitude = data.coords['coordinates'][1];
      double longitude = data.coords['coordinates'][0];
      
      LatLng position = LatLng(latitude, longitude);
      
      return Marker(
        markerId: MarkerId(data.id.toString()),
        position: position,
        infoWindow: InfoWindow(title: data.title),
        onTap: () {
          _onMarkerTapped(data);
        },
      );
    }).toSet();
    _loading = false;
  });
}

  void _onMarkerTapped(Place place) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(place.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID: ${place.id}"),
                Text("Content: ${place.content}"),
                Text("Author ID: ${place.authorId}"),
                Text("Address: ${place.address}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        backgroundColor: Colors.orange,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 18.0, 
        ),
        markers: _markers,
      ),
    );
  }
}