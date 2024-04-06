import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration/userdata.dart';
import 'package:http/http.dart'as http;

class Chat_Page extends StatefulWidget {
  const Chat_Page({super.key});

  @override
  State<Chat_Page> createState() => _Chat_PageState();
}


class _Chat_PageState extends State<Chat_Page> {

  String population = "2.5K"; // Default value
  // Call the API for Delhi's population on init

  void initState() {
    super.initState();
    fetchPopulation("Delhi"); // Call the API for Delhi's population on init
  }

  Future<void> fetchPopulation(String city) async {
  final response = await http.get(Uri.parse('https://neartravel.teleferti.com/api/population?city=$city'));

  if (response.statusCode == 200) {
  // If server returns an OK response, parse the JSON
  final data = jsonDecode(response.body);
  setState(() {
  population = data['Population'].toString();
  print(population);// Assuming 'population' is the key for the population data
  });
  } else {
  // If the server did not return a 200 OK response,
  // then throw an exception.
  throw Exception('Failed to load population data');
  }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 300,
                  height: 160,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: const Color(0xFFF0F0F0),
                  ),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),

                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(
                              "36",
                              style: GoogleFonts.bungee(  fontSize: 75),
                            ),
                            const SizedBox(width: 30),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Similar",style: TextStyle(fontSize: 20),),
                                Text("Business",style: TextStyle(fontSize: 20)),
                                Text("Nearby",style: TextStyle(fontSize: 20)),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 7,),
                Container(
                  alignment: Alignment.center,
                  width: 300,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: const Color(0xFF141414),
                  ),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),

                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              population,
                              style: GoogleFonts.bungee( color: Colors.red, fontSize: 55,fontWeight:FontWeight.bold),
                            ),
                            const SizedBox(width: 30),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("People",style: TextStyle(fontSize: 20,color: Colors.white),),
                                Text("Living",style: TextStyle(fontSize: 20,color: Colors.white)),
                                Text("Nearby",style: TextStyle(fontSize: 20,color: Colors.white)),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                    width: 300,
                    height: 400,
                    child:Image.asset("assets/stats.png")
                ),
                SizedBox(height: 20,),
                Container(
                  height: 164,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Area Population",style: GoogleFonts.montserrat(color:Colors.white,fontSize:20,fontWeight:FontWeight.bold),),
                      SizedBox(height: 10),
                      Text("1.4K",style: GoogleFonts.montserrat(color:Colors.white,fontSize:40,fontWeight:FontWeight.bold),)

                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                    width: 300,
                    height: 400,
                    decoration: BoxDecoration(
                        color: Color(0xffDF4E16)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 198,
                          height: 160,
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            "This is an ideal place for Business",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              height: 1.19, // Line height of 38sp / Font size of 32sp
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Image.asset("assets/spark_s.png"),
                            ),
                          ),
                        )
                      ],
                    )
                )              ],
            ),
          ),
        ),
      ),
    );
  }
}

