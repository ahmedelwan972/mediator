class ShowAnnouncementModel
{
  String? name;
  String? phone;
  String? image;
  String? title;
  String? des;
  String? type;
  String? category;
  String? address;
  bool? isSpacial;
  String? price;
  double? lat;
  double? long;
  String? uId;
  String? productId;
  DateTime? createdAt;


  ShowAnnouncementModel.fromJson(Map<String,dynamic>json){
    name=json['email'];
    phone=json['phone'];
    image=json['image'];
    title=json['title'];
    des=json['des'];
    type=json['type'];
    category=json['category'];
    address=json['address'];
    isSpacial=json['isSpacial'];
    price=json['price'];
    lat=json['lat'];
    long=json['long'];
    uId=json['uId'];
    productId=json['productId'];
    createdAt=json['createdAt'].toDate();
  }


}