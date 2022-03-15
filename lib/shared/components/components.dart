import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mediator/layout/cubit/cubit.dart';
import 'package:mediator/models/add_model.dart';
import 'package:mediator/modules/auth/login_screen.dart';
import 'package:intl/intl.dart' as date;
import '../../modules/announcement/edit_announcement_screen.dart';
import '../../modules/announcement/show_announcemnet_screen.dart';
import '../styles/colors.dart';
import 'constants.dart';

Widget defaultButton({
  double width = double.infinity,
  bool isUpperCase = true,
  double radius = 5.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          function();
        },
      ),
      decoration: BoxDecoration(
        color: defaultColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );

void navigateTo(context, widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (route) => false,
  );
}

Widget defaultFormField({
  String? text,
  required TextEditingController controller,
  bool isPassword = false,
  FormFieldValidator? validator,
  TextInputType? type,
  String? label,
  bool enabled = true,
  Function? suffixPressed,
  IconData? suffix,
  IconData? prefix,
}) =>
    TextFormField(
      obscureText: isPassword,
      enabled: enabled,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        isDense: true,
        hintText: text,
        labelText: label,
        prefix: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  {
                    if (suffixPressed != null) suffixPressed();
                  }
                },
                icon: Icon(suffix),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );

Future<bool?> showToast({required String msg, bool? toastState}) =>
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: toastState != null
            ? toastState
                ? Colors.yellow[900]
                : Colors.red
            : Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

Future<void> refresh(context) {
  return Future.delayed(
    Duration(seconds: 1),
  ).then((value) {
  }); //
}

Future<void> refresh2(context) {
  return Future.delayed(
    Duration(seconds: 1),
  ).then((value) {
  }); //
}

checkNet(context) {
  if (!result!) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No internet connection'),
        content: Container(
          height: 60,
          width: 80,
          color: defaultColor,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Click to retry',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

appBar({
  required String text,
  IconButton? leading,
}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: defaultColor,
    leading: leading,
    elevation: 0,
    title: Text(
      text,
      style: TextStyle(color: Colors.white),
    ),
  );
}

Widget elevetion({double? size}) => Container(
      height: size!,
      width: double.infinity,
      alignment: AlignmentDirectional.bottomEnd,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 3,
            color: defaultColorTwo.withOpacity(0.05),
          ),
          Container(
            width: double.infinity,
            height: 3,
            color: defaultColorTwo.withOpacity(0.1),
          ),
          Container(
            width: double.infinity,
            height: 3,
            color: defaultColorTwo.withOpacity(0.15),
          ),
          Container(
            width: double.infinity,
            height: 3,
            color: defaultColorTwo.withOpacity(0.2),
          ),
          Container(
            width: double.infinity,
            height: 3,
            color: defaultColorTwo.withOpacity(0.25),
          ),
          Container(
            width: double.infinity,
            height: 3,
            color: defaultColorTwo.withOpacity(0.3),
          ),
          Container(
            width: double.infinity,
            height: 3,
            color: defaultColorTwo.withOpacity(0.35),
          ),
          Container(
            width: double.infinity,
            height: 3,
            color: defaultColorTwo.withOpacity(0.4),
          ),
          Container(
            width: double.infinity,
            height: 3,
            color: defaultColorTwo.withOpacity(0.45),
          ),
          Container(
            width: double.infinity,
            height: 3,
            color: defaultColorTwo.withOpacity(0.5),
          ),
          Container(
            width: double.infinity,
            height: 3,
            color: defaultColorTwo.withOpacity(0.55),
          ),
          Container(
            width: double.infinity,
            height: 5,
            color: defaultColorTwo.withOpacity(0.6),
          ),
          Container(
            width: double.infinity,
            height: 5,
            color: defaultColorTwo.withOpacity(0.7),
          ),
          Container(
            width: double.infinity,
            height: 5,
            color: defaultColorTwo.withOpacity(0.8),
          ),
          Container(
            width: double.infinity,
            height: 5,
            color: defaultColorTwo.withOpacity(0.9),
          ),
          Container(
            width: double.infinity,
            height: 5,
            color: defaultColorTwo,
          ),
        ],
      ),
    );

buildListItems(AnnouncementModel model,index,context,{bool edit = false}) {
  var cubit = MedCubit.get(context);
  return InkWell(
    onTap: () {
      cubit.showAnnouncement(postId: model.productId!);
      cubit.searchController.text = '';
      navigateTo(context, ShowAnnouncement());
    },
    child: Card(
      elevation: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              Image(
                image: NetworkImage(
                  model.image!
                ),
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.error),
              ),
                if(model.isSpacial!)
                  Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    width: 120,
                    height: 40,
                    color: Colors.indigoAccent.withOpacity(0.8),
                    child: Text(
                      'عرض مميز',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              elevetion(size: 170),
              Container(
                height: 170,
                width: double.infinity,
                alignment: AlignmentDirectional.bottomEnd,
                padding: EdgeInsetsDirectional.all(15),
                child: Text(
                  model.title!,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              model.des!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                 IconButton(
                        onPressed: () {
                          if(uId != null){
                            cubit.changeFav(model.productId!);
                          }else{
                            navigateTo(context, LoginScreen());
                          }
                            },
                        icon: Icon(
                            cubit.favorites[model.productId] != null ? MedCubit.get(context).favorites[model.productId]! ?Icons.favorite:Icons.favorite_border:Icons.favorite_border,
                          color: cubit.favorites[model.productId] != null ? cubit.favorites[model.productId]! ?Colors.red:Colors.grey:Colors.grey
                        ),
                      ),
                Spacer(),
                Text(
                  'جنية',
                  style: TextStyle(color: defaultColor),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  model.price!,
                  style: TextStyle(color: defaultColor),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            height: 70,
            child: Card(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Text(
                          date.DateFormat.yMMMMd().format(model.createdAt!).toString(),
                        ),
                        Icon(
                          Icons.watch_later_outlined,
                          color: Colors.black45,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Text(
                         model.type!,
                        ),
                        Icon(
                          Icons.local_offer,
                          size: 30,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(model.address!),
                        Icon(
                          Icons.location_on,
                          size: 30,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if(edit)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      openDialog(context,model.productId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(5),),
                      ),
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  Spacer(),
                  defaultButton(
                      function: (){
                        navigateTo(context, EditAnnoScreen(id: model.productId,));
                      },
                      text: 'تعديل الاعلان',
                      width: 140
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

Future openDialog(context , id) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      content: Container(
        height: 180,
        width: 120,
        child: Column(
          children: [
            Text(
              'حذف الاعلان',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              'في حالة حذف الاعلان سوف يتم الحذف نهائيا ولا يمكن الرجوع عن هذه الخطوة فيما بعد',
              textAlign: TextAlign.center,
            ),
            Container(
              color: Colors.black,
              width: double.infinity,
              height: 1,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child:Text(
                      'الغاء',
                      style: TextStyle(
                          color: Colors.black38
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black,
                  width: 1,
                  height: 47,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: (){
                      MedCubit.get(context).deleteAnnouncementImage(id);
                      Navigator.pop(context);
                    },
                    child:Text(
                      'حذف',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );}



