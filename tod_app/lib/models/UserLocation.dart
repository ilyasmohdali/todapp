import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';

class UserLocation{

  final String docId;
  final String uid;
  final GeoPoint LatLng;
  final String address;

  UserLocation({this.uid, this.LatLng, this.address, this.docId});
}