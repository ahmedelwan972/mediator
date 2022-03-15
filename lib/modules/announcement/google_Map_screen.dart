import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediator/layout/cubit/cubit.dart';
import 'package:mediator/layout/cubit/states.dart';
import 'package:mediator/shared/components/components.dart';

import '../../shared/location_helper/geolocator.dart';

class GoogleMapScreen extends StatelessWidget {

  Completer<GoogleMapController> googleController = Completer();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedCubit,MedStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = MedCubit.get(context);
        CameraPosition initialCameraPosition =CameraPosition(
          zoom: 14.4746,
          target: LatLng(
              cubit.position!.latitude,cubit.position!.longitude
          ),
        );
        return Scaffold(
          appBar: appBar(text: 'GoogleMap'),
          body: GoogleMap(
            zoomControlsEnabled:false,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (controllerC)=> googleController.complete(controllerC),
            onCameraMove: (value){
              cubit.currentLocation = value.target;
              cubit.justEmitState();
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              showToast(msg: 'يتم الفحص');
              cubit.getCurrentLocation().then((value) {
                animateCamera(context);
              });
            },
            child: Icon(
              Icons.my_location
            ),
          ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(8.0),
              height: 105,
              color: Colors.black.withOpacity(0.1),
              alignment: AlignmentDirectional.center,
              child: Column(
                children: [
                    Text(
                        '${cubit.city} , ${cubit.myAddressName}'
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  defaultButton(function: (){
                    Navigator.pop(context);
                    cubit.getAddress();
                    showToast(msg: 'تم تحديد الموقع');
                  }, text: 'اختر الموقع الحالي' ,),
                ],
              ),
            ),
        );

      },
    );

  }

  animateCamera(context)async{
    final GoogleMapController controller = await googleController.future;
    CameraPosition cameraPosition = CameraPosition(
        target:LatLng(
            MedCubit.get(context).position!.latitude,MedCubit.get(context).position!.longitude,
        ),
      zoom: 14.4746
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}
