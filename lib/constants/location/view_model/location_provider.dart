// // ignore_for_file: use_build_context_synchronously

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';

// class LocationProvider extends ChangeNotifier {
//   String? vendorLat;
//   String? vendorLong;
//   String? vendorDistrict;
//   String? vendorState;
//   String? placeName;

//   Future<String> getPlaceNameFromLatLng(double? latitude, double? longitude) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(latitude ?? 0.00, longitude ?? 0.00);

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         vendorLat = latitude.toString();
//         vendorLong = longitude.toString();
//         vendorDistrict = place.subAdministrativeArea ?? "District not found";
//         vendorState = place.administrativeArea ?? "State not found";
//         placeName = place.locality ?? "Place name not found";
//         log(
//           'vendorLat: $vendorLat vendorLong: $vendorLong vendorDistrict: $vendorDistrict vendorState: $vendorState placeName: $placeName',
//         );
//         notifyListeners();
//         return place.locality ?? "Place name not found";
//       }
//     } catch (e) {
//       notifyListeners();
//     }
//     return "Place name not found";
//   }

//   void clearFields() {
//     vendorLat = null;
//     vendorLong = null;
//     vendorDistrict = null;
//     vendorState = null;
//     placeName = null;

//     notifyListeners();
//   }

//   setEditFileds() {}
// }
