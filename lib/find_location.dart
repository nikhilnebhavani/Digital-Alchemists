import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here_sdk/routing.dart';

class Locationnnnn extends StatefulWidget {
  const Locationnnnn({super.key});

  @override
  State<Locationnnnn> createState() => _LocationnnnnnState();
}

class _LocationnnnnnState extends State<Locationnnnn> {
  HereMapController? _hereMapController; // Reference to the map controller
  int idx=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            idx=index;
          });
        },
        currentIndex: idx,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search),label: "Search"),
        ],
      ),
      body: HereMap(
        onMapCreated: _onMapCreated,
      ),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    _hereMapController = hereMapController; // Store the map controller
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalNight, (MapError? error) {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      HereMapController.primaryLanguage = LanguageCode.enUs;
      // Once the map is created and scene is loaded, determine the position
      _determinePosition();
    });
  }
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, cannot get location.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the device's location.
    Position position = await Geolocator.getCurrentPosition();
    _moveToCurrentLocation(position);
  }

  void _moveToCurrentLocation(Position position) {
    if (_hereMapController == null) {
      print("HereMapController is not initialized yet.");
      return;
    }
    print('Current Position: ${position.latitude}, ${position.longitude}');
    const double distanceToEarthInMeters = 15; // Adjust zoom level as needed
    _hereMapController!.camera.lookAtPointWithMeasure(
        GeoCoordinates(position.latitude, position.longitude),
        MapMeasure(MapMeasureKind.zoomLevel, distanceToEarthInMeters));

    addRoute(_hereMapController!, startPoints: GeoCoordinates(position.latitude, position.longitude), endPoints: GeoCoordinates(19.2288066,72.8535858));

  }

  void addRoute(HereMapController hereMapController,{
    required GeoCoordinates startPoints,
    required GeoCoordinates endPoints
  }){
    RoutingEngine routingEngine=RoutingEngine();
    Waypoint startWaypoints=Waypoint.withDefaults(startPoints);
    Waypoint endWaypoints=Waypoint.withDefaults(endPoints);
    List<Waypoint> waypoints=[startWaypoints,endWaypoints];

    routingEngine.calculateCarRoute(waypoints, CarOptions(), (error, routing) {
      if(error==null){
        var route=routing!.first;
        GeoPolyline routeGeoPolyline =route.geometry;
        double widthInPixels=20;
        var mpPolyLine=MapPolyline(routeGeoPolyline, widthInPixels, Colors.blue);
        hereMapController.mapScene.addMapPolyline(mpPolyLine);
      }
    });


  }


}
