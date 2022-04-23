import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/controller/cart_controller.dart';
import 'package:food_delivery_flutter/pages/food/popular_food_details.dart';
import 'package:food_delivery_flutter/pages/food/recomended_food_page.dart';
import 'package:food_delivery_flutter/pages/home/main_food_page.dart';
import 'package:food_delivery_flutter/pages/splash/splash_screen.dart';
import 'package:food_delivery_flutter/repository/recommended_product_repo.dart';
import 'package:food_delivery_flutter/routes/route_helper.dart';
import 'package:get/get.dart';
import 'controller/popular_product_controller.dart';
import 'controller/recommended_product_controller.dart';
import 'helper/dependencies.dart' as dep;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  Get.find<CartController>().getCartData();
   return GetBuilder<RecommendedProductController>(builder: (_){
      return GetBuilder<PopularProductController>(builder: (_){
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          //home: SplashScreen(),
          initialRoute: RouteHelper.getSplashPage(),
          getPages: RouteHelper.routes,
        );
      });
    },);

  }
}


