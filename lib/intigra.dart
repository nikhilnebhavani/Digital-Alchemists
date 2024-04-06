import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
class INTRIGRA extends StatefulWidget {
  const INTRIGRA({super.key});

  @override
  State<INTRIGRA> createState() => _INTRIGRAState();
}

class _INTRIGRAState extends State<INTRIGRA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HereMap(
        onMapCreated: _onMapCreated,

      ),
    );
  }
}

void _onMapCreated(HereMapController hereMapController) {
  hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalNight, (MapError? error) {
    if (error != null) {
      print('Map scene not loaded. MapError: ${error.toString()}');
      return;
    }

    HereMapController.primaryLanguage = LanguageCode.enUs;

    var currlat=22.2713731;
    var currlong=73.2324315;

    const double distanceToEarthInMeters = 15;
    MapMeasure mapMeasureZoom = MapMeasure(MapMeasureKind.zoomLevel, distanceToEarthInMeters);
    hereMapController.camera.lookAtPointWithMeasure(GeoCoordinates(currlat,currlong), mapMeasureZoom);
    addRoute(hereMapController, startPoints: GeoCoordinates(22.2713731,73.2324315), endPoints: GeoCoordinates(22.2883679,73.3628989));
  });
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

