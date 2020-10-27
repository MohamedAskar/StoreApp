import 'package:google_maps_flutter/google_maps_flutter.dart';

class Store {
  String name;
  String address;
  LatLng locationCoords;
  String thumbnail;
  String branchPhoneNumber;

  Store(
      {this.name,
      this.address,
      this.branchPhoneNumber,
      this.thumbnail,
      this.locationCoords});
}

final List<Store> stores = [
  Store(
      name: 'Store - Mall of Egypt',
      address: '6th of October, Giza Governorate',
      thumbnail: 'assets/images/logo.png',
      branchPhoneNumber: '+201069292154',
      locationCoords: LatLng(29.971693, 31.015764)),
  Store(
      name: 'Store - Mall of Tanta',
      address: 'Tanta, Gharbia Governorate',
      thumbnail: 'assets/images/logo.png',
      branchPhoneNumber: '+201289259425',
      locationCoords: LatLng(30.842109, 31.017191)),
  Store(
      name: 'Store - Orouba Mall',
      address: 'Tanta, Gharbia Governorate',
      thumbnail: 'assets/images/logo.png',
      branchPhoneNumber: '+201272055347',
      locationCoords: LatLng(30.804141, 31.023059)),
  Store(
      name: 'Store - City Center Alexandria',
      address: 'Cairo Alex Desert Rd, Alexandria Governorate',
      thumbnail: 'assets/images/logo.png',
      branchPhoneNumber: '+201154668591',
      locationCoords: LatLng(31.167748, 29.931916))
];
