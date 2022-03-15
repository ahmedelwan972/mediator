import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediator/layout/MedLayout_screen.dart';
import 'package:mediator/layout/cubit/cubit.dart';
import 'package:mediator/modules/auth/cubit/cubit.dart';
import 'package:mediator/modules/auth/cubit/states.dart';
import 'package:mediator/shared/components/components.dart';
import 'package:mediator/shared/components/constants.dart';

import '../../shared/network/local/cache_helper.dart';

class SignUpScreen extends StatelessWidget {
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var password2Controller = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthStates>(
      listener: (context,state){
        if(state is UserDataSuccessState){
          CacheHelper.saveData(key: 'uId', value: uId).then((value) {
            navigateAndFinish(context, MedLayout());
            MedCubit.get(context).getUserData();
          });
        }
        if(state is RegisterErrorState){
          showToast(msg:'المبينات المدخلة خطآ',toastState: true);
        }
      },
      builder: (context,state){
        return Scaffold(
          appBar: appBar(text: 'انشاة حساب',),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image:AssetImage(
                            'assets/images/signup_bg@2x.png'
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'انشا حساب الان لتري جميع العروض',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          controller: userNameController,
                          label: 'الاسم',
                          type: TextInputType.text,
                          suffix: Icons.person,
                          validator: (value) {
                            if (value.isEmpty) {
                              'ادخل الاسم';
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                          controller: emailController,
                          label: 'البريد الالكتروني',
                          type: TextInputType.emailAddress,
                          suffix: Icons.email,
                          validator: (value) {
                            if (value.isEmpty) {
                              'ادخل البريد الالكتروني';
                            } else if (!value.contains('@')) {
                              return 'البريد الالكتروني مدخل بشكل غير صحيح';
                            }else  if(!value.contains('.')){
                              return 'البريد الالكتروني مدخل بشكل غير صحيح';
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                          controller: phoneController,
                          label: 'رقم الهاتف',
                          type: TextInputType.phone,
                          suffix: Icons.phone_android,
                          validator: (value) {
                            if (value.isEmpty) {
                              'ادخل رقم الهاتف';
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: passwordController,
                        label: 'كلمة السر',
                        type: TextInputType.visiblePassword,
                        suffix: AuthCubit.get(context).isPasswordS ? Icons.visibility : Icons.visibility_off,
                        isPassword: AuthCubit.get(context).isPasswordS,
                        suffixPressed: (){
                          AuthCubit.get(context).changeIsPasswordS();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'ادخل كلمة السر';
                          } else if (value.length < 8) {
                            return ' كلمة السر ضعيفة';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: password2Controller,
                        label: 'تاكيد كلمة السر',
                        type: TextInputType.visiblePassword,
                        suffix: AuthCubit.get(context).isPasswordSC ? Icons.visibility : Icons.visibility_off,
                        isPassword: AuthCubit.get(context).isPasswordSC,
                        suffixPressed: (){
                          AuthCubit.get(context).changeIsPasswordSC();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'ادخل كلمة السر';
                          } else if (value.length < 8) {
                            return ' كلمة السر ضعيفة';
                          } else if (password2Controller.text !=
                              passwordController.text) {
                            return ' كلمة السر غير متطابقة';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      state is! RegisterLoadingState ?
                      defaultButton(
                        function: () {
                          if(formKey.currentState!.validate()){
                            AuthCubit.get(context).register(
                              email: emailController.text,
                              name: userNameController.text,
                              phone: phoneController.text,
                              password: passwordController.text,
                            );
                          }
                        },
                        text: 'انشاة حساب',
                      ): Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('رجوع'),
                          ),
                          Text('لديك حساب بالفعل؟'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
