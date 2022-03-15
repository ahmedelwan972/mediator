import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediator/layout/cubit/cubit.dart';
import 'package:mediator/layout/cubit/states.dart';
import 'package:mediator/shared/components/components.dart';


import '../shared/components/constants.dart';

class MedLayout extends StatelessWidget {
  const MedLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedCubit,MedStates>(
      listener: (context, state){
        if(result != null)checkNet(context);
      },
      builder: (context, state){
        var cubit = MedCubit.get(context);
        return Scaffold(
          appBar: appBar(text: cubit.titles[cubit.currentIndex]),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeIndex(index);
              if(cubit.currentIndex == 0) {
                cubit.getAnnouncement();
              }else{
                cubit.searchController.text = '';
              }
            },
            backgroundColor: Colors.white,
            elevation: 0,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home),label: 'الريسية'),
              BottomNavigationBarItem(icon: Icon(Icons.add_box_rounded),label: 'اضافة  اعلان'),
              BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'الاعدادات'),
            ],
          ),
        );
      },
    );
  }
}
