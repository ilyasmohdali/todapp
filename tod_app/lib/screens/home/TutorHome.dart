import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tod_app/Map/map.dart';
import 'package:tod_app/Map/map2.dart';
import 'package:tod_app/Sidebar/TutorDrawer.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TutorHome extends StatefulWidget{
  final String uid;
  TutorHome({this.uid});

  @override
  _TutorHomeState createState() => _TutorHomeState();

}

class _TutorHomeState extends State<TutorHome>{

  FirebaseUser user;

  String uid, docID;
  Future<LocationData> _getUserLocation;
  Location location = new Location();

  LatLng _markerLocation;
  LatLng _userLocation;
  String _resultAddress;


  GoogleMapController mapController;

  getAddress(String uid, String docID){
    Firestore.instance.collection('locations').where('docID' ,isEqualTo: docID).getDocuments().then((docs){
      if(docs.documents.isNotEmpty){
        String resultAddress = '';
        int i;
        for( i=0; i<docs.documents.length; i++) {
          resultAddress = docs.documents[i].data['resultAddress'];
        }
        return Text("$resultAddress");
      }
      else{
        return Container(child:Text("hello"));
      }
    });
  }





  @override
  void initState() {
    super.initState();
    _getUserLocation = getUserLocation();
    getAddress(uid,docID);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extendBodyBehindAppBar: true,
        backgroundColor: Color(0xFFbee8f9),
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Home"),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0.0,
        ),
        drawer: TutorDrawer(),
        body: //FireMap2(userLocation: _userLocation)
        SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child:
                  FutureBuilder<LocationData>(
                    future: _getUserLocation,
                    builder: (context,snapshot){
                      switch(snapshot.hasData){
                        case true:
                          return FireMap2(
                            markerLocation: _markerLocation,
                            userLocation: _userLocation,
                            onTap: (location){
                              setState(() {
                                _markerLocation = location;
                              });
                            },
                          );
                        default: return Center();
                      }
                    },
                  ),
                ),
                //getAddress(uid,docID)

                /*Text(
                   _resultAddress ?? " Address shown here", style: TextStyle(fontFamily: "Poppins", fontSize: 15.0),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(child: Text("Get My Location Address"),
                  onPressed: () async {if(_userLocation != null){
                   getSetAddress(Coordinates(_userLocation.latitude,_userLocation.longitude));}
                  }),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(child: Text("Get Marker Address"),
                      onPressed: () async {if(_markerLocation != null){
                        getSetAddress(Coordinates(_markerLocation.latitude,_markerLocation.longitude));}
                      }),
                ),*/
               ],
            )
        ),
        );
  }



  Future<LocationData> getUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.requestService();
    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled){
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return null;
      }
    }
    final result =  await location.getLocation();
    _userLocation = LatLng(result.latitude, result.longitude);
    return result;
  }

  getSetAddress(Coordinates coordinates) async {
    final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      _resultAddress = addresses.first.addressLine;
    });
  }
}