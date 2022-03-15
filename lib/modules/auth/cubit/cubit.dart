import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediator/models/user_model.dart';
import 'package:mediator/modules/auth/cubit/states.dart';
import 'package:mediator/shared/components/constants.dart';
import 'package:mediator/shared/network/local/cache_helper.dart';

class AuthCubit extends Cubit<AuthStates>{
  AuthCubit () : super(InitState());
  static AuthCubit get (context) => BlocProvider.of(context);

  bool isPassword = true ;

  bool isPasswordS = true ;

  bool isPasswordSC = true ;

  void emitS(){
    emit(ChangeVisibilityState());
  }

  void changeIsPassword(){
    isPassword = !isPassword;
    emit(ChangeVisibilityState());
  }
  void changeIsPasswordS(){
    isPasswordS = !isPasswordS;
    emit(ChangeVisibilityState());
  }
  void changeIsPasswordSC(){
    isPasswordSC = !isPasswordSC;
    emit(ChangeVisibilityState());
  }

  void register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }){
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      uId = value.user!.uid;
      userData(
        phone: phone,
        name: name,
        email: email,
      );
    }).catchError((e){
      print(e.toString());
      emit(RegisterErrorState(e.toString()));
    });
  }

  userData({
    required String email,
    required String phone,
    required String name,
}){
    UserModel model = UserModel(
      email: email,
      name: name,
      phone: phone,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
          emit(UserDataSuccessState());
    }).catchError((e){
      print(e.toString());
      emit(UserDataErrorState());
    });
  }

  login({
    required String email,
    required String password,
}){
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      CacheHelper.saveData(key: 'uId', value: value.user!.uid);
      uId = value.user!.uid;
      print(value.user!.uid);
      emit(LoginSuccessState());
    }).catchError((e){
      emit(LoginErrorState(e.toString()));
    });
  }

}