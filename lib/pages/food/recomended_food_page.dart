import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/controller/popular_product_controller.dart';
import 'package:food_delivery_flutter/controller/recommended_product_controller.dart';
import 'package:food_delivery_flutter/pages/cart/cart_page.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:food_delivery_flutter/utils/app_colors.dart';
import 'package:food_delivery_flutter/utils/app_constants.dart';
import 'package:food_delivery_flutter/utils/dimention.dart';
import 'package:food_delivery_flutter/widgets/app_icon.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';
import 'package:food_delivery_flutter/widgets/expendable_txt.dart';
import 'package:get/get.dart';

import '../../controller/cart_controller.dart';

class RecomendedFoodPage extends StatelessWidget {
 final int pageId;
 final String page;
 const RecomendedFoodPage({Key? key, required this.pageId, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product = Get.find<RecommendedProductController>().recommendedProductList[pageId];
    Get.find<PopularProductController>().initProduct(product, Get.find<CartController>());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                      if (page == 'cartPage') {
                        Get.toNamed(RouteHelper.getCartPage());
                      } else {
                        Get.toNamed(RouteHelper.getInitial());
                      }
                  },
                    child: AppIcons(icon: Icons.clear)),
                GetBuilder<PopularProductController>(builder: (controller){
                  return GestureDetector(
                    onTap:(){
                      if(controller.totalItems>=1)
                      Get.toNamed(RouteHelper.getCartPage());
                    },
                    child: Stack(
                      children: [
                        AppIcons(icon: Icons.shopping_cart_outlined),
                        Get.find<PopularProductController>().totalItems>=1?
                        Positioned(
                          right:0, top:0,
                          child: AppIcons(icon: Icons.circle, size: 20,
                            iconColor: Colors.transparent,
                            backgroundColor: AppColors.MainColor,),

                        ): Container(),
                        Get.find<PopularProductController>().totalItems>=1?
                        Positioned(
                            right:3, top:3,
                            child:BigText(text: Get.find<PopularProductController>().totalItems.toString(),
                              size: 12,
                              color: Colors.white,)
                        ): Container(),

                      ],
                    ),
                  );
                }),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                width: double.maxFinite,
                child: Center(child: BigText(text: product.name!, size: Dimensions.font24,)),
                padding: EdgeInsets.only(top: Dimensions.height10/2, bottom: Dimensions.height10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20),
                    topRight: Radius.circular(Dimensions.radius20),
                  )
                ),
              ),
            ),
            pinned: true,
            backgroundColor: AppColors.yellowColor,
            expandedHeight: 280,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                AppConstants.BASE_URL+AppConstants.UPLOAD_URL+product.img!,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  child: ExpendableText( text: product.description!),
                  margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                )
              ],
            )

          )
        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder: (controller){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: Dimensions.width20*4,
                  right: Dimensions.width20*4,
                  top: Dimensions.height10,
                  bottom: Dimensions.height10
              ),
              child: Column(

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          controller.setQuantity(false);
                        },
                        child: AppIcons(
                          size: Dimensions.iconSize30,
                          icon: Icons.remove,
                          iconColor: Colors.white,
                          backgroundColor: AppColors.MainColor,),
                      ),
                      BigText(text: '\$${product.price!}  X  ${controller.inCartItem}', color: AppColors.mainBlackColor, size: Dimensions.font24,),
                      GestureDetector(
                        onTap: (){
                          controller.setQuantity(true);
                        },
                        child: AppIcons(
                          size: Dimensions.iconSize30,
                          icon: Icons.add,
                          iconColor: Colors.white,
                          backgroundColor: AppColors.MainColor,),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: Dimensions.bottomNavHeight,
              padding: EdgeInsets.all(Dimensions.height10),
              decoration: BoxDecoration(
                  color: AppColors.buttonBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius15),
                    topRight:Radius.circular(Dimensions.radius15),
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.all(Dimensions.height10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: AppColors.MainColor,
                        size: Dimensions.iconSize30,
                      )
                  ),
                 GestureDetector(
                   onTap: (){
                     controller.addItem(product);
                   },
                   child:  Container(
                     padding: EdgeInsets.all(Dimensions.height10),
                     decoration: BoxDecoration(
                       color: AppColors.MainColor,
                       borderRadius: BorderRadius.circular(Dimensions.radius15),
                     ),
                     child: BigText(text: '\$${product.price!} | Add to cart',color: Colors.white,),
                   ),
                 )
                ],
              ),
            ),
          ],
        );
      },)

    );
  }
}
