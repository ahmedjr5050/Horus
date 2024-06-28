import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  static const String location = '/map';
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  LocationData? _locationData;
  LatLng photomarketLocation = const LatLng(
      30.04131686121775, 31.222822700130997); // Photomarket location
  late BitmapDescriptor customMarkerIcon; // Custom marker icon
  double customMarkerSize = 50.0; // Size of the custom marker icon
  Polyline? _polyline; // Polyline between user location and photomarket

  @override
  void initState() {
    super.initState();
    _createCustomMarkerBitmap('lib/core/assets/images/mosque.png')
        .then((BitmapDescriptor icon) {
      setState(() {
        customMarkerIcon = icon;
        _getLocation();
      });
    });
  }

  Future<void> _getLocation() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permission;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Location services are still not enabled
        return;
      }
    }

    permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        // Location permission not granted
        return;
      }
    }

    _locationData = await location.getLocation();
    if (_locationData != null) {
      setState(() {
        print(_locationData!.latitude);
        print(_locationData!.longitude);
        _updateMap(_locationData!.latitude!, _locationData!.longitude!);
        _updatePolyline(); // Update polyline when location is obtained
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showBottomSheet(context);
      });
    }
  }

  void _updateMap(double lat, double long) {
    if (_controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, long),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  void _updatePolyline() {
    if (_locationData != null) {
      setState(() {
        _polyline = Polyline(
          polylineId: const PolylineId('user_to_photomarket'),
          points: [
            LatLng(_locationData!.latitude!, _locationData!.longitude!),
            photomarketLocation,
          ],
          color: Colors.blue,
          width: 5,
        );
      });
    }
  }

  Future<BitmapDescriptor> _createCustomMarkerBitmap(
      String imageAssetPath) async {
    ByteData byteData = await rootBundle.load(imageAssetPath);
    Uint8List byteList =
        byteData.buffer.asUint8List(); // Convert List<int> to Uint8List
    return BitmapDescriptor.fromBytes(byteList);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 300,
          width: 350,
          child: ListView(
            children: [
              _buildListTile(
                context,
                'lib/core/assets/images/upber.png',
                'Uber',
                'https://play.google.com/store/apps/details?id=com.ubercab&hl=ar',
              ),
              _buildListTile(
                context,
                'lib/core/assets/images/didi.jpg',
                'Didi',
                'https://play.google.com/store/apps/details?id=com.didiglobal.passenger&hl=ar',
              ),
              _buildListTile(
                context,
                'lib/core/assets/images/indrive.png',
                'InDriver',
                'https://play.google.com/store/apps/details?id=sinet.startup.inDriver&hl=ar',
              ),
              _buildListTile(
                context,
                'lib/core/assets/images/carem.jpg',
                'Careem',
                'https://play.google.com/store/apps/details?id=com.careem.acma',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile(
      BuildContext context, String imagePath, String title, String url) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(5.0),
        leading: Image.asset(imagePath),
        title: Text(title),
        onTap: () {
          _launchURL(url);
        },
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.drive_eta, color: Colors.black, size: 33),
            onPressed: () {
              _showBottomSheet(context);
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 15.0,
        ),
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
            if (_locationData != null) {
              _updateMap(_locationData!.latitude!, _locationData!.longitude!);
            }
          });
        },
        markers: _locationData != null
            ? Set<Marker>.from([
                Marker(
                  markerId: const MarkerId('user_location'),
                  position: LatLng(
                      _locationData!.latitude!, _locationData!.longitude!),
                  infoWindow: const InfoWindow(
                    title: 'My Location',
                  ),
                ),
                Marker(
                  markerId: const MarkerId('photomarket_location'),
                  position: photomarketLocation,
                  infoWindow: const InfoWindow(
                    title: 'Photomarket',
                  ),
                  icon: customMarkerIcon != null
                      ? customMarkerIcon
                      : BitmapDescriptor.defaultMarker,
                ),
              ])
            : Set<Marker>.identity(),
        polylines: _polyline != null
            ? Set<Polyline>.of([_polyline!])
            : Set<Polyline>.identity(),
      ),
    );
  }
}
