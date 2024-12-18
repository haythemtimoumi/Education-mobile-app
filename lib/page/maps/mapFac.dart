import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  LocationData? currentLocation;
  List<LatLng> routePoints = []; // To store points of the route polyline
  List<Marker> markers = [];
  String? _selectedBlock; // Variable to store the selected block
  final List<String> _blocks = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'];

  final String orsApiKey = '5b3ce3597851110001cf6248d5d41812b67e49cbb41ad784dc0f652e';
  final String proxyUrl = 'https://cors-anywhere.herokuapp.com/';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    var location = Location();

    try {
      var userLocation = await location.getLocation();
      if (mounted) {
        setState(() {
          currentLocation = userLocation;
          _addMarker(LatLng(userLocation.latitude!, userLocation.longitude!), Icons.my_location, Colors.blue);
        });
      }
    } on Exception {
      currentLocation = null;
    }

    location.onLocationChanged.listen((LocationData newLocation) {
      if (mounted) {
        setState(() {
          currentLocation = newLocation;
        });
      }
    });
  }

  Future<void> _getRoute(LatLng destination) async {
    if (currentLocation == null) return;

    final start = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    final url = 'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$orsApiKey&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> coords = data['features'][0]['geometry']['coordinates'];

        if (mounted) {
          setState(() {
            routePoints = coords.map((coord) => LatLng(coord[1], coord[0])).toList(); // Convert coordinates to LatLng
          });
        }
      } else {
        // Handle 403 error silently, or log for debugging
        print('Failed to fetch route: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors silently, or log for debugging
      print('Request failed with error: $error');
    }
  }

  void _addMarker(LatLng point, IconData icon, Color color) {
    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: point,
        child: Icon(icon, color: color, size: 40.0),
      ),
    );
  }

  void _clearMarkersAndRoute() {
    setState(() {
      markers.clear();
      routePoints.clear();
    });
  }

  void _handleBlockSelection() {
    LatLng? blockLocation;

    switch (_selectedBlock) {
      case 'A':
        blockLocation = LatLng(36.8000, 10.1850);
        break;
      case 'B':
        blockLocation = LatLng(36.8010, 10.1860);
        break;
      case 'C':
        blockLocation = LatLng(36.8020, 10.1870);
        break;
      case 'D':
        blockLocation = LatLng(36.8030, 10.1880);
        break;
      case 'E':
        blockLocation = LatLng(36.8040, 10.1890);
        break;
      case 'F':
        blockLocation = LatLng(36.8050, 10.1900);
        break;
      case 'G':
        blockLocation = LatLng(36.8060, 10.1910);
        break;
      case 'H':
        blockLocation = LatLng(36.8070, 10.1920);
        break;
      case 'I':
        blockLocation = LatLng(36.8080, 10.1930);
        break;
      case 'J':
        blockLocation = LatLng(36.8090, 10.1940);
        break;
      case 'K':
        blockLocation = LatLng(36.8100, 10.1950);
        break;
      default:
        blockLocation = null;
    }

    if (blockLocation != null) {
      _clearMarkersAndRoute();
      _addMarker(blockLocation, Icons.location_on, Colors.red);
      _getRoute(blockLocation);
    }
  }

  void _handleMapTap(LatLng point) {
    _clearMarkersAndRoute();
    _addMarker(point, Icons.location_on, Colors.red);
    _getRoute(point);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentLocation != null
                  ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
                  : LatLng(0, 0),
              initialZoom: 15.0,
              onTap: (tapPosition, point) => _handleMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'], // Use standard OSM subdomains
              ),
              MarkerLayer(
                markers: markers,
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
          // Back button using an image icon
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/back.png', // Make sure to add this icon to your assets
                  width: 24,
                  height: 24,
                  color: Colors.red.shade700,
                ),
              ),
            ),
          ),
          // Block selector at the bottom of the screen
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Location',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    children: [
                      Text(
                        'Select Block:',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.red.shade700,
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _selectedBlock,
                          hint: Text('Choose a Block'),
                          items: _blocks.map((String block) {
                            return DropdownMenuItem<String>(
                              value: block,
                              child: Text(
                                block,
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedBlock = newValue;
                              _handleBlockSelection();
                            });
                          },
                          isExpanded: true,
                          underline: SizedBox(),
                          dropdownColor: Colors.white,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
