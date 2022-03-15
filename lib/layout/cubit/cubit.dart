import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mediator/layout/cubit/states.dart';
import 'package:mediator/models/add_model.dart';
import 'package:mediator/models/user_model.dart';
import 'package:mediator/modules/home/home_screen.dart';
import 'package:mediator/modules/setting/setting_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/get_comment_model.dart';
import '../../models/show_model.dart';
import '../../modules/announcement/add_screen.dart';
import '../../shared/components/constants.dart';
import '../../shared/location_helper/geolocator.dart';

class MedCubit extends Cubit<MedStates> {
  MedCubit() : super(InitState());
  static MedCubit get(context) => BlocProvider.of(context);

  justEmitState() {
    emit(JustEmitState());
  }

  int currentIndex = 0;

  var searchController = TextEditingController();

  changeIndex(int index) {
    currentIndex = index;
    emit(ChangeIndexState());
  }

  List<String> titles = [
    'الرئسية',
    'اضافة اعلان',
    'الاعدادات',
  ];

  List<Widget> screens = [
    HomeScreen(),
    AddAnnouncementScreen(),
    SettingScreen(),
  ];
  bool isSearch  =  false;
  isSearchCompanyEmit() {
    isSearch = !isSearch;
    emit(ChangeCheckState());
  }


  checkInterNet()async{
    InternetConnectionChecker().onStatusChange.listen((event) {
      final state = event == InternetConnectionStatus.connected;
      result = state;
      print(result);
      emit(CheckNetState());
    });
  }


  UserModel? userModel;
  getUserData() async {
   if( uId !=  null){
     emit(GetUserDataLoadingState());
     await FirebaseFirestore.instance
         .collection('users')
         .doc(uId)
         .get()
         .then((value) async{
       userModel = UserModel.fromJson(value.data()!);
       await  FirebaseFirestore.instance.collection('Fav').get().then((value) {
         if(value.docs.any((element) => element.id ==uId)){
           FirebaseFirestore.instance
               .collection('Fav')
               .doc(uId)
               .get()
               .then((value) {
             FirebaseFirestore.instance
                 .collection('announcement')
                 .get()
                 .then((value2) {
               value2.docs.forEach((element) {
                 favorites.addAll({element.id : value.data()![element.id]});
                 value.reference.update({
                   element.id: favorites[element.id]! ? true : false,
                 });
                 emit(GetUserDataSuccessState());
               });
             });
           });
         }
         else{
           FirebaseFirestore.instance
               .collection('Fav')
               .doc(uId)
               .set({
             'empty': 'null',
           }).then((value) {
             getUserData();
           });
         }
       });
       emit(GetUserDataSuccessState());
     }).catchError((e) {
       emit(GetUserDataErrorState());
     });
   }
  }
  bool isPasswordEd = true;
  void changeVisiEd (){
    isPasswordEd = !isPasswordEd;
    emit(ChangeVisiEdState());
  }
  bool isPasswordEd2 = true;
  void changeVisiEd2 (){
    isPasswordEd2 = !isPasswordEd2;
    emit(ChangeVisiEd2State());
  }
  bool isPasswordEd3 = true;
  void changeVisiEd3 () {
    isPasswordEd3 = !isPasswordEd3;
    emit(ChangeVisiEd3State());
  }
  editUser({
    String? name,
    String? email,
    String? phone,
  }){
    FirebaseFirestore.instance
    .collection('users')
    .doc(uId)
    .update({
      'name':name??userModel!.name,
      'phone':phone??userModel!.phone,
      'email':email??userModel!.email!
    })
    .then((value) => getUserData(),);
  }

  editPassword({required String password}){
    emit(UpdatePasswordLoadingState());
    FirebaseAuth.instance.currentUser!
        .updatePassword(password)
        .then((value) => emit(UpdatePasswordSuccessState()));
  }

