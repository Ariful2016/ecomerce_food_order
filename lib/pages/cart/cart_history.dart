import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/base/no_data_page.dart';
import 'package:food_delivery_flutter/controller/cart_controller.dart';
import 'package:food_delivery_flutter/models/cart_model.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/app_colors.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:food_delivery_flutter/utils/dimention.dart';
import 'package:food_delivery_flutter/widgets/app_icon.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:food_delivery_flutter/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var getCartHistoryList = Get.find<CartController>()
        .getCartHistoryList().reversed.toList();
    Map<String, int> cartItemsPreOrder = Map();

    for(int i=0; i<getCartHistoryList.length; i++){
      if(cartItemsPreOrder.containsKey(getCartHistoryList[i].time)){
        cartItemsPreOrder.update(getCartHistoryList[i].time!, (value) =>++value);
      }else{
        cartItemsPreOrder.putIfAbsent(getCartHistoryList[i].time!, () =>1);
      }
    }
    List<int> cartItemsPrtOrderToList(){
      return cartItemsPreOrder.entries.map((e) => e.value).toList();
    }
    List<String> cartOrderToList(){
      return cartItemsPreOrder.entries.map((e) => e.key).toList();
    }
    List<int> itemsPreOrder = cartItemsPrtOrderToList();
    var listCounters= 0;

    Widget timeWidget(int index){
      var outputDate = DateTime.now().toString();
      if(index<getCartHistoryList.length){
        DateTime parseDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(getCartHistoryList[listCounters].time!);
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat = DateFormat('dd/MM/yyyy hh:mm a');
        outputDate = outputFormat.format(inputDate);
      }
      return BigText(text: outputDate , color: AppColors.titleColor,);
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: Dimensions.height20*4,
            color: AppColors.MainColor,
            width: double.maxFinite,
            padding: EdgeInsets.only(top: Dimensions.height20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BigText(text: 'Cart History', color: Colors.white,),
                AppIcons(icon: Icons.shopping_cart_outlined,
                  iconColor: AppColors.MainColor,
                  backgroundColor: Colors.white,
                )
                //Icon(icon)
              ],
            ),
          ),
          GetBuilder<CartController>(builder: (_cartController){
            return _cartController.getCartHistoryList().length>0? Expanded(
                child: Container(
                    margin: EdgeInsets.only(
                      top: Dimensions.height20,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                    ),
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView(
                        children: [
                          for(int i = 0; i<itemsPreOrder.length; i++)
                            Container(
                              height: Dimensions.height20*6,
                              margin: EdgeInsets.only(bottom: Dimensions.height20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  timeWidget(listCounters,),
                                  SizedBox(height: Dimensions.height10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                          direction: Axis.horizontal,
                                          children: List.generate(itemsPreOrder[i], (index) {
                                            if(listCounters<getCartHistoryList.length){
                                              listCounters++;
                                            }
                                            return index<=2? Container(
                                              margin: EdgeInsets.only(right: Dimensions.width10/2),
                                              height: Dimensions.height20*4,
                                              width: Dimensions.height20*4,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(Dimensions.radius15/2),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        AppConstants.BASE_URL+AppConstants.UPLOAD_URL+getCartHistoryList[listCounters-1].img!,
                                                      )
                                                  )
                                              ),
                                            ) : Container();
                                          })
                                      ),
                                      Container(
                                        height: Dimensions.height20*4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            SmallText(text: 'Total', color: AppColors.titleColor),
                                            BigText(text: itemsPreOrder[i].toString()+ ' Items', color: AppColors.titleColor,),
                                            GestureDetector(
                                              onTap: (){
                                                var orderTime = cartOrderToList();
                                                //print ('order time'+ orderTime[i].toString());
                                                Map<int, CartModel> moreOder={};
                                                for(int j=0; j<getCartHistoryList.length; j++){
                                                  if(getCartHistoryList[j].time == orderTime[i]){
                                                    moreOder.putIfAbsent(getCartHistoryList[j].id!, () =>
                                                        CartModel.fromJson(jsonDecode(jsonEncode(getCartHistoryList[j])))
                                                    );
                                                  }
                                                }
                                                Get.find<CartController>().setItems = moreOder;
                                                Get.find<CartController>().addToCartList();
                                                Get.toNamed(RouteHelper.getCartPage());
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: Dimensions.width10,
                                                    vertical: Dimensions.height10/3),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(Dimensions.radius15/3),
                                                    border: Border.all(width: 1, color: AppColors.MainColor)
                                                ),
                                                child: SmallText(text: 'one more', color: AppColors.MainColor,),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )

                        ],
                      ),)
                ))
                : Container(
              height: MediaQuery.of(context).size.height/1.5,
                    child: NoDataPage(
                      text: "You didn't buy anything so far !",
                      imagePath: 'assets/images/empty_box2.png',
                    ) ,
            );
          })
        ],
      ),
    );
  }
}
