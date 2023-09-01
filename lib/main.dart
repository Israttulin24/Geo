import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
   final Completer <GoogleMapController> _controller = Completer();

    LocationData? currentLocation;
    void getCurrentLocation() async{
      Location location = Location();

      location.getLocation().then(
              (location) {
                currentLocation = location;
                setState(() {// to refresh state
                });
              },
      );

      GoogleMapController googleMapController = await _controller.future;
      location.onLocationChanged.listen(
              (newLocation) {
                currentLocation =newLocation;

                googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(
                          zoom: 17,
                            target: LatLng(
                              newLocation.latitude!,
                              newLocation.longitude!,
                            ),
                        )
                    )
                );

                setState(() {

                });
              }
      );

    }
   @override
   void initState(){
      getCurrentLocation();
      super.initState();
   }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Real-Time Location Tracker"),
      ),
      body: currentLocation == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          :
      GoogleMap(
          initialCameraPosition: CameraPosition(
            zoom: 17,
            tilt: 10,
            target: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
          ),


        onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);

        },

        markers: {
            const Marker(
              markerId:  MarkerId("New Location"),
              position: LatLng(24.837344, 85.395753),
              visible: true,
              infoWindow: InfoWindow(
                  title: 'New Location',
                  snippet: '24.837344, 85.395753'
              ),
            ),

          Marker(
            markerId: const MarkerId('Current Location'),
            position:LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            visible: true,
            draggable: true,
            infoWindow: InfoWindow(
                title: 'My Current Location',
                snippet: '${currentLocation?.latitude ?? ''}' '${currentLocation?.longitude ?? ''}'
            ),
          ),
        },

        polylines: <Polyline>{
            Polyline(polylineId: const PolylineId('polyline'),
            color: Colors.blue,
            width: 7,
            points: [
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              const LatLng(24.837344, 85.395753),
            ]
            ),
        },

      ),
    );
  }



}