  ////////////////////////////////////////ADD ANNOUNCEMENTS/////////////////////////////
  File? image;
  var picker = ImagePicker();

  Future<void> selectImages() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
      emit(PickImageSuccessState());
    } else {
      print('no image selected');
    }
  }

  bool isSpacial = false;

  void changeIsSpecial() {
    isSpacial = !isSpacial;
    emit(ChangeSpecialState());
  }

  Future<void> addAnnouncements({
    required String title,
    required String des,
    required String type,
    required String category,
    required String price,
  }) async {
    emit(UpdateImageLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(image!.path).pathSegments.last}')
        .putFile(image!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        addAnnouncement(
          title: title,
          price: price,
          image: value,
          des: des,
          category: category,
          type: type,
        );
      }).catchError((e) {
        print(e.toString());
        emit(UpdateImageErrorState());
      });
    }).catchError((e) {
      print(e.toString());
      emit(UpdateImageErrorState());
    });
  }

  void addAnnouncement({
    required String title,
    required String type,
    required String category,
    required String des,
    required String price,
    required String image,
  }) async {
    AnnouncementModel model = AnnouncementModel(
      name: userModel!.name,
      phone: userModel!.phone,
      type: type,
      category: category,
      des: des,
      image: image,
      isSpacial: isSpacial,
      lat: position!.latitude,
      long: position!.longitude,
      price: price,
      title: title,
      uId: uId,
      address: myAddressName,
      isFav: false,
      createdAt: DateTime.now(),
    );
    await FirebaseFirestore.instance
        .collection('announcement')
        .add(model.toMap())
        .then((value1) {
      value1.update({'productId': value1.id});
      FirebaseFirestore.instance
      .collection('Fav')
      .get()
      .then((value) {
        value.docs.forEach((element) {
          element.reference.update({
            value1.id: false,
          });
        });
      });
      getAnnouncement();
    }).catchError((e) {
      emit(AddAnnouncementSuccessState());
    });
  }
