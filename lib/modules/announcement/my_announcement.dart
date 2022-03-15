import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediator/layout/cubit/cubit.dart';
import 'package:mediator/layout/cubit/states.dart';
import 'package:mediator/shared/components/components.dart';

class MyAnnouncementScreen extends StatelessWidget {
  const MyAnnouncementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedCubit,MedStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = MedCubit.get(context);
        return Scaffold(
          appBar: appBar(text: 'اعلاناتي'),
          body: ConditionalBuilder(
            builder: (context) {
              if(cubit.myPosts.isNotEmpty){
             return ListView.separated(
              itemBuilder: (context,index)=>buildListItems(cubit.myPosts[index],index,context,edit: true),
              separatorBuilder: (context,index)=> Divider(height: 10,),
              itemCount: cubit.myPosts.length,
            );}else{
                return Center(child: Text('لا يوجد عقارات لديك'));
              }},
            condition:state is! GetAnnouncementLoadingState&&state is! UpdateImageLoadingState,
            fallback: (context) => Center(child: CircularProgressIndicator(),),
          ),
        );
      },
    );
  }
}
