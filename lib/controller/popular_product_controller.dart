import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/controller/cart_controller.dart';
import 'package:food_delivery_flutter/models/cart_model.dart';
import 'package:food_delivery_flutter/models/products_model.dart';
import 'package:food_delivery_flutter/repository/popular_product_repo.dart';
import 'package:food_delivery_flutter/utils/app_colors.dart';
import 'package:get/get.dart';

class PopularProductController extends GetxController{
  final PopularProductRepo popularProductRepo;
  PopularProductController({ required this.popularProductRepo});
  List<dynamic> _popularProductList = [];
  List<dynamic> get popularProductList =>_popularProductList;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _quantity=0;
  int get quantity =>_quantity;

  int _inCartItems = 0;
  int get inCartItem=> _inCartItems + _quantity ;
  late CartController _cart;

  Future<void> getPopularProductList() async{
    Response response = await popularProductRepo.getPopularProductList();
    if(response.statusCode == 200){
     // print('all products');
      _popularProductList = [];
      _popularProductList.addAll(Product.fromJson(response.body).products);
      _isLoaded = true;
      update();
    }else{
     // print('not');
    }
  }

  void setQuantity(bool isIncrement){
    if(isIncrement){
      print('increment');
      _quantity = checkQuantity(_quantity+1);
    }else{
      _quantity = checkQuantity(_quantity-1);
    }
    update();
  }

  int checkQuantity(int quantity){
    if((_inCartItems+quantity)<0){
      Get.snackbar('Item count', "You can't reduce more",
      backgroundColor: AppColors.MainColor,
      colorText: Colors.white
      );
      if(_inCartItems>0){
        _quantity = - _inCartItems;
        return _quantity;
      }
      return 0;
    }else if((_inCartItems+quantity)>20){
      Get.snackbar('Item count', "You can't add more",
          backgroundColor: AppColors.MainColor,
          colorText: Colors.white
      );
      return 20;
    }else{
      return quantity;
    }
  }
  void initProduct(ProductModel product, CartController cart){
    _quantity = 0;
    _inCartItems = 0;
    _cart = cart;
    var exist = false;
    exist = _cart.exitInCart(product);
    print ('exit or not'+ exist.toString());

    if(exist){
      _inCartItems = _cart.getQuantity(product);
      print('quantity in the cart'+ _inCartItems.toString());
    }
  }

  void addItem(ProductModel product){
   // if(_quantity>0){
      _cart.addItem(product, _quantity);
      _quantity = 0;
      _inCartItems = _cart.getQuantity(product);
      _cart.items.forEach((key, value) {
        print ('id is '+value.id.toString() + 'quantity is '+value.quantity.toString());
      });
    update();

  }

  int get totalItems{
    return _cart.totalItems;
  }

  List<CartModel> get getItems{
    return _cart.getItems;
  }


}