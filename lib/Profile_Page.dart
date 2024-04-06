import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile_Page extends StatefulWidget {
  const Profile_Page({Key? key}) : super(key: key);

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  File? _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Profile",
                    style: GoogleFonts.poppins(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  "Don’t worry, you can always change it later",
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  child: GestureDetector(
                    onTap: (){
                      getImage();
                    },
                      child: Image.asset("assets/Avatar.png")),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    // controller: _cityController,
                    decoration: InputDecoration(
                      fillColor: Color(0xFFF3F8FF),
                      filled: true, // Forgot to set filled to true to see the fill color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: "Full Name",
                      hintStyle: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    // controller: _cityController,
                    decoration: InputDecoration(
                      fillColor: Color(0xFFF3F8FF),
                      filled: true, // Forgot to set filled to true to see the fill color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: "Nick Name",
                      hintStyle: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    // controller: _cityController,
                    decoration: InputDecoration(
                      fillColor: Color(0xFFF3F8FF),
                      filled: true, // Forgot to set filled to true to see the fill color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: "Email",
                      hintStyle: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    // controller: _cityController,
                    decoration: InputDecoration(
                      fillColor: Color(0xFFF3F8FF),
                      filled: true, // Forgot to set filled to true to see the fill color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: "Phone Number",
                      hintStyle: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height:50,
                    decoration: BoxDecoration(
                      color: Color(0XFFFF2F2F)
                    ),
                    child: Center(child: Text("SUBMIT",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),),
                  )
                ),
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
