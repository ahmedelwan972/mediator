abstract class AuthStates {}

class InitState extends AuthStates{}

class ChangeVisibilityState extends AuthStates{}

class RegisterLoadingState extends AuthStates{}

class RegisterErrorState extends AuthStates{
  String e;
  RegisterErrorState(this.e);
}

class UserDataSuccessState extends AuthStates{}

class UserDataErrorState extends AuthStates{}

class LoginLoadingState extends AuthStates{}

class LoginSuccessState extends AuthStates{}

class LoginErrorState extends AuthStates{
  String e;
  LoginErrorState(this.e);
}