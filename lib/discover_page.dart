import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  GoogleMapController? _mapController;
  bool _showMap = false;
  Position? _currentPosition;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _isLoading = false;
        _showMap = true; // Add this line to show the map after getting the location
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
      ),
      body: Column(
        children: [
          // Add a button on top center with an icon "Discover" and a text below it "Find where you are!"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'Find where you are!',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading? null : _getCurrentLocation, // Add your button press action here
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.explore),
                          Text('Discover'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : _showMap
              ? Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition!= null
                    ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                    : LatLng(37.7749, -122.4194),
                zoom: 12,
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}