import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediator/layout/cubit/cubit.dart';
import 'package:mediator/layout/cubit/states.dart';
import 'package:mediator/shared/components/components.dart';

import '../../shared/styles/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedCubit,MedStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = MedCubit.get(context);
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Image(
                    image: AssetImage(
                        'assets/images/home_bg@2x.png'
                    ),
                    height:140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: double.infinity,
                    height: 140,
                    color: Colors.black12.withOpacity(0.3),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(7))
                      ),
                      width: double.infinity,
                      height: 80,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7),),
                        color: Colors.white,
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      width: double.infinity,
                      height: 40,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){
                            },
                            child: Container (
                              alignment: AlignmentDirectional.center,
                              width: 120,
                              height: 40,
                              color: defaultColor,
                              child: Text(
                                'البحث المتقدم',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: cubit.searchController,
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              onChanged: (value){
                                if(value.isNotEmpty){
                                  cubit.fastSearch(value);
                                }
                                if(value.isEmpty)
                                  cubit.searchController.text = '';
                                cubit.justEmitState();
                              },
                              decoration: InputDecoration(
                                hintText: '       بحث',
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.search,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              if(cubit.searchController.text.isEmpty)
                ConditionalBuilder(
                condition:state is! GetAnnouncementLoadingState,
                builder: (context) {
                  if(cubit.posts.isNotEmpty){
                  return ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context,index)=>buildListItems(cubit.posts[index],index,context),
                  separatorBuilder: (context,index)=> Divider(height: 10,),
                  itemCount: cubit.posts.length,
                );} else  {
                    return Center(child: Text('لا يوجد عقارات'));
                  }
                },
                fallback:(context)=> Center(child: CircularProgressIndicator()),
              ),
              if(cubit.searchController.text.isNotEmpty)
                ConditionalBuilder(
                  condition:state is! SearchLoadingState,
                  builder: (context) {
                    if(cubit.search.isNotEmpty){
                      return ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context,index)=>buildListItems(cubit.search[index],index,context),
                        separatorBuilder: (context,index)=> Divider(height: 10,),
                        itemCount: cubit.search.length,
                      );} else  {
                      return Center(child: Text('لا يوجد نتايج بحث'));
                    }
                  },
                  fallback:(context)=> Center(child: CircularProgressIndicator()),
                ),

            ],
          ),
        );
      },
    );
  }
}
