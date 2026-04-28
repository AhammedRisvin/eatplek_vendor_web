import 'package:flutter/material.dart';

import '../model/country_model.dart';

class CountryController extends ChangeNotifier {
  String countryName = "India";

  Map<String, Object> country = {};

  void countryChanged(Map<String, Object> country, String filteredCountryNam) async {
    this.country = country;
    countryName = filteredCountryNam;
    notifyListeners();
  }

  int numberValidate() {
    return int.tryParse("${country["numberLength"]}") ?? 1;
  }

  CountryController() {
    country = countryMap[countryName] ?? {};
  }
}
