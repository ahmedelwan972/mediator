import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediator/layout/cubit/cubit.dart';
import 'package:mediator/layout/cubit/states.dart';
import 'package:mediator/models/get_comment_model.dart';
import 'package:mediator/shared/components/components.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/show_model.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/colors.dart';
import '../auth/login_screen.dart';
import 'package:intl/intl.dart' as date;
import 'google_map_show.dart';

class ShowAnnouncement extends StatelessWidget {
  var desController = TextEditingController();
  var commentController = TextEditingController();
  var replayController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedCubit, MedStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MedCubit.get(context);
        return Scaffold(
          appBar: appBar(
            text: 'اعلان',
            leading: IconButton(
              onPressed: () {
                cubit.showAnnouncementModel = null;
                cubit.getAnnouncement();
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: ConditionalBuilder(
            condition: cubit.showAnnouncementModel != null ,
            builder: (context) => buildShowAnnouncement(
                context, cubit.showAnnouncementModel!, state),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  buildShowAnnouncement(context, ShowAnnouncementModel model, state) {
    var cubit = MedCubit.get(context);
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 400,
              width: double.infinity,
              child: Image(
                image: NetworkImage(
                  model.image!,
                ),
                errorBuilder: (context,error,stackTrace)=> Icon(Icons.error),
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${model.title}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    model.des!,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Row(
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
                            cubit.favorites[model.productId] != null && uId != null? MedCubit.get(context).favorites[model.productId]! ?Icons.favorite:Icons.favorite_border:Icons.favorite_border,
                            color: cubit.favorites[model.productId] != null && uId != null? MedCubit.get(context).favorites[model.productId]! ?Colors.red:Colors.grey:Colors.grey
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
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 70,
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
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
                            flex: 2,
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
                                Text(
                                  model.address!,
                                ),
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
                    height: 10,
                  ),
                  Card(
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: Container(
                                    alignment: AlignmentDirectional.center,
                                    height: 60,
                                    width: 80,
                                    child: Text(model.name!),
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'اسم صاحب الاعلان',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Icon(
                                  Icons.person_pin,
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 7,
                        ),
                        TextButton(
                            onPressed: () {
                              openDialog(context, model);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'رقم الهاتف',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.phone,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        state is! GetCurrentLocationLoadingState ?
                        InkWell(
                          onTap: () {
                            cubit.getCurrentLocation().then((value) {
                              cubit.distanceBetween(
                                  endLatitude: model.lat!,
                                  endLongitude: model.long!,
                              );
                              cubit.getAddress();
                              navigateTo(context, GoogleMapForShowScreen());
                            });
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 55,
                            ),
                          ),
                        ):Center(child: CircularProgressIndicator()),
                        SizedBox(
                          width: 22,
                        ),
                        InkWell(
                          onTap: () {
                            cubit.share();
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.share,
                              color: Colors.black45,
                              size: 55,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Card(
                    child: cubit.getCommentModel.isNotEmpty
                        ? Column(mainAxisSize: MainAxisSize.min, children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ' من التعليقات علي الاعلان',
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  cubit.getCommentModel.length.toString(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => buildCommentItem(
                                  cubit.getCommentModel[index], state, context),
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                              itemCount: cubit.getCommentModel.length,
                            ),
                          ])
                        : Center(
                            child: Text(
                              'لا يوجد تعليقات',
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لا يجب ان تكون هذه الخانه فارغة';
                        }
                      },
                      keyboardType: TextInputType.text,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'اكتب تعليق',
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      controller: desController,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  state is! AddCommentLoadingState
                      ? defaultButton(
                          function: () {
                            if(uId !=  null){
                              if (formKey.currentState!.validate()) {
                                cubit.addComment(
                                  comment: desController.text,
                                ).then((value) {
                                  desController.text = '';
                                });
                              }
                            }else{
                              showToast(
                                  msg: 'يجب ان تسجل دخول اولا',
                                  toastState: true);
                              navigateTo(context, LoginScreen());
                            }
                          },
                          text: 'ارسال التعليق',
                        )
                      : Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildCommentItem(GetCommentModel comments, state, context) {
    var cubit = MedCubit.get(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            comments.senderName!,
            style: TextStyle(fontSize: 18, color: defaultColor),
          ),
          SizedBox(
            height: 10,
          ),
          Text(comments.comment!),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  MedCubit.get(context).choseComment(id: comments.commentId!);
                },
                child: Row(
                  children: [
                    Text('رد علي التعليق       '),
                    SizedBox(
                      height: 10,
                    ),
                    Icon(
                      Icons.chat_bubble,
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   width: 10,
              // ),
              // Text('  ' + comments.commentCreatedAt!),
              // SizedBox(
              //   width: 5,
              // ),
              // Icon(
              //   Icons.watch_later_outlined,
              // ),
            ],
          ),
          if (cubit.chooseComment[comments.commentId!]!)
            Column(
              children: [
                defaultFormField(
                    controller: commentController, label: 'رد علي التعليق'),
                SizedBox(
                  height: 5,
                ),
                state is! AddReplayLoadingState
                    ? defaultButton(
                        function: () {
                          if (uId != null) {
                            cubit.addReplay(
                              replay: commentController.text,
                              commentId: comments.commentId!,
                            ).then((value) {
                              commentController.text = '';
                            });
                          } else {
                            showToast(
                                msg: 'يجب ان تسجل دخول اولا',
                                toastState: true);
                            navigateTo(context, LoginScreen());
                          }
                        },
                        text: 'رد')
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          SizedBox(
            height: 10,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => buildReplayItem(
                cubit.getReplayModel[index], state, context, comments),
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemCount: cubit.getReplayModel.length,
          )
        ],
      ),
    );
  }

  buildReplayItem(GetReplayModel replies, state, context, GetCommentModel comments) {
    var cubit = MedCubit.get(context);
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                replies.senderName!,
                style: TextStyle(fontSize: 18, color: defaultColor),
              ),
              SizedBox(
                height: 10,
              ),
              Text(replies.replay!),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      cubit.chooseReplay(id: replies.replayId!);
                    },
                    child: Row(
                      children: [
                        Text('رد علي التعليق     '),
                        SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.chat_bubble,
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // Text('   ' + replies.replyCreatedAt!),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  // Icon(
                  //   Icons.watch_later_outlined,
                  // ),
                ],
              ),
              if (cubit.replayComment[replies.replayId]!)
                Column(
                  children: [
                    defaultFormField(
                        controller: replayController, label: 'رد علي التعليق'),
                    SizedBox(
                      height: 5,
                    ),
                    state is! AddReplayLoadingState
                        ? defaultButton(
                            function: () {
                              if (uId != null) {
                                cubit.addReplay(
                                  commentId: comments.commentId!,
                                  replay: replayController.text,
                                ).then((value) {
                                  replayController.text = '';
                                });
                              } else {
                                showToast(
                                    msg: 'يجب ان تسجل دخول اولا',
                                    toastState: true);
                                navigateTo(context, LoginScreen());
                              }
                            },
                            text: 'رد')
                        : Center(child: CircularProgressIndicator()),
                  ],
                ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future openDialog(context, ShowAnnouncementModel mobiles) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('اتصال'),
          content: Container(
            height: 60,
            width: 100,
            child: TextButton(
              onPressed: () async {
                String phoneNumber = 'tel:${int.parse(mobiles.phone!)}';
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: mobiles.phone.toString(),
                );
                if (await canLaunch(launchUri.toString())) {
                  await launch(launchUri.toString());
                } else {
                  print('we have error' + launchUri.toString());
                }
              },
              child: Text(
                mobiles.phone!,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      );
}
