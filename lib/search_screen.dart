import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Destination')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter a location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchLocation(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _searchLocation(BuildContext context) {
    // Simulate searching for Parul University
    if (_controller.text.toLowerCase() == 'parul university') {
      // Assuming these are the coordinates for Parul University
      Navigator.of(context).pop({'latitude': 22.5993, 'longitude': 73.1919});
    } else {
      // Handle search error or invalid input
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location not found')),
      );
    }
  }


}
