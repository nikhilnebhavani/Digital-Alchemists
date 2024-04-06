import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getPOIs(String location, int radius, String category) async {
  final String apiKey = 'lI6zWvPSztDM7VLHbTPqFw';
  final String apiUrl = 'https://places.ls.hereapi.com/places/v1/discover/explore?at=$location&cat=$category&apiKey=$apiKey&size=100&radius=$radius';

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> pois = data['results']['items'];
      return pois;
    } else {
      throw Exception('Failed to fetch data');
    }
  } catch (error) {
    print('Error fetching data: $error');
    return [];
  }
}


class MyAppMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POI Finder',
      home: Scaffold(
        appBar: AppBar(
          title: Text('POI Finder'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final String location = '19.2288066,72.8535858'; // Example location (Berlin, Germany)
              final int radius = 1000; // Example radius in meters
              final String category = 'ATM'; // Example category (ATMs)
              final pois = await getPOIs(location, radius, category);
              print('Found ${pois.length} ${category.toUpperCase()}s within $radius meters of the location.');
            },
            child: Text('Fetch POIs'),
          ),
        ),
      ),
    );
  }
}