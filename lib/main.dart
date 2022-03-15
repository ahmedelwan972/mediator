import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediator/layout/MedLayout_screen.dart';
import 'package:mediator/layout/cubit/cubit.dart';
import 'package:mediator/modules/announcement/show_announcemnet_screen.dart';
import 'package:mediator/modules/auth/cubit/cubit.dart';
import 'package:mediator/modules/auth/cubit/states.dart';
import 'package:mediator/shared/bloc_observer.dart';
import 'package:mediator/shared/components/components.dart';
import 'package:mediator/shared/components/constants.dart';
import 'package:mediator/shared/network/local/cache_helper.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');
  BlocOverrides.runZoned(
        () {
      runApp(MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(context) =>  AuthCubit()),
        BlocProvider(create:(context) =>  MedCubit()..checkInterNet()..getUserData()..getAnnouncement()),
      ],
      child: BlocConsumer<AuthCubit,AuthStates>(
        listener: (context,state){
          if(state is LoginSuccessState||state is UserDataSuccessState)MedCubit.get(context).getUserData();
        },
        builder: (context,state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Colors.indigo,
              fontFamily: 'Cairo',
            ),
            home:MedLayout(),
          );
        }
      ),
    );
  }

}

