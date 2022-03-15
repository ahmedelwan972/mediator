import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';

class EditUserDataScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var oldPassController = TextEditingController();
  var newPassController = TextEditingController();
  var newPass2Controller = TextEditingController();

  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedCubit,MedStates>(
      listener: (context,state){
        var cubit = MedCubit.get(context);
        if(state is GetUserDataSuccessState){
            showToast(msg: 'تم تعديل البيانات بنجاح');
            Navigator.pop(context);
        }
        if(state is UpdatePasswordSuccessState){

            showToast(msg: 'تم تعديل كلمة المرور بنجاح');
            Navigator.pop(context);
        }
      },
      builder: (context,state){
        var cubit = MedCubit.get(context);
        return  DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: defaultColor,
              centerTitle: true,
              title: Text('تعديل بيانات الحساب'),
              bottom: TabBar(
                labelColor: Colors.white,
                onTap: (value){
                  cubit.isSearchCompanyEmit();
                },
                indicatorColor: Colors.red[900],
                tabs:
                [
                  Tab(
                    text: 'تعديل البيانات الشخصية',
                  ),
                  Tab(
                    text: 'تعديل كلمة المرور',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ConditionalBuilder(
                  condition: cubit.userModel != null&& state is! GetUserDataLoadingState,
                  builder: (context) {
                    nameController.text = cubit.userModel!.name!;
                    emailController.text = cubit.userModel!.email!;
                    phoneController.text = cubit.userModel!.phone!;
                    return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            defaultFormField(
                                controller: nameController,
                                label:'اسم المستخدم',
                                type: TextInputType.text,
                                suffix: Icons.person,
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'اسم المستخدم فارغ';
                                  }
                                }
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            defaultFormField(
                              controller: emailController,
                              label: 'البريد الالكتروني',
                              suffix: Icons.email,
                              type: TextInputType.emailAddress,
                              validator: (value){
                                if(value.isEmpty){
                                  return 'البريد الالكتروني غير مدخل' ;
                                }else if(!value.contains('@')&& !value.contains('.')){
                                  return 'البريد الالكتروني مدخل بشكل غير صحيح' ;

                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            defaultFormField(
                                controller: phoneController,
                                label: 'رقم الجوال',
                                suffix: Icons.phone_android,
                                type: TextInputType.phone,
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'رقم الجوال فارغ';
                                  }
                                }
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            state is! GetUserDataLoadingState ?
                            defaultButton(
                              function: (){
                                if(formKey.currentState!.validate()){
                                  cubit.editUser(
                                    name:nameController.text ,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              text: 'حفظ',
                            ): Center(child: CircularProgressIndicator()),
                          ],
                        ),
                      ),
                    ),
                  );
                  },
                  fallback: (context) => Center(child: CircularProgressIndicator()),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey2,
                      child: Column(
                        children: [
                          defaultFormField(
                            controller: oldPassController,
                            label: 'كلمة المرور القديمة',
                            type: TextInputType.visiblePassword,
                            isPassword: cubit.isPasswordEd,
                            suffix: cubit.isPasswordEd? Icons.visibility : Icons.visibility_off,
                            suffixPressed: ()
                            {
                              cubit.changeVisiEd();
                            },
                            validator: (value){
                              if(value.isEmpty){
                                return 'كلمة المرور غير مدخلة' ;
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                            controller: newPassController,
                            label: 'كلمة المرور الجديدة',
                            type: TextInputType.visiblePassword,
                            isPassword: cubit.isPasswordEd2,
                            suffix: cubit.isPasswordEd2? Icons.visibility : Icons.visibility_off,
                            suffixPressed: ()
                            {
                              cubit.changeVisiEd2();
                            },
                            validator: (value){
                              if(value.isEmpty){
                                return 'كلمة المرور غير مدخلة' ;
                              }else if (value.length <8){
                                return 'كلمة السر ضعيفة' ;
                              }else if(value != newPass2Controller.text){
                                return 'كلمة السر غير متطابقة' ;
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                            controller: newPass2Controller,
                            label: 'تاكيد كلمة المرور الجديدة ',
                            type: TextInputType.visiblePassword,
                            isPassword: cubit.isPasswordEd3,
                            suffix: cubit.isPasswordEd3? Icons.visibility : Icons.visibility_off,
                            suffixPressed: ()
                            {
                              cubit.changeVisiEd3();
                            },
                            validator: (value){
                              if(value.isEmpty){
                                return 'كلمة المرور غير مدخلة' ;
                              }else if (value.length <8){
                                return 'كلمة السر ضعيفة' ;
                              }else if(value != newPassController.text){
                                return 'كلمة السر غير متطابقة' ;
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          state is! UpdatePasswordLoadingState?
                          defaultButton(
                            function: (){
                              if(formKey2.currentState!.validate()){
                                cubit.editPassword(
                                  password: newPassController.text,
                                );
                              }
                            },
                            text: 'حفظ',
                          ) : Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
