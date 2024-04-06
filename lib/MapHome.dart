import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/mapview.dart';

import 'SearchExample.dart';
import 'main.dart';
String searchTerm = "ATM";

class MapHome extends StatefulWidget {
  const MapHome({super.key});

  @override
  State<MapHome> createState() => _MapHomeState();
}

class _MapHomeState extends State<MapHome> {

  SearchExample? _searchExample;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white10,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                HereMap(onMapCreated: _onMapCreated),
                // Any other widgets you want to place on top of the map
              ],
            ),
          ),
          Container(
            color: Colors.white10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                button('Show Result', _searchButtonClicked),
                button('Search', _geocodeAnAddressButtonClicked),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError? error) {
      if (error == null) {
        _searchExample = SearchExample(_showDialog, hereMapController);

      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }
    });
  }

  void _geocodeAnAddressButtonClicked() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter City Name'),
          content: TextField(
            controller: controller, // Assign the controller to the TextField
            decoration: InputDecoration(hintText: "City Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Get the text from the TextEditingController
                String enteredText = controller.text;
                setState(() {
                  queryString = enteredText;
                  print("I got my ans: $queryString");

                });
                Navigator.of(context).pop();
                // Perform geocoding with the updated queryString here
                _performGeocoding();
              },
            ),
          ],
        );
      },
    );
  }

  void _performGeocoding() {
    if (_searchExample != null) {
      _searchExample!.geocodeAnAddressButtonClicked();
    }
  }


  void _searchButtonClicked() {
    _showSearchTermDialog();
  }

  void _showSearchTermDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // List of options for the user to choose from.
        List<String> options = [
          "ATM",
          "Hospital",
          "Pharmacy",
          "Coaching Institute",
          "Restaurant"
        ];

        return AlertDialog(
          title: Text('Select a category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: options.map((String option) {
                return GestureDetector(
                  onTap: () {
                    // Update the searchTerm with the selected option.
                    setState(() {
                      searchTerm = option;
                      print("Selected search term: $searchTerm");
                      Navigator.of(context).pop();
                      _searchExample?.searchNearbyATMs();// Close the dialog.
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(option),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Free HERE SDK resources before the application shuts down.
    SDKNativeEngine.sharedInstance?.dispose();
    SdkContext.release();
    super.dispose();
  }

  // A helper method to add a button on top of the HERE map.
  Align button(String buttonLabel, Function callbackFunction) {
    return Align(
      alignment: Alignment.topCenter,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.black,
        ),
        onPressed: () => callbackFunction(),
        child: Text(buttonLabel, style: TextStyle(fontSize: 20)),
      ),
    );
  }

  // A helper method to show a dialog.
  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}