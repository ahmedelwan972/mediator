import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediator/layout/cubit/cubit.dart';
import 'package:mediator/modules/auth/cubit/cubit.dart';
import 'package:mediator/modules/auth/cubit/states.dart';
import 'package:mediator/modules/auth/register_screen.dart';
import 'package:mediator/shared/components/components.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthStates>(
      listener: (context,state){
        if(state is LoginSuccessState){
            Navigator.pop(context);
            AuthCubit.get(context).emitS();
        }
        if(state is LoginErrorState){
          showToast(msg: 'المبينات المدخلة خطآ',toastState: true);
        }
      },
      builder: (context,state){
        return Scaffold(
          appBar: appBar(text: 'تسجيل الدخول'),
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
                            'assets/images/signin_bg@2x.png'
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'سجل دخول الان لتري جميع العروض',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          controller: emailController,
                          label: 'البريد الالكتروني',
                          type: TextInputType.emailAddress,
                          suffix: Icons.email,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'ادخل البريد الالكتروني';
                            } else if (!value.contains('@') && !value.contains('.')) {
                              return 'البريد الالكتروني مدخل بشكل غير صحيح';
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                          controller: passwordController,
                          label: 'كلمة السر',
                          type: TextInputType.visiblePassword,
                          suffix: AuthCubit.get(context).isPassword ? Icons.visibility : Icons.visibility_off,
                          isPassword: AuthCubit.get(context).isPassword,
                          suffixPressed: (){
                            AuthCubit.get(context).changeIsPassword();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'ادخل كلمة السر';
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      state is! LoginLoadingState?
                      defaultButton(
                        function: () {
                          if(formKey.currentState!.validate()){
                            AuthCubit.get(context).login(
                              password: passwordController.text,
                              email: emailController.text,
                            );
                          }
                        },
                        text: 'تسجيل الدخول',
                      ): Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              navigateTo(context, SignUpScreen());
                            },
                            child: Text('سجل حساب الان  '),
                          ),
                          Text('لا يوجد لديك حساب؟'),
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
