import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediator/shared/components/components.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../setting/setting_screen.dart';

class FavAnnouncementScreen extends StatelessWidget {
  const FavAnnouncementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedCubit,MedStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = MedCubit.get(context);
        return Scaffold(
          appBar: appBar(text: 'الاعلانات المفضلة',
          leading: IconButton(onPressed: (){
            MedCubit.get(context).widget = SettingScreen();
            MedCubit.get(context).justEmitState();
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back))),
          body: ConditionalBuilder(
            condition:state is! GetFavLoadingState,
            builder: (context){
              if(cubit.favAnnouncement.isNotEmpty ){
             return ListView.separated(
              itemBuilder: (context,index)=>buildListItems(cubit.favAnnouncement[index],index,context),
              separatorBuilder: (context,index)=> Divider(height: 10,),
              itemCount: cubit.favAnnouncement.length,
            );}else{
                return Center(child: Text('لا يوجد عقارات مفضلة'));
              }
            },
            fallback:(context)=> Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
