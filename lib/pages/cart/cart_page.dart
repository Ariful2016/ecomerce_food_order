import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/base/no_data_page.dart';
import 'package:food_delivery_flutter/controller/cart_controller.dart';
import 'package:food_delivery_flutter/controller/popular_product_controller.dart';
import 'package:food_delivery_flutter/controller/recommended_product_controller.dart';
import 'package:food_delivery_flutter/pages/home/main_food_page.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/app_colors.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:food_delivery_flutter/utils/dimention.dart';
import 'package:food_delivery_flutter/widgets/app_icon.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:food_delivery_flutter/widgets/small_text.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // icons
          Positioned(
              top: Dimensions.height20*2,
              left: Dimensions.width20,
              right: Dimensions.width20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppIcons(icon: Icons.arrow_back_ios,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.MainColor,
                    //size: Dimensions.iconSize30,

                  ),
                  SizedBox(width: Dimensions.width20*5,),
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(RouteHelper.getInitial());
                    },
                    child: AppIcons(icon: Icons.home,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.MainColor,
                      // size: Dimensions.iconSize30,
                    ),
                  ),
                  AppIcons(icon: Icons.shopping_cart,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.MainColor,
                    //size: Dimensions.iconSize30,

                  ),

                ],
              )),
          // body
          GetBuilder<CartController>(builder: (_cartController){
            return _cartController.getItems.length>0? Positioned(
                top: Dimensions.height20*5,
                left: Dimensions.width20,
                right: Dimensions.width20,
                bottom: 0,
                child: Container(
                  // color: Colors.red,
                  child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: GetBuilder<CartController>(builder: (cartController){
                        var _cartList = cartController.getItems;
                        return  ListView.builder(
                            itemCount: _cartList.length,
                            itemBuilder: (_, index){
                              return Container(
                                height: Dimensions.height20*5,
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap:(){
                                        var popularIndex = Get.find<PopularProductController>()
                                            .popularProductList.indexOf(_cartList[index].product);
                                        if(popularIndex>=0){
                                          Get.toNamed(RouteHelper.getPopularFood(popularIndex, 'cartPage'));
                                        }else{
                                          var recommendedIndex = Get.find<RecommendedProductController>()
                                              .recommendedProductList.indexOf(_cartList[index].product);
                                          if(recommendedIndex<0){
                                            Get.snackbar('History product', 'Product review in not available for history product! ',
                                                backgroundColor: AppColors.MainColor,
                                                colorText: Colors.white);

                                          }else{
                                            Get.toNamed(RouteHelper.getRecommendedFood(recommendedIndex, 'cartPage'));
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: Dimensions.height20*5,
                                        height: Dimensions.height20*5,
                                        margin: EdgeInsets.only(bottom: Dimensions.height10),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    AppConstants.BASE_URL+AppConstants.UPLOAD_URL+cartController.getItems[index].img!
                                                )
                                            ),
                                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.width10,),
                                    Expanded(child: Container(
                                      height: Dimensions.height20*5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          BigText(text: cartController.getItems[index].name!, color: Colors.black54,),
                                          SmallText(text: 'Spicy'),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              BigText(text: '\$'+cartController.getItems[index].price.toString(), color: Colors.redAccent,),
                                              Container(
                                                padding: EdgeInsets.all(Dimensions.height10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                ),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                        onTap: (){
                                                          cartController.addItem(_cartList[index].product!, -1);
                                                        },
                                                        child: Icon(Icons.remove, color: AppColors.signColor,)),
                                                    SizedBox(width: Dimensions.width10/2,),
                                                    BigText(text: _cartList[index].quantity.toString()), //popularProduct.inCartItem.toString()),
                                                    SizedBox(width: Dimensions.width10/2,),
                                                    GestureDetector(
                                                      onTap: (){
                                                        cartController.addItem(_cartList[index].product!, 1);
                                                      },
                                                      child: Icon(Icons.add, color: AppColors.signColor,),
                                                    )

                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              );
                            });
                      })
                  ),
                )) : NoDataPage(text: 'Your cart is empty!');
          })
        ],
      ),
        bottomNavigationBar: GetBuilder<CartController>(builder: (cartController){
          return  Container(
            height: Dimensions.bottomNavHeight,
            padding: EdgeInsets.all(Dimensions.height10),
            decoration: BoxDecoration(
                color: AppColors.buttonBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radius15),
                  topRight:Radius.circular(Dimensions.radius15),
                )
            ),
            child: cartController.getItems.length>0? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.height10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Row(
                    children: [
                      BigText(text: '\$ '+cartController.totalAmount.toString()),

                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    cartController.addToHistory();
                  },
                  child: Container(
                      padding: EdgeInsets.all(Dimensions.height10),
                      decoration: BoxDecoration(
                        color: AppColors.MainColor,
                        borderRadius: BorderRadius.circular(Dimensions.radius15),
                      ),


                      child: BigText(text: ' Check out',color: Colors.white,)),
                )
              ],
            ): Container(),
          );
        },)
    );
  }
}
