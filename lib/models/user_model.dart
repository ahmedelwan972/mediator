class UserModel{
  String? name;
  String? email;
  String? phone;

  UserModel({
    this.phone,
    this.email,
    this.name,
});

  UserModel.fromJson(Map <String,dynamic>json){
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map <String,dynamic>toMap(){
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}