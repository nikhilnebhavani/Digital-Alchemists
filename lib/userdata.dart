import 'package:flutter/material.dart';

import 'DashBoard_Page.dart';
class UserData extends ChangeNotifier {
  String? city;
  String? locality;
  BusinessSector? selectedSector;

  void saveUserData(String city, String locality, BusinessSector? sector) {
    this.city = city;
    this.locality = locality;
    this.selectedSector = sector;
    notifyListeners();
  }
}