import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediator/layout/cubit/cubit.dart';
import 'package:mediator/layout/cubit/states.dart';
import 'package:mediator/shared/components/components.dart';


class GoogleMapForShowScreen extends StatelessWidget {
  Completer<GoogleMapController> googleController = Completer();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedCubit, MedStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MedCubit.get(context);
        CameraPosition initialCameraPosition = CameraPosition(
          zoom: 11.4746,
          target: LatLng(
              cubit.showAnnouncementModel!.lat!,
              cubit.showAnnouncementModel!.long!),
        );
        return Scaffold(
          appBar: AppBar(
            title: Text('GoogleMap'),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
                cubit.currentLocation = null;
                cubit.origin = null;
                cubit.destination = null;
                cubit.myAddressNameForMap = '';
                cubit.cityForMap = '';
              },
            icon: Icon(Icons.arrow_back),),
            actions: [
              if(cubit.origin != null)
                TextButton(
                onPressed: () async {
                  final GoogleMapController controller =
                      await googleController.future;
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: cubit.origin!.position,
                          zoom: 14.5,
                          tilt: 50.0),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  primary: Colors.greenAccent,
                  textStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 18)
                ),
                child: Text('Origin'),
              ),
              if(cubit.destination != null)
                TextButton(
                onPressed: () async {
                  final GoogleMapController controller =
                  await googleController.future;
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: cubit.destination!.position,
                          zoom: 14.5,
                          tilt: 50.0),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                    primary: Colors.redAccent,
                    textStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 18)
                ),
                child: Text('Dest'),
              ),
            ],
          ),
          body: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              GoogleMap(
                markers: {
                  if (cubit.origin != null) cubit.origin!,
                  if (cubit.destination != null) cubit.destination!,
                },
                onLongPress: cubit.addMarker,
                zoomControlsEnabled: false,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (controllerC) => googleController.complete(controllerC),
                onCameraMove: (value) async {
                  cubit.currentLocation = value.target;
                  cubit.getName();
                  cubit.distanceBetweenMove(
                    startLatitude: cubit.currentLocation!.latitude,
                    startLongitude: cubit.currentLocation!.longitude,
                    endLatitude: cubit.showAnnouncementModel!.lat!,
                    endLongitude: cubit.showAnnouncementModel!.long!,
                  );
                },
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (cubit.cityForMap.isNotEmpty && cubit.myAddressNameForMap.isNotEmpty)
                      Container(
                        color: Colors.white.withOpacity(0.8),
                        child: Text('${cubit.cityForMap} , ${cubit.myAddressNameForMap}'),
                      ),
                    if (cubit.cityForMap.isEmpty && cubit.myAddressNameForMap.isEmpty)
                      Container(
                        color: Colors.white.withOpacity(0.8),
                        child: Text('${cubit.city} , ${cubit.myAddressName}'),
                      ),
                    if (cubit.cityForMap.isNotEmpty && cubit.myAddressNameForMap.isNotEmpty)
                      SizedBox(
                        height: 10,
                      ),
                    defaultButton(
                      width: 200,
                      function: () {},
                      text: 'المسافه    ${cubit.distanceInMeters}    متر',
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showToast(msg: 'يتم الفحص');
              cubit.getCurrentLocation().then((value) {
                animateCamera(context);
              });
            },
            child: Icon(Icons.my_location),
          ),
        );
      },
    );
  }


  animateCamera(context) async {
    final GoogleMapController controller = await googleController.future;
    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(
          MedCubit.get(context).position!.latitude,
          MedCubit.get(context).position!.longitude,
        ),
        zoom: 14.4746);
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}
