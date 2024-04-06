


import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/search.dart';
import 'package:integration/main.dart';
import 'package:integration/userdata.dart';
import 'package:provider/provider.dart';

import 'MapHome.dart';
import 'SearchResultMetadata.dart';

// A callback to notify the hosting widget.
typedef ShowDialogFunction = void Function(String title, String message);



class SearchExample {
  HereMapController _hereMapController;
  MapCamera _camera;
  MapImage? _poiMapImage;
  List<MapMarker> _mapMarkerList = [];
  late SearchEngine _searchEngine;
  ShowDialogFunction _showDialog;



  SearchExample(
      ShowDialogFunction showDialogCallback,
      HereMapController hereMapController,
      // Add this line for queryString parameter.
      )
      : _showDialog = showDialogCallback,
        _hereMapController = hereMapController,
        _camera = hereMapController.camera
  { // Assign the parameter value to _queryString.
    HereMapController.primaryLanguage = LanguageCode.enUs;
    double distanceToEarthInMeters = 10000;
    MapMeasure mapMeasureZoom = MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
    _camera.lookAtPointWithMeasure(GeoCoordinates(19.2288066,72.8535858), mapMeasureZoom);

    try {
      _searchEngine = SearchEngine();
    } on InstantiationException {
      throw Exception("Initialization of SearchEngine failed.");
    }

    _moveToCurrentLocation();
    _setTapGestureHandler();
    _setLongPressGestureHandler();

    _showDialog("Note", "Long press on map to get the address for that position using reverse geocoding.");
  }

  Future<void> searchButtonClicked() async {
    // Search for "Pizza" and show the results on the map.
    _searchExample();

    // Search for auto suggestions and log the results to the console.
    _autoSuggestExample();
  }

  Future<void> geocodeAnAddressButtonClicked() async {
    // Search for the location that belongs to an address and show it on the map.
    _geocodeAnAddress();
  }

  void _searchExample() {
    print("Getting");
    print(UserData().selectedSector);
    String searchTerm = UserData().selectedSector as String ;
    print("Searching in viewport for: " + searchTerm);
    _searchInViewport(searchTerm);
  }