/////////////////////////////////////////////GOOGLEMAP/////////////////////////////
  Position? position;
  LatLng? currentLocation;
  Future<void> getCurrentLocation() async {
    emit(GetCurrentLocationLoadingState());
    await LocationHelper.getCurrentLocation();
    position = await Geolocator.getLastKnownPosition().whenComplete(() {
      emit(GetCurrentLocationState());
    });
  }
  int? distanceInMeters;
  distanceBetween({
  required double endLatitude,
  required double endLongitude,
})async{
     distanceInMeters= await Geolocator.distanceBetween(
      position!.latitude,
      position!.longitude,
      endLatitude,
      endLongitude,
    ).toInt();
    emit(GetDistanceBetweenState());
  }

  distanceBetweenMove({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  })async{
    distanceInMeters= await Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    ).toInt();
    emit(GetDistanceBetweenState());
  }

  String myAddressName = '';
  String city = '';
  String myAddressNameForMap = '';
  String cityForMap = '';

  Future<void> getName() async {
    if(currentLocation != null){
      List<Placemark> place =
      await placemarkFromCoordinates(currentLocation!.latitude, currentLocation!.longitude);
      Placemark placeMark = place[0];
      myAddressNameForMap = placeMark.locality!;
      cityForMap = placeMark.country!;
      emit(GetCurrentLocationState());
    }
  }

  Future<void> getAddress() async {
    if(position != null){
    List<Placemark> place =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    Placemark placeMark = place[0];
    myAddressName = placeMark.locality!;
    city = placeMark.country!;
    emit(GetCurrentLocationState());
    }
  }

  Marker? origin;
  Marker? destination;
  addMarker(LatLng pos){
    if(origin == null || (origin != null && destination != null)){
      origin =Marker(
        markerId: MarkerId('origin'),
        infoWindow: InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      );
      destination = null;
      emit(AddMarkerState());
    }else{
      destination =Marker(
        markerId: MarkerId('destination'),
        infoWindow: InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: pos,
      );
      emit(ChangeMarkerState());
    }
  }

  ////////////////////////////////////////////////////GETANNOUNCEMENTS////////////////////////////////////
  List<AnnouncementModel> posts = [];
  List<AnnouncementModel> myPosts = [];
  List<AnnouncementModel> search = [];
  Future<void> getAnnouncement() async {
    posts = [];
    myPosts = [];
    emit(GetAnnouncementLoadingState());
   await FirebaseFirestore.instance
       .collection("announcement")
       .get()
       .then((value) {
      value.docs.forEach((element) {
        if(!posts.contains(element.data()))
          posts.add(AnnouncementModel.fromJson(element.data()));
        print(posts[0].createdAt);
        if (element.data()['uId'] == uId&& !myPosts.contains(element.data())) {
          myPosts.add(AnnouncementModel.fromJson(element.data()));
        }
        emit(GetAnnouncementSuccessState());
      });
    }).catchError((e) {
      print(e.toString());
      emit(GetAnnouncementErrorState());
    });
  }


  void fastSearch(key)async{
    search =[];
    emit(SearchLoadingState());
    await FirebaseFirestore.instance
        .collection("announcement")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if(element.data()['des'].contains(key)
        ||element.data()['title'].contains(key) && !search.contains(element.data())){
          search.add(AnnouncementModel.fromJson(element.data()));
          emit(SearchSuccessState());
        }
        });
      }).catchError((e){
        print(e.toString());
        emit(SearchErrorState());
    });
  }
  Map<String, bool> favorites = {};
  List<AnnouncementModel> favAnnouncement = [];
  getFav()async{
    favAnnouncement=[];
    emit(GetFavLoadingState());
    await FirebaseFirestore.instance
        .collection('announcement')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            if(favorites[element.id]!){
              favAnnouncement.add(AnnouncementModel.fromJson(element.data()));
            }
            emit(GetFavSuccessState());
          });
    }).catchError((e){
      emit(GetFavErrorState());
    });
  }
  List<GetCommentModel> getCommentModel=[];
  List<GetReplayModel> getReplayModel=[];
  ShowAnnouncementModel? showAnnouncementModel;
  void showAnnouncement({required String postId}) async {
    getReplayModel=[];
    getCommentModel=[];
    emit(ShowAnnouncementLoadingState());
    await FirebaseFirestore.instance
        .collection('announcement')
        .doc(postId)
        .get()
        .then((value) {
      showAnnouncementModel = ShowAnnouncementModel.fromJson(value.data()!);
      if(value.reference.collection('comments').path.isNotEmpty) {
        getComments(announId: postId);
      }
      emit(ShowAnnouncementSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(ShowAnnouncementErrorState());
    });
  }



  Widget widget = SettingScreen();


  Future <void>   changeFav(String announId)async{
   await FirebaseFirestore.instance
        .collection('Fav')
        .doc(uId)
       .update({announId: favorites[announId]! ? false : true}).then((value) {
         print(widget.toString());
         if(widget.toString() == 'FavAnnouncementScreen'){
           favorites[announId] = !favorites[announId]!;
           getFav();
         }
         else {
           favorites[announId] = !favorites[announId]!;
           emit(ChangeFavSuccessState());
         }
   }).catchError((e){
     favorites[announId] = !favorites[announId]!;
     emit(ChangeFavErrorState());
   });
  }

  deleteAnnouncementImage(String announId){
    FirebaseFirestore.instance
        .collection('announcement')
        .doc(announId)
        .get()
        .then((value) {
      firebase_storage.FirebaseStorage.instance
              .refFromURL(value.data()!['image'])
              .delete().then((value2) {
                deleteAnnouncement(announId);
              });
    });
  }
  deleteAnnouncement(String announId)async{
    await FirebaseFirestore.instance
        .collection('announcement')
        .doc(announId)
        .delete().then((value) {
          getAnnouncement();
    });
  }
  Future<void> editAnnouncements({
    required String title,
    required String des,
    required String type,
    required String category,
    required String price,
    required String announId,
  }) async {
    emit(UpdateImageLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(image!.path).pathSegments.last}')
        .putFile(image!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        editAnnouncement(
          title: title,
          price: price,
          image: value,
          des: des,
          category: category,
          type: type,
          announId: announId,
        );
      }).catchError((e) {
        print(e.toString());
      });
    }).catchError((e) {
      print(e.toString());
    });
  }


  editAnnouncement({
    required String title,
    required String type,
    required String category,
    required String des,
    required String price,
    required String image,
    required String announId,
  }){
    AnnouncementModel model = AnnouncementModel(
      name: userModel!.name,
      phone: userModel!.phone,
      type: type,
      category: category,
      des: des,
      image: image,
      isSpacial: isSpacial,
      lat: position!.latitude,
      long: position!.longitude,
      price: price,
      title: title,
      uId: uId,
      address: myAddressName,
      isFav: false,
      productId: announId,
    );
    FirebaseFirestore.instance
        .collection('announcement')
        .doc(announId)
        .update(model.toMap()).then((value) {
          getAnnouncement();
    });
  }

  ///////////////////////////////////////////Comments//////////////////////////////

  Future<void>addComment({
    required String comment,
})async{
    emit(AddCommentLoadingState());
   await FirebaseFirestore.instance
        .collection('announcement')
        .doc(showAnnouncementModel!.productId!)
        .collection('comments')
        .add({'comment' : comment ,  'senderName':userModel!.name})
        .then((value) {
      value.update({'commentId': value.id});
      showAnnouncement(postId: showAnnouncementModel!.productId!);
    }).catchError((e){
      print(e.toString());
      emit(AddCommentErrorState());
    });
  }

  Future<void>addReplay({
    required String replay,
    required String commentId,
}) async{
    emit(AddReplayLoadingState());
   await FirebaseFirestore.instance
        .collection('announcement')
        .doc(showAnnouncementModel!.productId!)
        .collection('comments')
        .doc(commentId)
        .collection('replays')
        .add({'replay' : replay ,  'senderName':userModel!.name})
        .then((value) {
          value.update({'replayId': value.id});
          showAnnouncement(postId: showAnnouncementModel!.productId!);
    }).catchError((e){
      emit(AddReplayErrorState());
    });
  }

  Map<String ,bool> chooseComment = {};
  Map<String ,bool> replayComment = {};

  getComments({
    required String announId,
  })async{
    await FirebaseFirestore.instance
        .collection('announcement')
        .doc(announId)
        .collection('comments')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        getCommentModel.add(GetCommentModel.fromJson(element.data()));
        chooseComment.addAll({
          element.id: false,
        });
        if(element.reference.collection('replays').path.isNotEmpty){
          getReplays(announId: announId,commentId: element.id);
        }
        emit(GetCommentSuccessState());
      });
    }).catchError((e){
      print(e.toString());
      emit(GetCommentErrorState());
    });
  }

  getReplays({
    required String announId,
    required String commentId,
  }){
    FirebaseFirestore.instance
        .collection('announcement')
        .doc(announId)
        .collection('comments')
        .doc(commentId)
        .collection('replays')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        getReplayModel.add(GetReplayModel.fromJson(element.data()));
        replayComment.addAll({
          element.id: false,
        });
        emit(GetReplaySuccessState());
      });
    }).catchError((e){
      print(e.toString());
      emit(GetReplayErrorState());
    });
  }

  void choseComment({
    required String id,
  }){
    chooseComment[id] = !chooseComment[id]!;
    emit(ChooseCommentState());
  }

  void chooseReplay({
    required String id,
  }){
    replayComment[id] = !replayComment[id]!;
    emit(ReplayState());
  }
  
  void share (){
    Share.share('https://mediator.page.link/start');
    emit(ShareState());
  }

}
