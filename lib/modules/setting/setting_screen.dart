import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediator/layout/cubit/cubit.dart';
import 'package:mediator/layout/cubit/states.dart';
import 'package:mediator/modules/auth/login_screen.dart';
import 'package:mediator/modules/auth/register_screen.dart';
import 'package:mediator/shared/components/components.dart';

import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../announcement/fav_announcemnet_screen.dart';
import '../announcement/my_announcement.dart';
import '../auth/edit_user_data_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedCubit,MedStates>(
      listener: (context,state){},
      builder : (context,state){
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              uId != null
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: Image(
                        image: AssetImage('assets/images/profile_bg@2x.png'),
                        height: 300,
                        width: 200,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        MedCubit.get(context).getAnnouncement();
                        navigateTo(context, MyAnnouncementScreen());
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                          ),
                          Spacer(),
                          Text(
                            'قائمة اعلاناتي',
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.check_circle,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        MedCubit.get(context).widget = FavAnnouncementScreen();
                        MedCubit.get(context).getFav();
                        navigateTo(context, FavAnnouncementScreen());
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                          ),
                          Spacer(),
                          Text(
                            'الاعلانات المفضلة ',
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.favorite,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        navigateTo(context, EditUserDataScreen());
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                          ),
                          Spacer(),
                          Text(
                            'تعديل بيانات الحساب',
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.settings,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50.0,
                      child: MaterialButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        onPressed: () {
                          CacheHelper.removeData('uId');
                          uId = null;
                          MedCubit.get(context).justEmitState();
                        },
                      ),
                      decoration: BoxDecoration(
                        color: defaultColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              )
                  : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Image(
                      image: AssetImage('assets/images/profile_bg@2x.png'),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'لم تقم بتسجيل الدخول الي التطبيق حتى الان ، برجاء تسجيل الدخول حتى تتمكن من متابعه صفحتك الشخصية',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    defaultButton(
                      function: () {
                        navigateTo(context, LoginScreen());
                      },
                      text: 'تسجيل الدخول',
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: double.infinity,
                      height: 40,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: OutlinedButton(
                        onPressed: () {
                          navigateTo(context, SignUpScreen());
                        },
                        child: Text('انشاء حساب جديد'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },

    );
  }
}
