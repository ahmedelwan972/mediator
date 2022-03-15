class AnnouncementModel
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
  bool? isFav;
  DateTime? createdAt;



  AnnouncementModel.fromJson(Map<String,dynamic>json){
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
    isFav=json['isFav'];
    createdAt=json['createdAt'].toDate();

  }
  AnnouncementModel({
    this.name,
    this.phone,
    this.image,
    this.title,
    this.address,
    this.category,
    this.des,
    this.isSpacial,
    this.lat,
    this.long,
    this.price,
    this.type,
    this.uId,
    this.isFav,
    this.productId,
    this.createdAt,

});
  Map<String,dynamic>toMap(){
    return{
      'image' : image,
      'title' : title,
      'address' : address,
      'category' : category,
      'des' : des,
      'isSpacial' : isSpacial,
      'lat' : lat,
      'long' : long,
      'price' : price,
      'type' : type,
      'email' : name,
      'phone' : phone,
      'uId' : uId,
      'isFav' : isFav,
      'createdAt' : createdAt,

    };
  }
}