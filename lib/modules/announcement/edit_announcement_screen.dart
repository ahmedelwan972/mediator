import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediator/layout/cubit/cubit.dart';
import 'package:mediator/layout/cubit/states.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import 'google_Map_screen.dart';

class EditAnnoScreen extends StatelessWidget {
  EditAnnoScreen({required this.id});
  String? id;
  var priceController = TextEditingController();
  var addressController = TextEditingController();
  var desController = TextEditingController();
  String? type;
  String? subsection;
  var formKey = GlobalKey<FormState>();
  List<String> listType = [
    'شقة',
    'فيلا',
    'فندق',
    'ارض',
    'محل',
    'ورشة',
  ];
  List<String> listCategory = [
    'ايجار',
    'تمليك',
    'تقسيط',
    'دوبلكس',
    'للبيع',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedCubit, MedStates>(
      listener: (context, state) {
        var cubit = MedCubit.get(context);
        if(state is GetAnnouncementSuccessState){
          Navigator.pop(context);
          type = '';
          subsection = '';
          desController.text = '';
          priceController.text = '';
          addressController.text = '';
          cubit.image = null;
          cubit.myAddressName = '';
          cubit.position = null;
          cubit.isSpacial = false;
          cubit.image = null;
        }
      },
      builder: (context, state) {
        var cubit = MedCubit.get(context);
        return Scaffold(
          appBar: appBar(text: 'تعديل الاعلان',
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
            type = '';
            subsection = '';
            desController.text = '';
            priceController.text = '';
            addressController.text = '';
            cubit.image = null;
            cubit.myAddressName = '';
            cubit.position = null;
            cubit.isSpacial = false;
            cubit.image = null;
          }, icon: Icon(
            Icons.arrow_back
          ))),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    defaultFormField(
                        controller: addressController,
                        label: 'عنوان الاعلان',
                        suffix: Icons.title,
                        type: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'هذه الخانة فارغة';
                          }
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    defaultFormField(
                        controller: priceController,
                        label: 'سعر بيع المنتج او الخدمة',
                        suffix: Icons.price_change,
                        type: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'هذه الخانة فارغة';
                          }
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      hint: Text('النوع'),
                      onChanged: (value) => type = value as String?,
                      items: listType.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      hint: Text('قسم فرعي'),
                      onChanged: (value) => subsection = value as String?,
                      items:
                      listCategory.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20,
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
                          hintText: 'ادخل وصف شامل للاعلان الخاص بك',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        controller: desController,
                      ),
                    ),
                    defaultButton(
                      function: () {
                        cubit.selectImages();
                      },
                      text: 'ارفاق الصور',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (cubit.image != null)
                      Stack(
                        children: [
                          Container(
                            height: 220,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: Image(
                              image: FileImage(
                                cubit.image!,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                cubit.image = null;
                                cubit.justEmitState();
                              },
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              )),
                        ],
                      ),
                    if (cubit.image != null)
                      SizedBox(
                        height: 20,
                      ),
                    state is! GetCurrentLocationLoadingState
                        ? defaultButton(
                      function: () {
                        cubit.getCurrentLocation().then((value) {
                          cubit.getAddress();
                          navigateTo(context, GoogleMapScreen());
                        });
                      },
                      text: 'حدد موقعك',
                    )
                        : Center(child: CircularProgressIndicator()),
                    TextButton(
                      onPressed: () {
                        cubit.changeIsSpecial();
                      },
                      child: Row(
                        children: [
                          Icon(
                            cubit.isSpacial
                                ? Icons.check_box
                                : Icons.check_box_outline_blank_sharp,
                            color: cubit.isSpacial
                                ? defaultColor
                                : Colors.black,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            'هل اعلانك مميز',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    state is! UpdateImageLoadingState
                        ? defaultButton(
                      function: () {
                        if (formKey.currentState!.validate()) {
                          if (cubit.image != null) {
                            if (cubit.position != null) {
                              cubit.editAnnouncements(
                                type: type!,
                                category: subsection!,
                                des: desController.text,
                                price: priceController.text,
                                title: addressController.text,
                                announId: id!,
                              );
                            } else {
                              showToast(
                                  msg: 'يجب ان تحدد مكانك',
                                  toastState: true);
                            }
                          } else {
                            showToast(
                                msg: 'اضف صوره', toastState: true);
                          }
                        }
                      },
                      text: 'ارسال الاعلان',
                    )
                        : Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
