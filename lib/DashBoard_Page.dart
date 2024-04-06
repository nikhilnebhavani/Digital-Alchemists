import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration/userdata.dart';
import 'package:provider/provider.dart';
import './main.dart';

import 'MapHome.dart';



class DashBoard_Page extends StatefulWidget {
  const DashBoard_Page({super.key});

  @override
  State<DashBoard_Page> createState() => _DashBoard_PageState();
}




enum BusinessSector { atm, hospital, pharmacy, coachingInstitute, restaurant }

class _DashBoard_PageState extends State<DashBoard_Page> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _LocalityController = TextEditingController();
  BusinessSector? _selectedSector;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Added to enable scrolling when content overflows
          child: Container(
            margin: EdgeInsets.only(right: 30, left: 30, top: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tell us Something About You", style: GoogleFonts.poppins(fontSize: 31, fontWeight: FontWeight.w600,height:1.0)),
                const SizedBox(height: 18),
                Text("City", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    fillColor: Color(0xFFF3F8FF),
                    filled: true, // Forgot to set filled to true to see the fill color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: "Mumbai",
                    hintStyle: GoogleFonts.poppins(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 16),
                Text("Locality", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                TextField(
                  controller: _LocalityController,
                  decoration: InputDecoration(
                    fillColor: Color(0xFFF3F8FF),
                    filled: true, // Similarly here
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: "Bandra",
                    hintStyle: GoogleFonts.poppins(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 16),
                Text("Sector of Business", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
                ...BusinessSector.values.map((sector) => RadioListTile<BusinessSector>(
                  title: Container(
                    color: Color(0xFFF3F8FF), // Background color for the radio button
                    child: Padding(
                      padding: EdgeInsets.all(12.0), // Add padding to the title
                      child: Text(
                        getSectorDisplayName(sector),
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  value: sector,
                  groupValue: _selectedSector,
                  onChanged: (BusinessSector? value) {
                    setState(() {
                      _selectedSector = value;
                    });
                  },
                  activeColor: Colors.blue,
                  contentPadding: EdgeInsets.zero, // Remove content padding
                  dense: true,
                )),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: (){
                    final userData = Provider.of<UserData>(context, listen: false);
                    userData.saveUserData(
                      _cityController.text,
                      _LocalityController.text,
                      _selectedSector,
                    );

                    print('City: ${userData.city}');
                    print('Locality: ${userData.locality}');
                    print('Sector of Business: ${getSectorDisplayName(userData.selectedSector!)}');
                    setState(() {
                      currentIndex = 1;
                    });

                    print(currentIndex);

                  },
                  child: Container(

                    height: 41,
                    decoration: BoxDecoration(
                      color: Color(0xFF1573FE),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white, // Text color
                        // Add other text styles as needed
                      ),
                    ),
                  ),
                )



              ],
            ),
          ),
        ),
      ),
    );
  }

  String getSectorDisplayName(BusinessSector sector) {
    switch (sector) {
      case BusinessSector.atm:
        return 'ATM';
      case BusinessSector.hospital:
        return 'Hospital';
      case BusinessSector.pharmacy:
        return 'Pharmacy';
      case BusinessSector.coachingInstitute:
        return 'Coaching Institute';
      case BusinessSector.restaurant:
        return 'Restaurant';
      default:
        return '';
    }
  }
}