  void _moveToCurrentLocation() async {
    if (_hereMapController == null) {
      print("HereMapController is not initialized yet.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    print('Current Position: ${position.latitude}, ${position.longitude}');
    const double distanceToEarthInMeters = 15; // Adjust zoom level as needed
    _hereMapController!.camera.lookAtPointWithMeasure(
      GeoCoordinates(position.latitude, position.longitude),
      MapMeasure(MapMeasureKind.zoomLevel, distanceToEarthInMeters),
    );

    GeoCoordinates cor=GeoCoordinates(position.latitude, position.longitude);
    _addPoiMapMarker(cor);


  }


  void _geocodeAnAddress() {
    // Move map to expected location.
    GeoCoordinates geoCoordinates = GeoCoordinates(19.2288066,72.8535858);
    double distanceToEarthInMeters = 1000 * 5;
    MapMeasure mapMeasureZoom = MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
    _camera.lookAtPointWithMeasure(geoCoordinates, mapMeasureZoom);

    // String queryString = "Narpoli";



    print("Finding locations for: $queryString. Tap marker to see the coordinates.");

    _geocodeAddressAtLocation(queryString, geoCoordinates, _hereMapController);
  }

  void _setTapGestureHandler() {
    _hereMapController.gestures.tapListener = TapListener((Point2D touchPoint) {
      _pickMapMarker(touchPoint);
    });
  }

  void _setLongPressGestureHandler() {
    _hereMapController.gestures.longPressListener = LongPressListener((GestureState gestureState, Point2D touchPoint) {
      if (gestureState == GestureState.begin) {
        GeoCoordinates? geoCoordinates = _hereMapController.viewToGeoCoordinates(touchPoint);
        if (geoCoordinates == null) {
          return;
        }
        _addPoiMapMarker(geoCoordinates);
        _getAddressForCoordinates(geoCoordinates);
      }
    });
  }

  Future<void> _getAddressForCoordinates(GeoCoordinates geoCoordinates) async {
    SearchOptions reverseGeocodingOptions = SearchOptions();
    reverseGeocodingOptions.languageCode = LanguageCode.enGb;
    reverseGeocodingOptions.maxItems = 1;

    _searchEngine.searchByCoordinates(geoCoordinates, reverseGeocodingOptions,
            (SearchError? searchError, List<Place>? list) async {
          if (searchError != null) {
            _showDialog("Reverse geocoding", "Error: " + searchError.toString());
            return;
          }

          // If error is null, list is guaranteed to be not empty.
          _showDialog("Reverse geocoded address:", list!.first.address.addressText);
        });
  }

  void _pickMapMarker(Point2D touchPoint) {
    double radiusInPixel = 2;
    _hereMapController.pickMapItems(touchPoint, radiusInPixel, (pickMapItemsResult) {
      if (pickMapItemsResult == null) {
        // Pick operation failed.
        return;
      }
      List<MapMarker> mapMarkerList = pickMapItemsResult.markers;
      if (mapMarkerList.length == 0) {
        print("No map markers found.");
        return;
      }

      MapMarker topmostMapMarker = mapMarkerList.first;
      Metadata? metadata = topmostMapMarker.metadata;
      if (metadata != null) {
        CustomMetadataValue? customMetadataValue = metadata.getCustomValue("key_search_result");
        if (customMetadataValue != null) {
          SearchResultMetadata searchResultMetadata = customMetadataValue as SearchResultMetadata;
          String title = searchResultMetadata.searchResult.title;
          String vicinity = searchResultMetadata.searchResult.address.addressText;
          _showDialog("Picked Search Result", title + ". Vicinity: " + vicinity);
          return;
        }
      }

      double lat = topmostMapMarker.coordinates.latitude;
      double lon = topmostMapMarker.coordinates.longitude;
      _showDialog("Picked Map Marker", "Geographic coordinates: $lat, $lon.");
    });
  }

  Future<void> _searchInViewport(String queryString) async {
    _clearMap();

    GeoBox viewportGeoBox = _getMapViewGeoBox();
    TextQueryArea queryArea = TextQueryArea.withBox(viewportGeoBox);
    TextQuery query = TextQuery.withArea(queryString, queryArea);

    SearchOptions searchOptions = SearchOptions();
    searchOptions.languageCode = LanguageCode.enUs;
    searchOptions.maxItems = 30;

    _searchEngine.searchByText(query, searchOptions, (SearchError? searchError, List<Place>? list) async {
      if (searchError != null) {
        _showDialog("Search", "Error: " + searchError.toString());
        return;
      }

      // If error is null, list is guaranteed to be not empty.
      int listLength = list!.length;
      _showDialog("Search for $queryString", "Results: $listLength. Tap marker to see details.");

      // Add new marker for each search result on map.
      for (Place searchResult in list) {
        Metadata metadata = Metadata();
        metadata.setCustomValue("key_search_result", SearchResultMetadata(searchResult));
        // Note: getGeoCoordinates() may return null only for Suggestions.
        addPoiMapMarker(searchResult.geoCoordinates!, metadata);
      }
    });
  }

  Future<void> _autoSuggestExample() async {
    GeoCoordinates centerGeoCoordinates = _getMapViewCenter();

    SearchOptions searchOptions = SearchOptions();
    searchOptions.languageCode = LanguageCode.enUs;
    searchOptions.maxItems = 5;

    TextQueryArea queryArea = TextQueryArea.withCenter(centerGeoCoordinates);

    // Simulate a user typing a search term.
    _searchEngine.suggest(
        TextQuery.withArea(
            "p", // User typed "p".
            queryArea),
        searchOptions, (SearchError? searchError, List<Suggestion>? list) async {
      _handleSuggestionResults(searchError, list);
    });

    _searchEngine.suggest(
        TextQuery.withArea(
            "pi", // User typed "pi".
            queryArea),
        searchOptions, (SearchError? searchError, List<Suggestion>? list) async {
      _handleSuggestionResults(searchError, list);
    });

    _searchEngine.suggest(
        TextQuery.withArea(
            "piz", // User typed "piz".
            queryArea),
        searchOptions, (SearchError? searchError, List<Suggestion>? list) async {
      _handleSuggestionResults(searchError, list);
    });
  }

  void _handleSuggestionResults(SearchError? searchError, List<Suggestion>? list) {
    if (searchError != null) {
      print("Autosuggest Error: " + searchError.toString());
      return;
    }

    // If error is null, list is guaranteed to be not empty.
    int listLength = list!.length;
    print("Autosuggest results: $listLength.");

    for (Suggestion autosuggestResult in list) {
      String addressText = "Not a place.";
      Place? place = autosuggestResult.place;
      if (place != null) {
        addressText = place.address.addressText;
      }

      print("Autosuggest result: " + autosuggestResult.title + " addressText: " + addressText);
    }
  }

  Future<void> _geocodeAddressAtLocation(String queryString, GeoCoordinates geoCoordinates, HereMapController hereMapController) async {
    _clearMap();

    AddressQuery query = AddressQuery.withAreaCenter(queryString, geoCoordinates);

    SearchOptions searchOptions = SearchOptions();
    searchOptions.languageCode = LanguageCode.enUs;
    searchOptions.maxItems = 100;

    _searchEngine.searchByAddress(query, searchOptions, (SearchError? searchError, List<Place>? list) async {
      if (searchError != null) {
        _showDialog("Geocoding", "Error: " + searchError.toString());
        return;
      }

      String locationDetails = "";

      // If error is null, list is guaranteed to be not empty.
      for (Place geocodingResult in list!) {
        // Note: getGeoCoordinates() may return null only for Suggestions.
        GeoCoordinates geoCoordinates = geocodingResult.geoCoordinates!;
        Address address = geocodingResult.address;
        String locationDetails = address.addressText +
            ". GeoCoordinates: " +
            geoCoordinates.latitude.toString() +
            ", " +
            geoCoordinates.longitude.toString();

        print("GeocodingResult: " + locationDetails);

        _addPoiMapMarker(geoCoordinates);

        // Move the camera to the specified location.
        double distanceToEarthInMeters = 1000 * 5; // Adjust as needed
        MapMeasure mapMeasureZoom = MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
        hereMapController.camera.lookAtPointWithMeasure(geoCoordinates, mapMeasureZoom);

      }


      int itemsCount = list.length;
      _showDialog("Number of area: $itemsCount", locationDetails);
    });
  }

  Future<MapMarker> _addPoiMapMarker(GeoCoordinates geoCoordinates) async {
    // Reuse existing MapImage for new map markers.
    if (_poiMapImage == null) {
      Uint8List imagePixelData = await _loadFileAsUint8List('poi.png');
      _poiMapImage = MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    MapMarker mapMarker = MapMarker(geoCoordinates, _poiMapImage!);
    _hereMapController.mapScene.addMapMarker(mapMarker);
    _mapMarkerList.add(mapMarker);

    return mapMarker;
  }

  Future<Uint8List> _loadFileAsUint8List(String fileName) async {
    // The path refers to the assets directory as specified in pubspec.yaml.
    ByteData fileData = await rootBundle.load('assets/' + fileName);
    return Uint8List.view(fileData.buffer);
  }

  Future<void> addPoiMapMarker(GeoCoordinates geoCoordinates, Metadata metadata) async {
    MapMarker mapMarker = await _addPoiMapMarker(geoCoordinates);
    mapMarker.metadata = metadata;
  }

  GeoCoordinates _getMapViewCenter() {
    return _camera.state.targetCoordinates;
  }



  GeoBox _getMapViewGeoBox() {
    GeoBox? geoBox = _camera.boundingBox;
    if (geoBox == null) {
      print(
          "GeoBox creation failed, corners are null. This can happen when the map is tilted. Falling back to a fixed box.");
      GeoCoordinates southWestCorner = GeoCoordinates(
          _camera.state.targetCoordinates.latitude - 0.05, _camera.state.targetCoordinates.longitude - 0.05);
      GeoCoordinates northEastCorner = GeoCoordinates(
          _camera.state.targetCoordinates.latitude + 0.05, _camera.state.targetCoordinates.longitude + 0.05);
      geoBox = GeoBox(southWestCorner, northEastCorner);
    }
    return geoBox;
  }

  void _clearMap() {
    _mapMarkerList.forEach((mapMarker) {
      _hereMapController.mapScene.removeMapMarker(mapMarker);
    });
    _mapMarkerList.clear();
  }


  Future<void> searchNearbyATMs() async {




    GeoCoordinates userLocation = _getMapViewCenter();
    double searchRadius = 1000.00;
    // String searchTerm = "ATM";
    GeoCircle searchArea = GeoCircle(userLocation, searchRadius );
    TextQueryArea queryArea = TextQueryArea.withCircle(searchArea);
    TextQuery query = TextQuery.withArea(searchTerm, queryArea);


    SearchOptions searchOptions = SearchOptions();
    searchOptions.languageCode = LanguageCode.enUs;
    searchOptions.maxItems = 100;

    _searchEngine.searchByText(query, searchOptions, (SearchError? searchError, List<Place>? list) async {
      if (searchError != null) {
        // Handle the search error.
        print("Search Error: ${searchError.toString()}");
        return;
      }


      int foundATMs = list?.length ?? 0;
      print('Found $foundATMs $searchTerm within $searchRadius meters of the location.');

      var map={
        searchTerm:foundATMs
      };
      print(map);

      Fluttertoast.showToast(
        msg: 'Found $foundATMs $searchTerm within $searchRadius meters of the location.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );



      for (Place place in list!) {
        Metadata metadata = Metadata();
        metadata.setCustomValue("key_search_result", SearchResultMetadata(place));
        addPoiMapMarker(place.geoCoordinates!, metadata);
      }
    });


  }


}


