
/*
 * Copyright (C) 2019-2024 HERE Europe B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 * License-Filename: LICENSE
 */

import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:integration/ChatPages_Pages.dart';
import 'package:integration/DashBoard_Page.dart';
import 'package:integration/Help_Page.dart';
import 'package:integration/MapHome.dart';
import 'package:integration/Profile_Page.dart';
import 'package:integration/userdata.dart';
import 'package:provider/provider.dart';

import 'SearchExample.dart';
String queryString = 'Vadodara';
int currentIndex = 1;


void main() {
  // Usually, you need to initialize the HERE SDK only once during the lifetime of an application.
  _initializeHERESDK();

  // Ensure that all widgets, including MyApp, have a MaterialLocalizations object available.
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserData(), // Replace this with your actual UserData class
      child: MaterialApp(
        home: MyApp(),
      ),
    ),
  );
}

void _initializeHERESDK() async {
  // Needs to be called before accessing SDKOptions to load necessary libraries.
  SdkContext.init(IsolateOrigin.main);

  // Set your credentials for the HERE SDK.
  String accessKeyId = "lI6zWvPSztDM7VLHbTPqFw";
  String accessKeySecret = "8kPwpuZcxDGz2Ts4RZg_pQT8RU3MY3oKWrfbcHTjpCgFOVYKXK-YM2vpUHD05WQE544tga6cA9atABi5qOh0xg";
  SDKOptions sdkOptions = SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } on InstantiationException {
    throw Exception("Failed to initialize the HERE SDK.");
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          DashBoard_Page(),
          MapHome(),
          Chat_Page(),
          Help_Page(),
          Profile_Page(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, color: Colors.black,),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: Colors.black,),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined, color: Colors.black,),
            label: 'Results',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help, color: Colors.black,),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black,),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}