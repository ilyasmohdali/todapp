import 'dart:collection';
import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tod_app/Sidebar/StudentDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tod_app/Services/database.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Widgets/wrapper.dart';
import 'package:tod_app/models/User.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:rxdart/rxdart.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:tod_app/screens/home/StudentHome.dart';
import 'package:tod_app/Widgets/loading.dart';
import 'package:url_launcher/url_launcher.dart';


class FireMap extends StatefulWidget {


  final uid, markerLocation, userLocation, onTap;
  FireMap({this.uid,this.markerLocation,this.userLocation,this.onTap});

  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  Location _location = Location();
  Set<Circle> circles = HashSet<Circle>();
  //RangeValues values = RangeValues(100,1000);
  final _formkey = GlobalKey<FormState>();
  Geoflutterfire geo;
  //List<Marker> allMarkers = [];

  /*static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }*/

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=l&query=$latitude,$longitude';
    if(await canLaunch(googleUrl)){
      await launch(googleUrl);
    }else{
      throw 'map could not be opened';
    }
  }


  //double value;
  double radius2 =1000.0;
  int radii = 100;
  //static BehaviorSubject seedValue;

  BehaviorSubject<double> radius = BehaviorSubject<double>.seeded(1.0);

  Stream<List<DocumentSnapshot>> stream;
  //ValueConnectableStream<double> radius = new ValueConnectableStream<double>(stream);
  Stream<dynamic> query;

  StreamSubscription subscription;
  //List<DocumentSnapshot> documentList;

  Position _position;

  Position currentLocation;
  var tutors =[];
  String searchAddress;
  //Set<Marker> _marker = HashSet<Marker>();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circle = <CircleId, Circle>{};


  _getCurrentLocation() async{
    var currentLocation = await Geolocator().getCurrentPosition();
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  LatLng _userLocation;

  bool mapToggle = false;
  bool tutorsToggle = false;
  var filterDist;
  var radius3;

  Future<LocationData> _getUserLocation;
  Location location = new Location();

  //LatLng initialPosition = LatLng(3.0697,101.5037);
  LatLng initialPosition = LatLng(2.2262,102.4547);
  double value;

  //List<DocumentSnapshot> documentList;
  //var data, distance, docID;
  @override
  void initState(){
    super.initState();
    _setCircles(mapController);
    //_onMapCreated(mapController);
    _getCurrentLocation();
    //filterMarkers(dist);

    geo = Geoflutterfire();
    GeoFirePoint center = geo.point(latitude: initialPosition.latitude, longitude: initialPosition.longitude);
    stream = radius.switchMap((rad){
      var collectionReference = firestore.collection('locations');
      return geo.collection(collectionRef: collectionReference).within(center: center, radius: rad, field: 'position', strictMode: true);
    });

    //getDist();
    //placeFilteredMarker(data, distance, docID);
    //_updateQuery(value);
    //_updateMarkers(documentList);
    //dispose();
    Geolocator().getCurrentPosition().then((currLoc){
      setState(() {
        currentLocation = currLoc;
        mapToggle = true;
        //setMarkers();
      });
    });

  }
  Distance dist;

  @override
  Widget build(BuildContext context) {
//setMarkers();

    //setState(() {
      //_setCircles(mapController);
      //filterMarkers(dist);
      //setMarkers();
      //_onMapCreated(mapController);
      //_startQuery();
    //});
    //_startQuery();
    return Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 14.0
            ),
            //myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            circles: circles,
            //circles: Set<Circle>.of(circle.values),
            markers: Set<Marker>.of(markers.values),
            myLocationEnabled: true,
          ),
          /*Positioned(
          top: 27.0,
          right: 5.0,
          left: 5.0,
          child: Container(
            //padding: EdgeInsets.only(left: 40.0),
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white
            ),
            child: TextField(
              decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 50.0, top: 16.0),
              suffixIcon: IconButton(
                  icon: Icon(Icons.search),
              onPressed: searchAndNavigate,
             )), onChanged: (val) {
                setState(() {
                  searchAddress = val;
                });
              },
            ),
        )),*/

          /*Positioned(
          bottom: 0.0,
          right: 0.0,
          left: 0.0,
          child: Container(
            height: 180.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: Column(
              children: <Widget>[
                Container(
                  //padding: EdgeInsets.only(left: 40.0),
                  height: 45.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Set Radius (Meter)',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 22.0, top: 16.0),
                        /*suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: searchAndNavigate,
                        )*/),
                   /*onChanged: (val) {
                    setState(() {
                      searchAddress = val;
                    });
                  },*/
                  ),
                ),

                Slider(
                  min: 100,
                  max: 1000,
                  divisions: 9,
                  value: radius,
                  onChanged: (val)=> setState(() => radius = val),
                  label: "$radius",
                ),
                Text("Radius: $radius")
              ],
            ),
          ),
        )*/
         
          
          Positioned(
            bottom: 18.0,
            left: 20.0,
            //right: 20.0,
            child: Container(
              height: 42.0,
              width: 280.0,
              child: RaisedButton(
                color: Colors.blue,
                child: Text("Set Radius", style: TextStyle(color: Colors.white),),
                onPressed: showRadiusSlider
                //onPressed: getDist,
              ),
            ),
          )
          /*Positioned(
          bottom: 50.0,
          child: FloatingActionButton(
            child: Icon(Icons.pin_drop, color: Colors.black),
            onPressed: _getLocation
          ),
        )*/
        ]);
  }


  void _onMapCreated(GoogleMapController controller) {
    //_startQuery();
    setState(() {
      mapController = controller;
      stream.listen((List<DocumentSnapshot> documentList){
        _updateMarker(documentList);
      });
    });
  }
  /*void _onMapCreated(GoogleMapController controller){
    setState(() {
      mapController = controller;
    });
  }*/


  /*searchAndNavigate() {
    setState(() {
      Geolocator().placemarkFromAddress(searchAddress).then((result) {
        mapController.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(
                    result[0].position.longitude, result[0].position.longitude),
                zoom: 10.0
            )));
      });
    });
  }*/


  /*void _getLocation() async {
    var currentLocation = await Geolocator().getCurrentPosition();

    setState(() {
      markers.clear();
      final marker = Marker(
        markerId: MarkerId("current_location"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: "Current Location")
      );
      markers["Current Location"] = marker;
    });
  }*/



  void _setCircles(GoogleMapController controller) async{
    var currentLocation = await Geolocator().getCurrentPosition();
    setState(() {
    circles.add(
        Circle(
        circleId: CircleId("circle"),
        //center: _createCenter(),
        center: LatLng(currentLocation.latitude,currentLocation.longitude),
        radius: radius.value*1000,
        //radius: radius3,
        fillColor: Colors.blueAccent.withOpacity(0.1),
        strokeWidth: 1,
        strokeColor: Colors.blueAccent,
    ));
    });
  }


  showRadiusSlider(){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
          height: 160.0,
          width: double.infinity,
          padding: EdgeInsets.only(left: 10.0,right: 10.0),

            child: Column(
              children: <Widget>[
                Container(
                  //padding: EdgeInsets.only(left: 40.0),
                  height: 45.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white
                  ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Set Radius (KM)',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 22.0, top: 16.0),
                        /*suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: searchAndNavigate,
                        )*/),
                      /*onChanged: (val) {
                    setState(() {
                      filterDist = val;
                    });
                  },*/
                    ),

                ),

                Slider(
                      value: _value,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _label,
                      //onChanged: _updateQuery
                  onChanged: (double value) => changed(value),
                    ),
                    Text("Radius: " + radius.value.toString() + "km"),
                /*Slider(
                  value: (radii ?? 100.0).toDouble(),
                  onChanged: (val){setState(()=> radii = val.round());},
                  min: 100.0,
                  max: 500.0,
                  divisions: 4,
                  label: '$radii',
                ),*/


                RaisedButton(
                      color: Colors.blue,
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("Confirm", style: TextStyle(color: Colors.white)),
                    )
              ],
            ),
          );
    });
  }
  Firestore firestore = Firestore.instance;



  void _addMarker(lat, lng, data, docID, distance){
    MarkerId id = MarkerId(docID);
    //CircleId circleId = CircleId(docID);
    Marker marker = Marker(
      markerId: id,
      position: LatLng(lat,lng),
      infoWindow: InfoWindow(title: data['resultAddress'], snippet: '$distance' + ' km away'),
        onTap: (){
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0)
                  )
              ),
              context: context,
              builder: (builder){
                return StreamBuilder(
                  stream: firestore.collection('locations').document(docID).snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return Wrapper();
                    }
                    return new Container(
                      height: 310.0,
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(20.0, 3, 30.0, 5.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: StreamBuilder(
                                stream: firestore.collection('users').where('uid', isEqualTo: snapshot.data['id']).snapshots(),
                                builder: (context,snapshot){
                                  if (!snapshot.hasData){
                                    return Wrapper();
                                  }
                                  final List<DocumentSnapshot> document = snapshot.data.documents;
                                  return ListView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: document.length,
                                      itemBuilder:(context, index){
                                        /*return Card(
                                        child: ListTile(
                                          title: Text(document[index].data['userName']),
                                        ),
                                      );*/
                                        return Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(bottom: 10.0, top: 15.0),
                                              alignment: Alignment.centerLeft,
                                              child: Text("Tutor Details", style: TextStyle(fontFamily: "Poppins", fontSize: 20.0)),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  margin: EdgeInsets.only(bottom: 10.0, left: 15.0),
                                                  width: 75.0,
                                                  height: 75.0,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey,
                                                    image: DecorationImage(
                                                      //image: AssetImage('assets/images/tod_logo.PNG')
                                                        image: NetworkImage(document[index].data['imageURL'])
                                                      //image: NetworkImage(userNotifier.userList)
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  width: 200.0,
                                                  //height: 140.0,
                                                  margin: EdgeInsets.only(left: 20.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(document[index].data['email'], style: TextStyle(fontFamily: "Poppins", fontSize: 16.0),),
                                                      ),
                                                      SizedBox(height: 5.0,),
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(document[index].data['phoneNum'], style: TextStyle(fontFamily: "Poppins", fontSize: 16.0),),
                                                      ),
                                                      SizedBox(height: 5.0,),
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(document[index].data['gender'], style: TextStyle(fontFamily: "Poppins", fontSize: 16.0),),
                                                      ),
                                                      SizedBox(height: 5.0,),
                                                      Container(
                                                        //padding: EdgeInsets.only(top: 13, bottom: 5, left: 23, right: 28),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                Text('Call', style: TextStyle(fontSize: 16, fontFamily: "Poppins")),
                                                                SizedBox(height: 1),
                                                                Text(document[index].data['phoneNum'], style: TextStyle(fontSize: 13)),
                                                              ],
                                                            ),
                                                            RaisedButton(
                                                                onPressed: (){
                                                                  print('object');
                                                                  launch('tel://${document[index].data['phoneNum']}');
                                                                },
                                                                child: Icon(Icons.phone_in_talk, size: 20, color: Colors.black87.withOpacity(0.7))),
                                                          ],
                                                        ) ,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      }
                                  );
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: Text("Address", style: TextStyle(fontFamily: "Poppins", fontSize: 20.0)),
                            ),
                            Container(
                              child: Text(snapshot.data['resultAddress'], style: TextStyle(fontSize: 14.0, fontFamily: "Poppins"),),
                            ),
                            //distanceGet(docID, distance)
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
          );}
    );
    setState(() {
      markers[id]= marker;

    });
  }
  
  distanceGet(docID,distance){
    return StreamBuilder(
      stream: firestore.collection('locations').document(docID).snapshots(),
            builder: (context, snapshot){
          if(!snapshot.hasData){
            return Wrapper();
          }
          return Text('$distance');
      }
    );
  }

   _getDistance(List<DocumentSnapshot> documentList){
      documentList.forEach((DocumentSnapshot document){
      GeoPoint point = document.data['position']['geopoint'];
      //double distance = document.data['distance'];
      Geolocator().distanceBetween(initialPosition.latitude, initialPosition.longitude, document.data['LatLng'].latitude,
          document.data['LatLng'].longitude).then((calcDist){
        double distance = calcDist/1000;
        distanceGet(document.documentID,distance.toStringAsFixed(1));
      });
    });
  }
        

  void _updateMarker(List<DocumentSnapshot> documentList){
    documentList.forEach((DocumentSnapshot document){
      GeoPoint point = document.data['position']['geopoint'];
      //double distance = document.data['distance'];
      Geolocator().distanceBetween(initialPosition.latitude, initialPosition.longitude, document.data['LatLng'].latitude,
          document.data['LatLng'].longitude).then((calcDist){
        double distance = calcDist/1000;
        _addMarker(point.latitude, point.longitude, document.data,document.documentID, distance.toStringAsFixed(1));
      });

    });
  }
  double _value = 1.0;
  String _label = '';

  changed(value){

    final zoomMap = {
      1.0: 14.5,
      2.0: 13.7,
      3.0: 13.2,
      4.0: 12.7,
      5.0: 12.2,
      6.0: 12.0,
      7.0: 11.8,
      8.0: 11.6,
      9.0: 11.4,
      10.0: 11.2,
    };

    final zoom = zoomMap[value];
    mapController.moveCamera(CameraUpdate.zoomTo(zoom));


    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} km';
      markers.clear();
      circles.clear();
    });
    _setCircles(mapController);
    radius.add(value);
  }



  @override
  void dispose() {
    // TODO: implement dispose
    radius.close();
    super.dispose();
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

}